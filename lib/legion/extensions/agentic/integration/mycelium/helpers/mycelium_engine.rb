# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mycelium
          module Helpers
            class MyceliumEngine
              def initialize
                @nodes          = {}
                @hyphae         = {}
                @fruiting_bodies = {}
              end

              def create_node(node_type:, domain:, content:,
                              nutrient_level: 0.5)
                validate_capacity!(@nodes, Constants::MAX_NODES, 'nodes')
                node = MycelialNode.new(
                  node_type: node_type, domain: domain,
                  content: content, nutrient_level: nutrient_level
                )
                @nodes[node.id] = node
                node
              end

              def connect(source_id:, target_id:, nutrient_type:,
                          strength: 0.5)
                validate_capacity!(@hyphae, Constants::MAX_HYPHAE, 'hyphae')
                fetch_node!(source_id)
                fetch_node!(target_id)
                hypha = Hypha.new(
                  source_id: source_id, target_id: target_id,
                  nutrient_type: nutrient_type, strength: strength
                )
                @hyphae[hypha.id] = hypha
                increment_connections(source_id, target_id)
                hypha
              end

              def transfer_nutrients(hypha_id:)
                hypha  = fetch_hypha!(hypha_id)
                source = fetch_node!(hypha.source_id)
                target = fetch_node!(hypha.target_id)
                amount = [hypha.transfer_capacity, source.nutrient_level].min
                source.deplete!(amount)
                target.absorb!(amount)
                { transferred: amount, source: source.to_h, target: target.to_h }
              end

              def fruit!(node_id:, fruiting_type:, content:)
                validate_capacity!(@fruiting_bodies,
                                   Constants::MAX_FRUITING_BODIES, 'fruiting bodies')
                node = fetch_node!(node_id)
                raise ArgumentError, 'node not ready for fruiting' unless node.fruiting_ready?

                body = FruitingBody.new(
                  fruiting_type: fruiting_type, source_node_id: node_id,
                  content: content, potency: node.nutrient_level
                )
                node.deplete!(0.3)
                @fruiting_bodies[body.id] = body
                body
              end

              def decay_network!(rate: Constants::NUTRIENT_DECAY)
                @hyphae.each_value { |h| h.decay!(rate: rate) }
                @nodes.each_value { |n| n.deplete!(rate * 0.5) }
                prune_dead!
                { nodes: @nodes.size, hyphae: @hyphae.size }
              end

              def all_nodes
                @nodes.values
              end

              def all_hyphae
                @hyphae.values
              end

              def all_fruiting_bodies
                @fruiting_bodies.values
              end

              def connections_for(node_id)
                @hyphae.values.select do |h|
                  h.source_id == node_id || h.target_id == node_id
                end
              end

              def network_report
                {
                  total_nodes:    @nodes.size,
                  total_hyphae:   @hyphae.size,
                  total_fruiting: @fruiting_bodies.size,
                  active_hyphae:  @hyphae.values.count(&:active?),
                  avg_nutrient:   avg_field(@nodes, :nutrient_level),
                  avg_strength:   avg_field(@hyphae, :strength),
                  fruiting_ready: @nodes.values.count(&:fruiting_ready?),
                  starving_nodes: @nodes.values.count(&:starving?),
                  network_health: network_health_label
                }
              end

              private

              def fetch_node!(id)
                @nodes.fetch(id) do
                  raise ArgumentError, "node not found: #{id.inspect}"
                end
              end

              def fetch_hypha!(id)
                @hyphae.fetch(id) do
                  raise ArgumentError, "hypha not found: #{id.inspect}"
                end
              end

              def validate_capacity!(coll, max, name)
                return if coll.size < max

                raise ArgumentError,
                      "#{name} capacity reached (max #{max})"
              end

              def increment_connections(source_id, target_id)
                @nodes[source_id].connections_count += 1
                @nodes[target_id].connections_count += 1
              end

              def prune_dead!
                @hyphae.delete_if { |_, h| h.strength <= 0.0 }
              end

              def avg_field(coll, field)
                return 0.0 if coll.empty?

                (coll.values.sum(&field) / coll.size).round(10)
              end

              def network_health_label
                avg = avg_field(@nodes, :nutrient_level)
                Constants.label_for(Constants::NETWORK_HEALTH_LABELS, avg)
              end
            end
          end
        end
      end
    end
  end
end
