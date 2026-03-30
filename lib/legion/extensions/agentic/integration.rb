# frozen_string_literal: true

require_relative 'integration/version'
require_relative 'integration/integration'
require_relative 'integration/synthesis'
require_relative 'integration/tapestry'
require_relative 'integration/mosaic'
require_relative 'integration/tessellation'
require_relative 'integration/mycelium'
require_relative 'integration/zeitgeist'
require_relative 'integration/map'
require_relative 'integration/labyrinth'
require_relative 'integration/global_workspace'
require_relative 'integration/phenomenal_binding'
require_relative 'integration/gestalt'
require_relative 'integration/distributed_cognition'
require_relative 'integration/qualia'
require_relative 'integration/context'
require_relative 'integration/situation_model'
require_relative 'integration/boundary'

module Legion
  module Extensions
    module Agentic
      module Integration
        extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core, false

        def self.remote_invocable?
          false
        end
      end
    end
  end
end
