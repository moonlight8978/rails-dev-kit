# frozen_string_literal: true

require_relative "./type/date_yyyy_mm"
require_relative "./type/timestamp"
require_relative "./type/string"
require_relative "./type/array"

module DevKit
  module Type
    ActiveModel::Type.register(:timestamp, Type::Timestamp)
    ActiveModel::Type.register(:date_yyyy_mm, Type::DateYyyyMm)
    ActiveModel::Type.register(:string, Type::String)
    ActiveModel::Type.register(:array_of_string) do
      Type::Array.new(:string, ";")
    end
    ActiveModel::Type.register(:array_of_integer) do
      Type::Array.new(:integer, ";")
    end

    ActiveModel::Type.register(:legacy_array_of_string) do
      Type::Array.new(:string, ",")
    end
    ActiveModel::Type.register(:legacy_array_of_integer) do
      Type::Array.new(:integer, ",")
    end
  end
end
