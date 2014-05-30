require 'sinatra'
require "sinatra/twitter-bootstrap"
require "slim"

class App < Sinatra::Base
    register Sinatra::Twitter::Bootstrap::Assets

    get '/' do
        slim :login
    end

    get '/login' do
    	slim :login
    end

    get '/signup' do
    	slim :signup
    end
end
