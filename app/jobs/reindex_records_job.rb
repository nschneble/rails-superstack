# Asynchronously adds or removes a single record from the search index

class ReindexRecordsJob
  @queue = :performance

  # :reek:ControlParameter — Resque always calls .perform with queued args; splitting into two job classes would break the API
  def self.perform(record, remove)
    if remove
      record.remove_from_index!
    else
      record.index!
    end
  end
end
