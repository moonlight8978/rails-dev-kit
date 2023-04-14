# frozen_string_literal: true

module DevKit
  module Type
    class DateYyyyMm < ActiveModel::Type::Date
      def type
        :date_yyyy_mm
      end

      def cast(value)
        return if value.blank?

        Date.strptime(value, "%Y-%m") rescue nil
      end

      def serialize(value)
        return if value.blank?

        value.strftime("%Y-%m") rescue nil
      end
    end
  end
end
