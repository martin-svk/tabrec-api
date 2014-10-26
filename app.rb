require 'sinatra/base'
require './config/environments'

class TabRec < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    'Hello from TabRec API!'
  end
end
