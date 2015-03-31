##
# Resolution of the recommendation, can be one of ACCEPTED, REJECTED, AUTOMATIC
#
class Resolution < ActiveRecord::Base
  has_many :logs

  validates :name, presence: true
  validates :desc, presence: true
end
