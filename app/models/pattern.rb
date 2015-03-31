##
# Pattern represents most common event sequences
##
class Pattern < ActiveRecord::Base
  has_many :logs
  belongs_to :advice
end
