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
