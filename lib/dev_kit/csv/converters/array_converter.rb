class Csv::Converters::ArrayConverter < ActiveModel::Type::Value
  attr_accessor :item_converter, :delimiter

  def initialize(item_converter = Csv::Converters::StringConverter.new, delimiter = ",", name: :array)
    self.item_converter = item_converter
    self.delimiter = delimiter
    self.name = :array
  end

  def cast(value)
    if value.present?
      value.split(delimiter).map { |v| item_converter.deserialize(v) }
    else
      []
    end
  end
end
