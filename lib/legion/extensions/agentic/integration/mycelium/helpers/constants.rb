# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mycelium
          module Helpers
            module Constants
              MAX_NODES           = 200
              MAX_HYPHAE          = 500
              MAX_FRUITING_BODIES = 100
              NUTRIENT_DECAY      = 0.03
              TRANSFER_EFFICIENCY = 0.8
              FRUITING_THRESHOLD  = 0.7

              NODE_TYPES = %i[
                knowledge_cluster insight_node memory_node
                skill_node pattern_node creative_node
              ].freeze

              NUTRIENT_TYPES = %i[
                information experience emotional_energy
                novelty pattern_recognition creative_potential
              ].freeze

              HYPHA_STATES = %i[growing mature dormant decaying].freeze

              FRUITING_TYPES = %i[
                insight breakthrough connection analogy
                synthesis innovation
              ].freeze

              NETWORK_HEALTH_LABELS = [
                [0.8..1.0, :thriving],
                [0.6..0.8, :healthy],
                [0.4..0.6, :stable],
                [0.2..0.4, :stressed],
                [0.0..0.2, :depleted]
              ].freeze

              def self.label_for(table, value)
                table.each { |range, label| return label if range.cover?(value) }
                table.last.last
              end
            end
          end
        end
      end
    end
  end
end
