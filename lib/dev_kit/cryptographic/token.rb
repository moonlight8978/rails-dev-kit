module DevKit
  module Cryptographic
    class Token
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :value, :string
      attribute :expire_at, :datetime
      attribute :duration_ms, :integer

      def duration(unit: :s)
        case unit
        when :s
          duration_ms / 1000
        when :ms
          duration_ms
        when :m
          duration_ms / (1000 * 60)
        when :h
          duration_ms / (1000 * 60 * 60)
        end
      end
    end
  end
end
