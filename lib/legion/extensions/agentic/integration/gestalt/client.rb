# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Gestalt
          class Client
            include Runners::Gestalt

            attr_reader :store

            def initialize(store: nil, **)
              @store = store || Helpers::PatternStore.new
            end
          end
        end
      end
    end
  end
end
