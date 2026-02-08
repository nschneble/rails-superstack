module Indexable
  extend ActiveSupport::Concern

  included do
    def self.index_async(record, remove)
      Resque.enqueue(ReindexRecordsJob, record, remove)
    end
  end
end
