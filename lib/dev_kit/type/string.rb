module DevKit
  module Type
    class String < ActiveModel::Type::String
      def cast(value)
        (super(value) || "").strip
      end
    end
  end
end
