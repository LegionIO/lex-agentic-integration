# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mycelium
          module Runners
            module CognitiveMycelium
              include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                          Legion::Extensions::Helpers.const_defined?(:Lex, false)

              def create_node(node_type:, domain:, content:,
                              nutrient_level: 0.5, engine: nil, **)
                eng  = resolve_engine(engine)
                node = eng.create_node(node_type: node_type, domain: domain,
                                       content: content,
                                       nutrient_level: nutrient_level)
                log.debug("[cognitive_mycelium] create_node: type=#{node_type} domain=#{domain}")
                { success: true, node: node.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def connect(source_id:, target_id:, nutrient_type:,
                          strength: 0.5, engine: nil, **)
                eng   = resolve_engine(engine)
                hypha = eng.connect(source_id: source_id, target_id: target_id,
                                    nutrient_type: nutrient_type,
                                    strength: strength)
                log.debug("[cognitive_mycelium] connect: source=#{source_id[0..7]} target=#{target_id[0..7]}")
                { success: true, hypha: hypha.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def transfer_nutrients(hypha_id:, engine: nil, **)
                eng    = resolve_engine(engine)
                result = eng.transfer_nutrients(hypha_id: hypha_id)
                log.debug("[cognitive_mycelium] transfer_nutrients: hypha_id=#{hypha_id[0..7]}")
                { success: true }.merge(result)
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def fruit(node_id:, fruiting_type:, content:, engine: nil, **)
                eng  = resolve_engine(engine)
                body = eng.fruit!(node_id: node_id, fruiting_type: fruiting_type,
                                  content: content)
                log.debug("[cognitive_mycelium] fruit: node_id=#{node_id[0..7]} type=#{fruiting_type}")
                { success: true, fruiting_body: body.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def network_status(engine: nil, **)
                eng = resolve_engine(engine)
                log.debug('[cognitive_mycelium] network_status')
                { success: true, report: eng.network_report }
              end

              private

              def resolve_engine(engine)
                engine || default_engine
              end

              def default_engine
                @default_engine ||= Helpers::MyceliumEngine.new
              end
            end
          end
        end
      end
    end
  end
end
