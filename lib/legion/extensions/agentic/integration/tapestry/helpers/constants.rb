# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Tapestry
          module Helpers
            module Constants
              THREAD_TYPES = %i[experience belief memory emotion narrative].freeze

              WEAVE_PATTERNS = %i[plain twill satin brocade].freeze

              MAX_THREADS    = 500
              MAX_TAPESTRIES = 50
              TENSION_RATE   = 0.05
              FRAY_RATE      = 0.03

              INTEGRITY_LABELS = [
                [(0.9..),      :masterwork],
                [(0.7...0.9),  :sturdy],
                [(0.5...0.7),  :woven],
                [(0.3...0.5),  :fraying],
                [(0.1...0.3),  :tattered],
                [..0.1,        :rags]
              ].freeze

              COMPLEXITY_LABELS = [
                [(0.85..),     :baroque],
                [(0.65...0.85), :elaborate],
                [(0.45...0.65), :patterned],
                [(0.25...0.45), :plain_woven],
                [..0.25,   :simple]
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
