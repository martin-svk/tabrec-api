##
# This table contains recommendation logs from TabRec extension.
# On specific pattern, we make an advice and the user can accept or reject it (resolution).
#
class Log < ActiveRecord::Base
  belongs_to :user
  belongs_to :pattern
  belongs_to :resolution

  # Scopes
  scope :from_user, -> (uid) { joins(:user).where(users: {id: uid}) }
  scope :for_pattern, -> (pattern_name) { joins(:pattern).where(patterns: {name: pattern_name}) }
  scope :accepted, -> { joins(:resolution).where(resolutions: {name: 'ACCEPTED'}) }
  scope :rejected, -> { joins(:resolution).where(resolutions: {name: 'REJECTED'}) }
  scope :reverted, -> { joins(:resolution).where(resolutions: {name: 'REVERTED'}) }
  scope :automatic, -> { joins(:resolution).where(resolutions: {name: 'AUTOMATIC'}) }
  scope :yes, -> { joins(:resolution).where(resolutions: {name: 'YES'}) }
  scope :no, -> { joins(:resolution).where(resolutions: {name: 'NO'}) }
end

