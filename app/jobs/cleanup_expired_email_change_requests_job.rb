class CleanupExpiredEmailChangeRequestsJob
  @queue = :maintenance

  def self.perform
    EmailChangeRequest.expired.delete_all
  end
end
