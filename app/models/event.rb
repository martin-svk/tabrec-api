##
# The lowest level event, they are predefined (seeded).
# Example: TAB_CLOSE, TAB_CREATE
#
class Event < ActiveRecord::Base
  has_many :usage_logs

  validates :name, presence: true
  validates :desc, presence: true
end

