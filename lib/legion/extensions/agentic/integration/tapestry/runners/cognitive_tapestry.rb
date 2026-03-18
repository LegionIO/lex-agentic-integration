# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Tapestry
          module Runners
            module CognitiveTapestry
              extend self

              include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

              def spin_thread(thread_type:, domain:, content:,
                              strength: nil, color: nil, engine: nil, **)
                eng = resolve_engine(engine)
                t   = eng.spin_thread(
                  thread_type: thread_type,
                  domain:      domain,
                  content:     content,
                  strength:    strength,
                  color:       color
                )
                { success: true, thread: t.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def create_tapestry(name:, pattern:, capacity: 50, engine: nil, **)
                eng = resolve_engine(engine)
                tap = eng.create_tapestry(name: name, pattern: pattern, capacity: capacity)
                threads_arr = eng.all_threads
                { success: true, tapestry: tap.to_h(threads_arr) }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def weave(thread_id:, tapestry_id:, engine: nil, **)
                eng = resolve_engine(engine)
                t   = eng.weave(thread_id: thread_id, tapestry_id: tapestry_id)
                { success: true, thread: t.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def list_tapestries(engine: nil, pattern: nil, fraying_only: false, **)
                eng         = resolve_engine(engine)
                threads_arr = eng.all_threads
                results     = eng.all_tapestries

                results = results.select { |tap| tap.pattern == pattern.to_sym } if pattern
                results = results.select { |tap| tap.fraying?(threads_arr) }     if fraying_only

                {
                  success:    true,
                  tapestries: results.map { |tap| tap.to_h(threads_arr) },
                  count:      results.size
                }
              end

              def loom_status(engine: nil, **)
                eng = resolve_engine(engine)
                { success: true, report: eng.tapestry_report }
              end

              private

              def resolve_engine(engine)
                engine || default_engine
              end

              def default_engine
                @default_engine ||= Helpers::LoomEngine.new
              end
            end
          end
        end
      end
    end
  end
end
