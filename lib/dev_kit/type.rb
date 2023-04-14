require_relative "./type/date_yyyy_mm"
require_relative "./type/timestamp"

module DevKit
  module Type
    ActiveModel::Type.register(:timestamp, Type::Timestamp)
    ActiveModel::Type.register(:date_yyyy_mm, Type::DateYyyyMm)
  end
end
