# Maintenance job that deletes all expired email change request records

class CleanupExpiredEmailChangeRequestsJob
  @queue = :maintenance

  def self.perform
    EmailChangeRequest.expired.delete_all
  end
end
