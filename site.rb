require "sinatra/base"
require "data_mapper"
require "sinatra/reloader"
require "sinatra/flash"
require "slim"

class SiteController < Sinatra::Base
  register Sinatra::Flash
  register Sinatra::Reloader
  helpers SitewideHelpers

  configure do
    set :session_secret, ENV['SESSION_KEY'] || ''
    enable :sessions
  end

  configure :development do
    DataMapper.setup(:default, "")
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

  get '/' do
    slim :index
  end
end