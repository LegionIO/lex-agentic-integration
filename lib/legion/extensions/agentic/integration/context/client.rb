# frozen_string_literal: true

require 'legion/extensions/agentic/integration/context/helpers/constants'
require 'legion/extensions/agentic/integration/context/helpers/frame'
require 'legion/extensions/agentic/integration/context/helpers/context_manager'
require 'legion/extensions/agentic/integration/context/runners/context'

module Legion
  module Extensions
    module Agentic
      module Integration
        module Context
          class Client
            include Runners::Context

            attr_reader :context_manager

            def initialize(context_manager: nil, **)
              @context_manager = context_manager || Helpers::ContextManager.new
            end
          end
        end
      end
    end
  end
end
