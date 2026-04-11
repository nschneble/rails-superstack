# Asynchronously removes a single record from the search index

class DeindexRecordsJob
  @queue = :performance

  def self.perform(record)
    record.remove_from_index!
  end
end
