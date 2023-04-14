# frozen_string_literal: true

module DevKit
  module Time
    class TimeDifference
      def self.between(from, to)
        new(((from - to) * 1000).ceil.abs)
      end

      def initialize(diff_in_ms)
        self.diff_in_ms = diff_in_ms
      end

      def in_seconds
        diff_in_ms / 1000.0
      end

      def in_hours
        in_seconds / 3600
      end

      def in_days
        in_hours / 24
      end

      def in_weeks
        in_days / 7
      end

      private
        attr_accessor :diff_in_ms
    end
  end
end
