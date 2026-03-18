# frozen_string_literal: true

require 'legion/extensions/agentic/integration/situation_model/helpers/constants'
require 'legion/extensions/agentic/integration/situation_model/helpers/situation_event'
require 'legion/extensions/agentic/integration/situation_model/helpers/situation_model'
require 'legion/extensions/agentic/integration/situation_model/helpers/situation_engine'
require 'legion/extensions/agentic/integration/situation_model/runners/situation_model'
require 'legion/extensions/agentic/integration/situation_model/helpers/client'

module Legion
  module Extensions
    module Agentic
      module Integration
        module SituationModel
          class Client
            include Runners::SituationModel

            private

            def engine
              @engine ||= Helpers::SituationEngine.new
            end
          end
        end
      end
    end
  end
end
