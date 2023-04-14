# frozen_string_literal: true

module DevKit
  module Service
    class Renderer
      def initialize(engine, context)
        @engine = engine
        @context = context
      end

      def show(*args, **kwargs)
        @engine.show(@context, *args, **kwargs)
      end

      def index(*args, **kwargs)
        @engine.index(@context, *args, **kwargs)
      end

      def destroy(*args, **kwargs)
        @engine.destroy(@context, *args, **kwargs)
      end

      def create(*args, **kwargs)
        @engine.create(@context, *args, **kwargs)
      end

      def update(*args, **kwargs)
        @engine.update(@context, *args, **kwargs)
      end

      def error(*args, **kwargs)
        @engine.error(@context, *args, **kwargs)
      end

      protected
        def render(*args, **kwargs)
          @template.result(@context, *args, **kwargs)
        end
    end
  end
end
