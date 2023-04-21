module DevKit::Enum
  extend ActiveSupport::Concern

  included do
    extend Enumerize
  end

  class_methods do
    def value_hash
      value.values.map { |kind| [kind, kind.value] }.to_h
    end

    def mapping(**hash)
      enumerize :value, in: hash
    end

    def values
      value.values
    end
  end
end
