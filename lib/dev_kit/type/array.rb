module DevKit
  module Type
    class Array < ActiveModel::Type::Value
      attr_accessor :item_converter, :delimiter

      def initialize(item_converter = :string, delimiter = ";")
        self.item_converter = item_converter
        self.delimiter = delimiter
      end

      def cast(value)
        item_converter = get_item_converter
        if value.present?
          value.split(delimiter).map { |v| item_converter.cast(v) }
        else
          []
        end
      end

      private

      def get_item_converter
        if item_converter.is_a? Symbol
          ActiveModel::Type.lookup(item_converter)
        else
          item_converter
        end
      end
    end
  end
end
