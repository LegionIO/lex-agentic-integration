# frozen_string_literal: true

require 'legion/extensions/agentic/integration/global_workspace/helpers/constants'
require 'legion/extensions/agentic/integration/global_workspace/helpers/broadcast'
require 'legion/extensions/agentic/integration/global_workspace/helpers/competitor'
require 'legion/extensions/agentic/integration/global_workspace/helpers/workspace'
require 'legion/extensions/agentic/integration/global_workspace/runners/global_workspace'

module Legion
  module Extensions
    module Agentic
      module Integration
        module GlobalWorkspace
          class Client
            include Runners::GlobalWorkspace

            def initialize(workspace: nil, **)
              @workspace = workspace || Helpers::Workspace.new
            end

            private

            attr_reader :workspace
          end
        end
      end
    end
  end
end
