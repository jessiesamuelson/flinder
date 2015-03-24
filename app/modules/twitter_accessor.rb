class TwitterAccessor
	attr_reader :client

	def initialize(user)
		if user && user.oauth_token
			@client = TwitterOAuth::Client.new(
		    :consumer_key => Rails.application.secrets.consumer_key,
		    :consumer_secret => Rails.application.secrets.consumer_secret,
		    :token => user.oauth_token,
		    :secret => user.oauth_secret
			)
		else
			@client = TwitterOAuth::Client.new(
		    :consumer_key => Rails.application.secrets.consumer_key,
		    :consumer_secret => Rails.application.secrets.consumer_secret
			)
		end
	end

	def get_request_token
		request_token = client.request_token(:oauth_callback => 'http://localhost:3000/users/twitter_callback')

		# http://127.0.0.1:3000/

		return request_token
	end 

	def authorize(request_token, oauth_verifier)
		access_token = @client.authorize(
      request_token['token'],
      request_token['secret'],
      :oauth_verifier => oauth_verifier
    )
    return access_token
	end
end