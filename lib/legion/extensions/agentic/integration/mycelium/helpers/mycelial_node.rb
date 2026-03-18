# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mycelium
          module Helpers
            class MycelialNode
              attr_reader :id, :node_type, :domain, :content, :created_at
              attr_accessor :nutrient_level, :connections_count

              def initialize(node_type:, domain:, content:,
                             nutrient_level: 0.5)
                validate_type!(node_type)
                @id                = SecureRandom.uuid
                @node_type         = node_type.to_sym
                @domain            = domain.to_sym
                @content           = content.to_s
                @nutrient_level    = nutrient_level.to_f.clamp(0.0, 1.0).round(10)
                @connections_count = 0
                @created_at        = Time.now.utc
              end

              def absorb!(amount)
                @nutrient_level = (@nutrient_level + amount.abs).clamp(0.0, 1.0).round(10)
                self
              end

              def deplete!(amount)
                @nutrient_level = (@nutrient_level - amount.abs).clamp(0.0, 1.0).round(10)
                self
              end

              def fruiting_ready?
                @nutrient_level >= Constants::FRUITING_THRESHOLD
              end

              def starving?
                @nutrient_level < 0.1
              end

              def to_h
                {
                  id:                @id,
                  node_type:         @node_type,
                  domain:            @domain,
                  content:           @content,
                  nutrient_level:    @nutrient_level,
                  connections_count: @connections_count,
                  fruiting_ready:    fruiting_ready?,
                  starving:          starving?,
                  created_at:        @created_at
                }
              end

              private

              def validate_type!(val)
                return if Constants::NODE_TYPES.include?(val.to_sym)

                raise ArgumentError,
                      "unknown node type: #{val.inspect}; " \
                      "must be one of #{Constants::NODE_TYPES.inspect}"
              end
            end
          end
        end
      end
    end
  end
end
