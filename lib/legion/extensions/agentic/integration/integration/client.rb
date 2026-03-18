# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Integration
          class Client
            include Runners::CognitiveIntegration

            def initialize(engine: nil)
              @default_engine = engine || Helpers::IntegrationEngine.new
            end
          end
        end
      end
    end
  end
end
