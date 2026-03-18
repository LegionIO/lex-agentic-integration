# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Tessellation
          class Client
            include Runners::CognitiveTessellation

            def initialize
              @default_engine = Helpers::TessellationEngine.new
            end
          end
        end
      end
    end
  end
end
