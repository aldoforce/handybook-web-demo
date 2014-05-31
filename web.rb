require 'sinatra'
require "sinatra/twitter-bootstrap"
require "slim"
require "base64"

#declare lib folder
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )

require 'Salesforce_Connector'

class App < Sinatra::Base
    register Sinatra::Twitter::Bootstrap::Assets

    get '/' do
      slim :apply
    end

    get '/test' do
      sfdc = Salesforce_Connector.new
      sfdc.test
    end

    get '/apply' do
      slim :apply
    end

    post '/create_candidate' do
    	sfdc = Salesforce_Connector.new
    	id = sfdc.create_candidate(
    		params[:email],
    		params[:location],
    		params[:apply_as]
    	)

    	#encode id
    	encoded_id = Base64.encode64(id)
		
			redirect '/candidate_details/' + encoded_id

    end

    get '/candidate_details/:encoded_id' do
      @encoded_id = :encoded_id
      slim :candidate_details
    end

    get '/login' do
    	slim :login
    end

    get '/signup' do
    	slim :signup
    end
end
