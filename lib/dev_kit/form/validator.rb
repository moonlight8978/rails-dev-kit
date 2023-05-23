module DevKit
  module Form
    class Validator < Dry::Validation::Contract
      class Failure
        include ActiveModel::Model
      end

      attr_accessor :current

      import_predicates_as_macros

      def validate(**kwargs)
        self.current = call(**kwargs)
      end

      def validate!(**kwargs)
        self.current = call(**kwargs)
        Failure.new.tap do |model|
          full_messages.each { |message| model.errors.add(:base, message) }
          raise ActiveRecord::RecordInvalid.new(model) if invalid?
        end
      end

      def full_messages
        current.errors(full: true).to_h.values.flatten
      end

      def valid?
        current.errors.empty?
      end

      def invalid?
        !valid?
      end

      def query(relation)
        apply do |values|
          on_query(relation, values)
          relation
        end
      end

      def apply(**kwargs, &block)
        yield current.values.data if validate(**kwargs)
      end

      def apply!(**kwargs, &block)
        validate!(**kwargs)
        yield current.values.data
      end

      protected

      def on_query(relation, values)
        relation
      end
    end
  end
end
