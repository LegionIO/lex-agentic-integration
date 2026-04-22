# frozen_string_literal: true

require 'legion/extensions/actors/every'

module Legion
  module Extensions
    module Agentic
      module Integration
        module PhenomenalBinding
          module Actor
            class Decay < Legion::Extensions::Actors::Every
              def runner_class
                Legion::Extensions::Agentic::Integration::PhenomenalBinding::Runners::PhenomenalBinding
              end

              def runner_function
                'decay_all'
              end

              def time
                120
              end

              def run_now?
                false
              end

              def use_runner?
                false
              end

              def check_subtask?
                false
              end

              def generate_task?
                false
              end
            end
          end
        end
      end
    end
  end
end
