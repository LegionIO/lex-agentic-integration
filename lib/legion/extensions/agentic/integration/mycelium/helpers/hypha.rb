# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mycelium
          module Helpers
            class Hypha
              attr_reader :id, :source_id, :target_id, :nutrient_type,
                          :created_at
              attr_accessor :strength, :state

              def initialize(source_id:, target_id:, nutrient_type:,
                             strength: 0.5)
                validate_nutrient!(nutrient_type)
                @id            = SecureRandom.uuid
                @source_id     = source_id
                @target_id     = target_id
                @nutrient_type = nutrient_type.to_sym
                @strength      = strength.to_f.clamp(0.0, 1.0).round(10)
                @state         = :growing
                @created_at    = Time.now.utc
              end

              def reinforce!(amount: 0.1)
                @strength = (@strength + amount.abs).clamp(0.0, 1.0).round(10)
                @state = :mature if @strength >= 0.6
                self
              end

              def decay!(rate: Constants::NUTRIENT_DECAY)
                @strength = (@strength - rate.abs).clamp(0.0, 1.0).round(10)
                @state = :decaying if @strength < 0.2
                @state = :dormant if @strength < 0.4 && @state == :mature
                self
              end

              def transfer_capacity
                (@strength * Constants::TRANSFER_EFFICIENCY).round(10)
              end

              def active?
                %i[growing mature].include?(@state)
              end

              def to_h
                {
                  id:                @id,
                  source_id:         @source_id,
                  target_id:         @target_id,
                  nutrient_type:     @nutrient_type,
                  strength:          @strength,
                  state:             @state,
                  transfer_capacity: transfer_capacity,
                  active:            active?,
                  created_at:        @created_at
                }
              end

              private

              def validate_nutrient!(val)
                return if Constants::NUTRIENT_TYPES.include?(val.to_sym)

                raise ArgumentError,
                      "unknown nutrient type: #{val.inspect}; " \
                      "must be one of #{Constants::NUTRIENT_TYPES.inspect}"
              end
            end
          end
        end
      end
    end
  end
end
