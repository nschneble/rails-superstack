# Asynchronously adds a single record to the search index

class ReindexRecordsJob
  @queue = :performance

  def self.perform(record)
    record.index!
  end
end
