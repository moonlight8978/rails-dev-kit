# frozen_string_literal: true

module DevKit
  module Form
    class ApplicationForm
      extend Enumerize

      include ActiveModel::Model
      include ActiveModel::Attributes

      def apply(relation)
        relation
      end
    end
  end
end
