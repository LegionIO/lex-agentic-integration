# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Tapestry
          module Helpers
            class LoomEngine
              def initialize
                @threads    = {}
                @tapestries = {}
              end

              def spin_thread(thread_type:, domain:, content:,
                              strength: nil, color: nil)
                raise ArgumentError, 'thread limit reached' if @threads.size >= Constants::MAX_THREADS

                t = Helpers::Thread.new(
                  thread_type: thread_type,
                  domain:      domain,
                  content:     content,
                  strength:    strength,
                  color:       color
                )
                @threads[t.id] = t
                t
              end

              def create_tapestry(name:, pattern:, capacity: 50)
                raise ArgumentError, 'tapestry limit reached' if @tapestries.size >= Constants::MAX_TAPESTRIES

                tap = Tapestry.new(name: name, pattern: pattern, capacity: capacity)
                @tapestries[tap.id] = tap
                tap
              end

              def weave(thread_id:, tapestry_id:)
                thread   = fetch_thread(thread_id)
                tapestry = fetch_tapestry(tapestry_id)

                raise ArgumentError, 'thread already woven' if thread.woven?
                raise ArgumentError, 'tapestry is full'     if tapestry.full?

                tapestry.weave_thread(thread_id)
                thread.woven_into!(tapestry_id)
              end

              def unravel(thread_id:, tapestry_id:)
                thread   = fetch_thread(thread_id)
                tapestry = fetch_tapestry(tapestry_id)

                tapestry.unravel_thread(thread_id)
                thread.unwoven!
              end

              def fray_all!(rate: Constants::FRAY_RATE)
                @threads.each_value { |t| t.fray!(rate: rate) }
                snapped = @threads.count { |_, t| t.snap? }
                { total: @threads.size, snapped: snapped }
              end

              def most_complete(limit: 5)
                @tapestries.values.sort_by { |tap| -tap.completeness }.first(limit)
              end

              def most_coherent(limit: 5)
                threads_arr = @threads.values
                @tapestries.values
                           .sort_by { |tap| -tap.coherence_score(threads_arr) }
                           .first(limit)
              end

              def thread_inventory
                counts = Constants::THREAD_TYPES.to_h { |type| [type, 0] }
                @threads.each_value { |t| counts[t.thread_type] += 1 }
                counts
              end

              def tapestry_report
                threads_arr = @threads.values
                {
                  total_threads:    @threads.size,
                  total_tapestries: @tapestries.size,
                  loose_count:      loose_threads.size,
                  by_type:          thread_inventory,
                  fraying_count:    @tapestries.count { |_, tap| tap.fraying?(threads_arr) },
                  avg_completeness: avg_completeness
                }
              end

              def all_threads
                @threads.values
              end

              def all_tapestries
                @tapestries.values
              end

              def loose_threads
                @threads.values.select(&:loose?)
              end

              private

              def fetch_thread(id)
                @threads.fetch(id) { raise ArgumentError, "thread not found: #{id}" }
              end

              def fetch_tapestry(id)
                @tapestries.fetch(id) { raise ArgumentError, "tapestry not found: #{id}" }
              end

              def avg_completeness
                return 0.0 if @tapestries.empty?

                (@tapestries.values.sum(&:completeness) / @tapestries.size).round(10)
              end
            end
          end
        end
      end
    end
  end
end
