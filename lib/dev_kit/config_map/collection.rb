module DevKit
  module ConfigMap
    class Collection
      attr_accessor :records, :record_type

      delegate :keys, :fetch, :values, to: :key_to_record
      delegate_missing_to :records

      def initialize(records, record_type:)
        self.records = records
        self.record_type = record_type
      end

      def key_to_record
        @key_to_record ||= records.index_by(&record_type.key_by)
      end
    end
  end
end
