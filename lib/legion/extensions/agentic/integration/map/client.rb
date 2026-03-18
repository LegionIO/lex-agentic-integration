# frozen_string_literal: true

require 'legion/extensions/agentic/integration/map/helpers/constants'
require 'legion/extensions/agentic/integration/map/helpers/location'
require 'legion/extensions/agentic/integration/map/helpers/graph_traversal'
require 'legion/extensions/agentic/integration/map/helpers/cognitive_map_store'
require 'legion/extensions/agentic/integration/map/runners/cognitive_map'

module Legion
  module Extensions
    module Agentic
      module Integration
        module Map
          class Client
            include Runners::CognitiveMap

            def initialize(map_store: nil, **)
              @map_store = map_store || Helpers::CognitiveMapStore.new
            end

            private

            attr_reader :map_store
          end
        end
      end
    end
  end
end
