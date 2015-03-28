# class TwitterController < ApplicationController
#   protect_from_forgery with: :exception
#   skip_before_action :verify_authenticity_token
#   helper_method :current_user
#   before_filter :load_tweets
#   before_filter :my_tweets

# 	# # Determines what tweets are loaded onto page.  
#   # # Return to here with more relevant search credentials  
#   def load_tweets
#     client = Twitter::REST::Client.new do |config|
#       config.consumer_key = Rails.application.secrets.consumer_key
#       config.consumer_secret = Rails.application.secrets.consumer_secret
#     end
#      @tweets = client.search("technology", result_type: "recent").take(15)
#   end  

#   def my_tweets
#     client = Twitter::REST::Client.new do |config|
#       config.consumer_key = Rails.application.secrets.consumer_key
#       config.consumer_secret = Rails.application.secrets.consumer_secret
#       config.access_token = Rails.application.secrets.access_token
#       config.access_token_secret = Rails.application.secrets.access_token_secret
#     end
#      @my_tweets = twitter_accessor.client.user_timeline.take(15)
#   end


#   private

#   def client
#     @client ||= Twitter::REST::Client.new do |config|
#       config.consumer_key = Rails.application.secrets.consumer_key
#       config.consumer_secret = Rails.application.secrets.consumer_secret
#     end
#   end

#   def twitter_accessor
#     @twitter_accessor ||= TwitterAccessor.new(current_user)
#   end
# end
