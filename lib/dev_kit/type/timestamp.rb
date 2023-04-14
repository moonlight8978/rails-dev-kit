# frozen_string_literal: true
module DevKit
  module Type
    class Timestamp < ActiveModel::Type::DateTime
      def type
        :timestamp
      end

      def cast(value)
        Time.zone.at(value.to_i) rescue nil
      end

      def serialize(value)
        return if value.blank?

        value.to_i rescue nil
      end
    end
  end
end

