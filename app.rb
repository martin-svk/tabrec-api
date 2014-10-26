require 'sinatra/base'
require 'sinatra/activerecord'

class TabRec < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    'Hello from TabRec API!'
  end
end
