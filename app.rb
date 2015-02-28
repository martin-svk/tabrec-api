# ======================================================================================================================
# Requires
# ======================================================================================================================

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/json'

require_relative 'app/models/init'

# ======================================================================================================================
# Controller
# ======================================================================================================================

class TabRec < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  # Redirect to Chrome store page
  get '/' do
    redirect 'https://chrome.google.com/webstore/detail/tabrec/namcfnibfapnjbnlfcijidilkgeaogde'
  end

  # --------------------------------------------------------------------------------------------------------------------
  # Users
  # --------------------------------------------------------------------------------------------------------------------

  # Show
  get '/users/:id' do
    user = User.find(params[:id])
    json user
  end

  # Index
  get '/users' do
    json User.all
  end

  # Create
  post '/users' do
    if user = User.create(params[:user])
      json user
    else
      json user.errors
    end
  end

  # Update
  put '/users/:id' do
    user = User.find(params[:id])

    new_experience = params.fetch('user').fetch('experience')
    user.experience = new_experience if new_experience

    new_rec_mode = params.fetch('user').fetch('rec_mode')
    user.rec_mode = new_rec_mode if new_rec_mode

    new_other_plugins = params.fetch('user').fetch('other_plugins', 'false') == 'true' ? true : false
    user.other_plugins = new_other_plugins

    if user.save
      json user
    else
      json user.errors
    end
  end

  # User browsing stats
  get '/bstats/:id' do
    user = User.find(params[:id])

    # Getting stats
    bstats = {
      weekly: user.weekly_bstats,
      alltime: user.bstats
    }

    # Sending
    json bstats
  end

  # --------------------------------------------------------------------------------------------------------------------
  # Usage Logs
  # --------------------------------------------------------------------------------------------------------------------

  # Bulk create
  post '/usage_logs' do
    data = params[:data]

    if data
      data.each do |log|
        row = log[1]

        # Mandatory
        user_id = row.fetch 'user_id'
        tab_id = row.fetch 'tab_id'
        window_id = row.fetch 'window_id'
        timestamp = row.fetch 'timestamp'
        session_id = row.fetch 'session_id'
        event_id = Event.find_by(name: row.fetch('event')).id

        # Optional
        index_from = row.fetch('index_from', nil)
        index_to = row.fetch('index_to', nil)
        url = row.fetch('url', nil)
        domain = row.fetch('domain', nil)
        subdomain = row.fetch('subdomain', nil)
        path = row.fetch('path', nil)

        if UsageLog.create(user_id: user_id, tab_id: tab_id, event_id: event_id, window_id: window_id, url: url,
                        domain: domain, subdomain: subdomain, path: path, session_id: session_id,
                        index_from: index_from, index_to: index_to, timestamp: timestamp)
          status 201
          json message: 'Created'
        else
          status 422
          json message: 'Unprocessable data'
        end
      end
    else
      halt 400, 'Bad data format'
    end
  end

  # Index (last 300)
  get '/usage_logs' do
    ul = UsageLog.order(created_at: :desc).limit(300)
    json ul
  end
end
