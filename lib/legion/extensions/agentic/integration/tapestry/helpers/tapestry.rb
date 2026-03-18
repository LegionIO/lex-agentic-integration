# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Tapestry
          module Helpers
            class Tapestry
              attr_reader :id, :name, :pattern, :capacity, :thread_ids, :created_at

              def initialize(name:, pattern:, capacity: 50)
                validate_pattern!(pattern)
                @id         = SecureRandom.uuid
                @name       = name.to_s
                @pattern    = pattern.to_sym
                @capacity   = capacity.to_i.clamp(1, 500)
                @thread_ids = []
                @created_at = Time.now.utc
              end

              def weave_thread(thread_id)
                return false if @thread_ids.include?(thread_id)
                return false if full?

                @thread_ids << thread_id
                true
              end

              def unravel_thread(thread_id)
                @thread_ids.delete(thread_id) ? true : false
              end

              def size
                @thread_ids.size
              end

              def full?
                @thread_ids.size >= @capacity
              end

              def empty?
                @thread_ids.empty?
              end

              def completeness
                return 0.0 if @capacity.zero?

                (@thread_ids.size.to_f / @capacity).clamp(0.0, 1.0).round(10)
              end

              def age!(fray_rate: Constants::FRAY_RATE)
                fray_rate
              end

              def repair!(boost: 0.1)
                boost
              end

              def fraying?(threads)
                return false if empty?

                avg = average_strength(threads)
                avg < 0.3
              end

              def masterwork?(threads)
                return false if empty?

                avg = average_strength(threads)
                avg >= 0.9 && completeness >= 0.9
              end

              def coherence_score(threads)
                return 0.0 if empty?

                placed = threads.select { |t| @thread_ids.include?(t.id) }
                return 0.0 if placed.empty?

                type_diversity = placed.map(&:thread_type).uniq.size.to_f / Constants::THREAD_TYPES.size
                avg_str        = placed.sum(&:strength) / placed.size
                pattern_bonus  = pattern_coherence_factor
                ((avg_str * 0.5) + (type_diversity * 0.3) + (pattern_bonus * 0.2)).clamp(0.0, 1.0).round(10)
              end

              def completeness_label
                Constants.label_for(Constants::INTEGRITY_LABELS, completeness)
              end

              def complexity_label(threads)
                Constants.label_for(Constants::COMPLEXITY_LABELS, coherence_score(threads))
              end

              def gap_count
                @capacity - @thread_ids.size
              end

              def to_h(threads = [])
                {
                  id:                 @id,
                  name:               @name,
                  pattern:            @pattern,
                  capacity:           @capacity,
                  size:               size,
                  completeness:       completeness,
                  completeness_label: completeness_label,
                  coherence_score:    coherence_score(threads),
                  gap_count:          gap_count,
                  full:               full?,
                  empty:              empty?,
                  fraying:            fraying?(threads),
                  masterwork:         masterwork?(threads),
                  thread_ids:         @thread_ids.dup,
                  created_at:         @created_at
                }
              end

              private

              def average_strength(threads)
                placed = threads.select { |t| @thread_ids.include?(t.id) }
                return 0.0 if placed.empty?

                placed.sum(&:strength) / placed.size
              end

              def pattern_coherence_factor
                { plain: 0.6, twill: 0.7, satin: 0.8, brocade: 1.0 }.fetch(@pattern, 0.5)
              end

              def validate_pattern!(val)
                return if Constants::WEAVE_PATTERNS.include?(val.to_sym)

                raise ArgumentError,
                      "unknown pattern: #{val.inspect}; " \
                      "must be one of #{Constants::WEAVE_PATTERNS.inspect}"
              end
            end
          end
        end
      end
    end
  end
end
