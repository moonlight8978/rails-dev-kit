# frozen_string_literal: true

module DevKit
  module Time
    module CommonExtension
      extend ActiveSupport::Concern

      included do
        def first_day_of_month(wday)
          first_day = self.beginning_of_month
          diff_in_day = (wday - first_day.wday).abs
          first_day + diff_in_day.days
        end
      end
    end
  end
end
