module DevKit
  module Csv
    module CsvRowRecord
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Model
        include ActiveModel::Attributes

        extend Enumerize
      end

      class_methods do
        attr_accessor :attr_to_header, :header_to_attr, :attr_to_converter, :attrs, :attr_to_sub_reader

        def column(attr, **args)
          self.attr_to_header ||= {}
          self.header_to_attr ||= {}
          self.attr_to_converter ||= {}
          self.attrs ||= []
          self.attr_to_sub_reader ||= {}

          header = args.delete(:header) { attr.to_s }
          converter = args.delete(:converter) { :default }
          sub_reader = args.delete(:sub_reader) { nil }
          is_enum = args.delete(:enum) { false }

          self.attrs << attr

          if sub_reader
            self.attr_to_sub_reader[attr] = DevKit::Csv::CsvReader.new(sub_reader)
            attribute attr, default: [], **args
          else
            self.attr_to_header[attr] = header
            self.header_to_attr[header] = attr

            unless converter.is_a? Symbol
              if ActiveModel::Type.lookup(converter.name).nil?
                ActiveModel::Type.register(converter.name) { converter }
              end
              converter = converter.name
            end

            self.attr_to_converter[attr] = converter

            if is_enum
              enumerize attr, **args
            else
              attribute attr, converter, **args
            end
          end
        end

        def any_defined?(row)
          self.attrs.any? do |attr|
            !self.is_sub_reader?(attr) && row[self.attr_to_header[attr]].present?
          end
        end

        def sub_readers
          attr_to_sub_reader.values
        end

        def is_sub_reader?(attr)
          attr_to_sub_reader.keys.include?(attr)
        end
      end
    end
  end
end
