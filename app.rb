# ======================================================================================================================
# Requires
# ======================================================================================================================

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/json'

# ======================================================================================================================
# Controllers
# ======================================================================================================================

class TabRec < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    json message: 'Hello from TabRec API!'
  end

  get '/users/:id' do
    user = User.find(params[:id])
    json user
  end
end

# ======================================================================================================================
# Models
# ======================================================================================================================

##
# This table contains usage logs from tabrec extension.
# On specific :event, we log the time and other important attributes in that moment.
# The purpose is to get know how people use tabs and provide the best recomendation afterwards.
#
class UsageLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
end

##
# This table contains recomendation logs from tabrec extension.
# On specific :event, we make an :advice and the :user can accept or reject it (:resolution).
#
class Log < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :advice
  belongs_to :resolution
end

class User < ActiveRecord::Base
  has_many :logs

  validates :experience, presence: true, inclusion: { in: %w(beginner advanced expert) }
  validates :rec_mode, presence: true, inclusion: { in: %w(interactive semi_interactive aggressive) }
end

##
# The lowest level event, they are predefined (seeded).
# Example: tab_close, tab_open
#
class Event < ActiveRecord::Base
  has_many :logs

  validates :name, presence: true
  validates :desc, presence: true
end

class Advice < ActiveRecord::Base
  has_many :logs

  validates :name, presence: true
  validates :desc, presence: true
end

class Resolution < ActiveRecord::Base
  has_many :logs

  validates :name, presence: true
  validates :desc, presence: true
end
