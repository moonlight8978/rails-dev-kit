module DevKit
  module Csv
    class CsvReader
      class << self
        def foreach(file:, type:, &block)
          row_record = nil
          reader = new(type)

          CSV.foreach(file, headers: true, skip_blanks: true) do |row|
            maybe_record = reader.update_or_new_record(row)
            # Yield previous record (when next record is read for the first row)
            yield row_record if maybe_record && row_record
            row_record = maybe_record if maybe_record
          end

          # Yield the record if there is no next record
          yield row_record if row_record
        end
      end

      def initialize(type)
        @type = type
        @record = nil
      end

      def update_or_new_record(row)
        if @type.any_defined?(row)
          @record = @type.new
          return_result = @record

          @record.assign_attributes(
            @type.attrs.map do |attr|
              if @type.is_sub_reader?(attr)
                [attr, []]
              else
                header = @type.attr_to_header[attr]
                raise "Header #{header} is not defined in CSV file" unless row.key?(header)

                [attr, row[header]]
              end
            end.to_h
          )
        else
          return_result = nil
        end

        @type.attr_to_sub_reader.each do |attr, sub_reader|
          sub_reader_record = sub_reader.update_or_new_record(row)
          @record.send(attr) << sub_reader_record if sub_reader_record.present?
        end

        return_result
      end
    end
  end
end
