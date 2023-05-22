module DevKit
  module ConfigMap
    module Record
      extend ActiveSupport::Concern

      included do
        include DevKit::Csv::CsvRowRecord
        extend DevKit::Csv::CsvRowRecord
      end

      class_methods do
        attr_accessor :file, :ext, :key_by, :record_class_name

        def config_reader(file: nil, key_by: :id)
          self.file = file
          self.ext = ext
          self.key_by = key_by
        end

        def from_csv(file = Rails.root.join(self.file))
          records = []
          DevKit::Csv::CsvReader.foreach(file: file, type: self) do |record|
            records << record
          end
          Collection.new(records, record_type: self)
        end
      end
    end
  end
end
