##
# This table contains usage logs from TabRec extension.
# On specific :event, we log the time and other important attributes in that moment.
# The purpose is to get know how people use tabs and provide the best recommendation afterwards.
#
class UsageLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  scope :in_session, -> (session_id) { where(session_id: session_id) }
end

