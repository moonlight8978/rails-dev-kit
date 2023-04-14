# frozen_string_literal: true

module DevKit
  module Service
    class JsonRenderEngine
      def show(context, record, *args, **kwargs)
        context.render json: ResponseBody.new(resource: record, meta: context.meta), status: :ok, scope: context, scope_name: :ctl, **kwargs
      end

      def index(context, collection, *args, **kwargs)
        context.render json: ResponseBody.new(collection:, meta: context.meta), status: :ok, scope: context, scope_name: :ctl, **kwargs
      end

      def destroy(context, *args, **kwargs)
        context.render json: ResponseBody.new(resource: { count: 1 }, meta: context.meta), status: :ok, scope: context, scope_name: :ctl, **kwargs
      end

      def create(context, record, *args, **kwargs)
        context.render json: ResponseBody.new(resource: record, meta: context.meta), status: :created, scope: context, scope_name: :ctl, **kwargs
      end

      def update(context, record, *args, **kwargs)
        context.render json: ResponseBody.new(resource: record, meta: context.meta), status: :ok, scope: context, scope_name: :ctl, **kwargs
      end

      def error(context, exception, *args, **kwargs)
        if exception.is_a?(ActiveRecord::RecordNotFound)
          context.render json: { errors: ["Not found"], messages: ["Not found"] }, status: :not_found, scope: context, scope_name: :ctl, **kwargs
        elsif exception.is_a?(ActiveRecord::RecordInvalid)
          context.render json: { errors: exception.record.errors.full_messages, messages: ["Invalid"] }, status: :unprocessable_entity, scope: context, scope_name: :ctl, **kwargs
        elsif exception.is_a?(Pundit::NotAuthorizedError)
          context.render json: { errors: ["Not authorized"], messages: ["Not authorized"] }, status: :forbidden, scope: context, scope_name: :ctl, **kwargs
        else
          Rails.logger.error(exception.message)
          Rails.logger.error(exception.backtrace.join("\n"))

          context.render json: { errors: ["Internal server error"], messages: ["Internal server error"] }, status: :internal_server_error, scope: context, scope_name: :ctl, **kwargs
        end
      end
    end
  end
end
