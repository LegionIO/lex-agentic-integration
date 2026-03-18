# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Tapestry
          module Helpers
            class Thread
              attr_reader :id, :thread_type, :domain, :content,
                          :color, :created_at, :tapestry_id
              attr_accessor :strength

              COLOR_MAP = {
                experience: :gold,
                belief:     :silver,
                memory:     :blue,
                emotion:    :crimson,
                narrative:  :violet
              }.freeze

              def initialize(thread_type:, domain:, content:,
                             strength: nil, color: nil)
                validate_thread_type!(thread_type)
                @id          = SecureRandom.uuid
                @thread_type = thread_type.to_sym
                @domain      = domain.to_sym
                @content     = content.to_s
                @strength    = (strength || 0.5).to_f.clamp(0.0, 1.0).round(10)
                @color       = (color || default_color(thread_type)).to_sym
                @created_at  = Time.now.utc
                @tapestry_id = nil
              end

              def woven_into!(tapestry_id)
                @tapestry_id = tapestry_id
                self
              end

              def unwoven!
                @tapestry_id = nil
                self
              end

              def reinforce!(rate: Constants::TENSION_RATE)
                @strength = (@strength + rate.abs).clamp(0.0, 1.0).round(10)
                self
              end

              def fray!(rate: Constants::FRAY_RATE)
                @strength = (@strength - rate.abs).clamp(0.0, 1.0).round(10)
                self
              end

              def snap?
                @strength <= 0.0
              end

              def taut?
                @strength >= 0.9
              end

              def woven?
                !@tapestry_id.nil?
              end

              def loose?
                @tapestry_id.nil?
              end

              def thread_integrity
                Constants.label_for(Constants::INTEGRITY_LABELS, @strength)
              end

              def to_h
                {
                  id:               @id,
                  thread_type:      @thread_type,
                  domain:           @domain,
                  content:          @content,
                  strength:         @strength,
                  color:            @color,
                  thread_integrity: thread_integrity,
                  woven:            woven?,
                  loose:            loose?,
                  snap:             snap?,
                  taut:             taut?,
                  tapestry_id:      @tapestry_id,
                  created_at:       @created_at
                }
              end

              private

              def default_color(type)
                COLOR_MAP.fetch(type.to_sym, :grey)
              end

              def validate_thread_type!(val)
                return if Constants::THREAD_TYPES.include?(val.to_sym)

                raise ArgumentError,
                      "unknown thread_type: #{val.inspect}; " \
                      "must be one of #{Constants::THREAD_TYPES.inspect}"
              end
            end
          end
        end
      end
    end
  end
end
