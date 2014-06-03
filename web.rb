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
    #create sfdc connector
  	sfdc = Salesforce_Connector.new

    #create candidate
  	id = sfdc.create_candidate(
  		params[:email],
  		params[:location],
  		params[:apply_as]
  	)

    if not(id) #user already exists
      @message  = 'user already exists'
      @info    = params[:email]
      slim :message
    else    
      #encode id
      encoded_id = Base64.encode64(id)

      #redirect to details page
      redirect '/candidate_details/' + encoded_id
    end

  end

  get '/candidate_details/:encoded_id' do
    #create sfdc connector
    sfdc = Salesforce_Connector.new
    @candidate = sfdc.get_candidate( 
      params[:encoded_id]
    )

    @encoded_id = params[:encoded_id]
    
    slim :candidate_details
  end

  post '/candidate_update' do
    #create sfdc connector
    sfdc = Salesforce_Connector.new

    #pass the bindings
    success = sfdc.update_candidate(params)

    @success = "Record updated" if success 
    @message = "Update failed" if !success
    @info = params if !success
    
    slim :message
  end
end
