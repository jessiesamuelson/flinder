require 'httparty'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  helper_method :current_user
  helper_method :current_search_term
  before_filter :my_tweets

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token]) 
  end

  # # Determines what tweets are loaded onto page.  
  # # Return to here with more relevant search credentials

  # def load_tweets(search_term)
  #   client = Twitter::REST::Client.new do |config|
  #     config.consumer_key = Rails.application.secrets.consumer_key
  #     config.consumer_secret = Rails.application.secrets.consumer_secret
  #   end
  #   if client.search("#{search_term} OR charity", result_type: "popular").any?
  #     return @tweets = client.search("#{search_term} OR charity", result_type: "popular", lang: 'en').take(15)
  #   else
  #     return @tweets = client.search("#{search_term} OR charity", result_type: "recent", lang: 'en').take(15)
  #   end
  # end  

  def load_tweets(search_term)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.consumer_key
      config.consumer_secret = Rails.application.secrets.consumer_secret
    end
    
    @tweets = client.search("#{search_term}", lang: 'en').take(15)
  end  

  def my_tweets
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.consumer_key
      config.consumer_secret = Rails.application.secrets.consumer_secret
      config.access_token = Rails.application.secrets.access_token
      config.access_token_secret = Rails.application.secrets.access_token_secret
    end
     @my_tweets = twitter_accessor.client.user_timeline.take(15)
  end

  def get_org(search_term)
      auth = {:username => Rails.application.secrets.guidestar_username, :password => Rails.application.secrets.guidestar_password }


      @orgs = HTTParty.get("https://#{Rails.application.secrets.guidestar_searchKey}@sandboxdata.guidestar.org/v1/search.json?q=#{search_term}&r=5", :basic_auth => auth )
      # @orgs = HTTParty.get("https://sandboxdata.guidestar.org/v1/search.json?q=#{search_term}&r=5", :basic_auth => auth )
      @orgs_list = @orgs["hits"]
  end

  def get_org_details(org_id)
    auth = {:username => Rails.application.secrets.guidestar_username, :password => Rails.application.secrets.guidestar_password }


      @orgs = HTTParty.get("https://#{Rails.application.secrets.guidestar_detailsKey}@sandboxdata.guidestar.org/v1/detail/#{org_id}.json", :basic_auth => auth )
  end
  
  private

  def login!(user)
    session[:session_token] = make_token
    user.session_token = session[:session_token]
    user.save!
  end

  def logout!
    current_user[:session_token] = nil
    current_user.save!
    session[:session_token] = make_token
  end

  def make_token
    return SecureRandom.urlsafe_base64
  end

  def require_current_user
    redirect_to new_session_url unless current_user
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.consumer_key
      config.consumer_secret = Rails.application.secrets.consumer_secret
    end
  end

  def twitter_accessor
    @twitter_accessor ||= TwitterAccessor.new(current_user)
  end

end
