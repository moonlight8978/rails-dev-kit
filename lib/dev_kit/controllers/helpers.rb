# frozen_string_literal: true

module DevKit
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Attributes

        include Pagy::Backend
        include Pundit::Authorization

        attribute :meta, default: {}

        rescue_from StandardError, with: :on_exception

        def pundit_user
          current_user
        end

        protected
          def user_agent
            client = DeviceDetector.new(request.user_agent, request.headers)
            if client.known?
              "#{client.device_name} #{client.os_name} #{client.name}"
            else
              "Unknown"
            end
          end

          def paginate(collection)
            per_page = params[:per_page].presence || params.dig(:data, :per_page).presence
            page = params[:page].presence || params.dig(:data, :page).presence

            pagy(collection, items: per_page, page:).tap do |result|
              @pagy, _collection = result
              self.meta = PaginationMeta.new(@pagy)
            end
          end

          def renderer
            @renderer ||= DevKit::Service::Renderer.new(DevKit::Service::JsonRenderEngine.new, self)
          end

          def on_exception(exception)
            renderer.error(exception)
          end
      end
    end
  end
end
