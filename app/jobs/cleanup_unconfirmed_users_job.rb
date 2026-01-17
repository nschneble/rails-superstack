class CleanupUnconfirmedUsersJob
  @queue = :maintenance

  # deletes users who don't ever finish signing in
  def self.perform(stale_after_days = 7)
    cutoff = Time.current - stale_after_days.to_i.days

    User
      .where(email_confirmed_at: nil)
      .where("created_at < ?", cutoff)
      .find_each do |user|
        user.destroy!
      end
  end
end
