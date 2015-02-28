##
# Advice used in particular recommendation
#
class Advice < ActiveRecord::Base
  has_many :logs

  validates :name, presence: true
  validates :desc, presence: true
end

