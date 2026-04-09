# Asynchronously adds or removes a single record from the search index

class ReindexRecordsJob
  @queue = :performance

  def self.perform(record, remove)
    if remove
      record.remove_from_index!
    else
      record.index!
    end
  end
end
