class Csv::Converters::StringConverter < ActiveModel::Type::Value
  def cast(value)
    value
  end
end
