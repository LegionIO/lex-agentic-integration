# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mycelium
          class Client
            include Runners::CognitiveMycelium

            def initialize(engine: nil)
              @default_engine = engine || Helpers::MyceliumEngine.new
            end
          end
        end
      end
    end
  end
end
