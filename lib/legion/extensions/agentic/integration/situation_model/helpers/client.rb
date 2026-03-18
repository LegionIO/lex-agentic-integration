# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module SituationModel
          module Helpers
            class Client
              include Legion::Extensions::Agentic::Integration::SituationModel::Runners::SituationModel

              private

              def engine
                @engine ||= SituationEngine.new
              end
            end
          end
        end
      end
    end
  end
end
