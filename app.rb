# ======================================================================================================================
# Require declarations
# ======================================================================================================================

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/json'

# ======================================================================================================================
# Main APP
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
# ActiveRecord models
# ======================================================================================================================

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
