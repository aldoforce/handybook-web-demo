require 'restforce'

class Salesforce_Connector

	def initialize
		Restforce.log = ENV['SF_RESTFORCE_DEBUG'] == "false" ? false : true
		@client = Restforce.new :host 					=> ENV['SF_LOGIN_HOST'],
														:username 			=> ENV['SF_USERNAME'],
													  :password       => ENV['SF_PASSWORD'],
													  :security_token => ENV['SF_TOKEN'],
													  :client_id      => ENV['SF_EXTERNAL_APP_CLIENT_ID'], 
													  :client_secret  => ENV['SF_EXTERNAL_APP_CLIENT_SECRET'] 
	end

	def test
		accounts = @client.query('SELECT name FROM Account LIMIT 10')
		accounts.each do |record|
			puts record.FirstName || record.Name
		end
	end

	def create_candidate(email, location, apply_as)
		@client.create('Account', 
										LastName: email,
										Editable_Email__c: email,
										Location__c: location,
										Apply_as__c: apply_as
									 )
	end

	def get_candidate(encoded_id)
		accounts = @client.query(
								"SELECT " \
									"FirstName," 																	\
									"LastName," 																	\
									"Phone," 													\
									"BillingStreet,"															\
									"BillingState,"																\
									"BillingCity,"																\
									"BillingPostalCode,"													\
									"Receive_Packages_at_this_Address__c,"				\
									"Professional_Cleaning_Experience__c," 				\
			  					"Years_of_paid_experience__c," 								\
									"Have_you_ever_been_convicted_of_a_crime__c," \
									"Are_you_eligible_to_work_in_the_US__c," 			\
									"How_many_hrs_week_are_you_able_to_work__c," 	\
									"Were_you_referred_by_someone__c," 						\
									"Relevant_Experience__c,"											\
									"T_Shirt_Size__c,"														\
									"T_Shirt_Style__c,"														\
									"Smart_Phone__c,"															\
									"Internet__c,"																\
									"Car__c,"																			\
									"Bank_Account__c,"														\
									"Quiz_Score__c "															\
								"FROM Account " 																\
								"WHERE Encoded_Id__c = '#{encoded_id}' " 				\
								"LIMIT 1"
							)

		accounts.first
	end

	def update_candidate(candidate)
		candidateID = Base64.decode64( candidate[:encoded_id] )
		@client.update(
			'Account',
			Id: candidateID,
			Professional_Cleaning_Experience__c: 				candidate[:professional_cleaning_experience],
			Years_of_paid_experience__c: 								candidate[:years_experience],
			Have_you_ever_been_convicted_of_a_crime__c: candidate[:convicted],
			Are_you_eligible_to_work_in_the_US__c: 			candidate[:elegible_to_work],
			How_many_hrs_week_are_you_able_to_work__c: 	candidate[:how_many_hours],
			Were_you_referred_by_someone__c: 						candidate[:referred],
			Relevant_Experience__c: 										candidate[:relevante_experience],
			T_Shirt_Size__c: 														candidate[:tshirt_size],
			T_Shirt_Style__c: 													candidate[:tshirt_style],
			Smart_Phone__c: 														candidate[:do_you_have_smartphone] == "true" ? true : false,
			Internet__c: 																candidate[:do_you_have_internet] == "true" ? true : false,
			Car__c: 																		candidate[:do_you_have_car] == "true" ? true : false,
			Bank_Account__c: 														candidate[:do_you_have_bank_account] == "true" ? true : false,
			FirstName: 																	candidate[:firstname],
			LastName: 																	candidate[:lastname],
			Phone:																			candidate[:phone],
			BillingStreet: 															candidate[:street],
			BillingCity: 																candidate[:city],
			BillingState: 															candidate[:state],
			BillingPostalCode: 													candidate[:zip],
			Receive_Packages_at_this_Address__c:				candidate[:packages] == "Yes" ? true : false
		)
	end

	def update_quiz(candidate)
		candidateID = Base64.decode64( candidate[:encoded_id] )
		@client.update(
			'Account',
			Id: candidateID,
			Quiz_Score__c: 		candidate[:quiz]			
		)
	end

end