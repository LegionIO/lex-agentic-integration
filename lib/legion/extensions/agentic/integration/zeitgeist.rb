# frozen_string_literal: true

require 'securerandom'

require_relative 'zeitgeist/version'
require_relative 'zeitgeist/helpers/constants'
require_relative 'zeitgeist/helpers/cognitive_signal'
require_relative 'zeitgeist/helpers/trend_window'
require_relative 'zeitgeist/helpers/zeitgeist_engine'
require_relative 'zeitgeist/runners/cognitive_zeitgeist'
require_relative 'zeitgeist/helpers/client'

module Legion
  module Extensions
    module Agentic
      module Integration
        module Zeitgeist
        end
      end
    end
  end
end
