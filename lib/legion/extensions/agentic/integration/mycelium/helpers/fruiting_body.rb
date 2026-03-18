# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mycelium
          module Helpers
            class FruitingBody
              attr_reader :id, :fruiting_type, :source_node_id,
                          :content, :potency, :emerged_at

              def initialize(fruiting_type:, source_node_id:,
                             content:, potency: 0.5)
                validate_type!(fruiting_type)
                @id             = SecureRandom.uuid
                @fruiting_type  = fruiting_type.to_sym
                @source_node_id = source_node_id
                @content        = content.to_s
                @potency        = potency.to_f.clamp(0.0, 1.0).round(10)
                @emerged_at     = Time.now.utc
              end

              def to_h
                {
                  id:             @id,
                  fruiting_type:  @fruiting_type,
                  source_node_id: @source_node_id,
                  content:        @content,
                  potency:        @potency,
                  emerged_at:     @emerged_at
                }
              end

              private

              def validate_type!(val)
                return if Constants::FRUITING_TYPES.include?(val.to_sym)

                raise ArgumentError,
                      "unknown fruiting type: #{val.inspect}; " \
                      "must be one of #{Constants::FRUITING_TYPES.inspect}"
              end
            end
          end
        end
      end
    end
  end
end
