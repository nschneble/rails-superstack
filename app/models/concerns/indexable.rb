# Adds asynchronous search index update support via ReindexRecordsJob

module Indexable
  extend ActiveSupport::Concern

  included do
    def self.index_async(record, remove)
      if record.present? && remove.present?
        Resque.enqueue(DeindexRecordsJob, record)
      else
        Resque.enqueue(ReindexRecordsJob, record)
      end
    end
  end
end
