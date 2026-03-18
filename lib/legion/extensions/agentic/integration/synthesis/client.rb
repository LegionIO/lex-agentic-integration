# frozen_string_literal: true

require 'legion/extensions/agentic/integration/synthesis/helpers/constants'
require 'legion/extensions/agentic/integration/synthesis/helpers/synthesis_stream'
require 'legion/extensions/agentic/integration/synthesis/helpers/synthesis'
require 'legion/extensions/agentic/integration/synthesis/helpers/synthesis_engine'
require 'legion/extensions/agentic/integration/synthesis/runners/cognitive_synthesis'

module Legion
  module Extensions
    module Agentic
      module Integration
        module Synthesis
          class Client
            include Runners::CognitiveSynthesis

            def initialize(engine: nil, **)
              @synthesis_engine = engine || Helpers::SynthesisEngine.new
            end

            private

            attr_reader :synthesis_engine
          end
        end
      end
    end
  end
end
