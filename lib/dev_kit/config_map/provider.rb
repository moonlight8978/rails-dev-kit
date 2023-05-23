module DevKit
  module ConfigMap
    class Provider
      class Registry
        attr_accessor :type_to_config_map

        def register(type, options = {})
          self.type_to_config_map ||= {}
          config_map = type.from_csv
          type_to_config_map[type.name] = config_map
          type_to_config_map[options[:alias]] = config_map if options[:alias]
        end

        def lookup(type_or_alias)
          if type_or_alias.is_a?(Class)
            type_to_config_map.fetch(type_or_alias.name)
          else
            type_to_config_map.fetch(type_or_alias)
          end
        end

        def count
          type_to_config_map.count
        end
      end

      include Singleton

      attr_accessor :registry

      class << self
        def register(*args, **kwargs)
          instance.register(*args, **kwargs)
        end

        def lookup(*args, **kwargs)
          instance.lookup(*args, **kwargs)
        end

        def count
          instance.count
        end
      end

      def initialize
        self.registry = Registry.new
      end

      def register(*args, **kwargs)
        registry.register(*args, **kwargs)
      end

      def lookup(*args, **kwargs)
        registry.lookup(*args, **kwargs)
      end

      def count
        registry.count
      end
    end
  end
end
