# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Qualia
          class Client
            include Runners::Qualia

            def initialize
              @default_engine = Helpers::QualiaEngine.new
            end
          end
        end
      end
    end
  end
end
