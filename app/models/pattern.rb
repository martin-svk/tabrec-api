##
# Pattern represents one of the most common event sequences
##
class Pattern < ActiveRecord::Base
  has_many :logs
  belongs_to :advice

  validates :sequence, presence: true
  validates :desc, presence: true
  validates :advice_id, presence: true
end
