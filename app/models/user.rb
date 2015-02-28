##
# This table represents extension user.
#
class User < ActiveRecord::Base
  has_many :logs
  has_many :usage_logs

  validates :experience, presence: true, inclusion: { in: %w(default beginner advanced expert) }
  validates :rec_mode, presence: true, inclusion: { in: %w(default interactive semi-interactive aggressive) }

  def bstats
    created = ulogs_with_event('TAB_CREATED').count
    closed = ulogs_with_event('TAB_REMOVED').count

    {created: created, closed: closed}
  end

  def weekly_bstats
    created = ulogs_with_event('TAB_CREATED').where(created_at: 7.days.ago..Time.now).count
    closed = ulogs_with_event('TAB_REMOVED').where(created_at: 7.days.ago..Time.now).count

    {created: created, closed: closed}
  end

  private

    def ulogs_with_event(event_name)
      usage_logs.joins(:event).where(events: { name: event_name })
    end

    def ulogs_in_session(session_id)
      usage_logs.where(session_id: session_id)
    end

    def ulogs_in_domain(session_id, domain)
      usage_logs.where(session_id: session_id, domain: domain)
    end
end

