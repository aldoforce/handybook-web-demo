require 'sinatra'
require "sinatra/twitter-bootstrap"
require "slim"

class App < Sinatra::Base
    register Sinatra::Twitter::Bootstrap::Assets

    get '/' do
        slim :apply
    end

    get '/apply' do
        slim :apply
    end

    get '/candidate_details/:encoded_id' do
        slim :candidate_details
    end

    get '/login' do
    	slim :login
    end

    get '/signup' do
    	slim :signup
    end
end
