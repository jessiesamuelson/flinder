class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  helper_method :current_user
  before_filter :load_tweets

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token]) 
  end


  # Determines what tweets are loaded onto page.  
  # Return to here with more relevant search credentials
  def load_tweets
    if twitter_accessor.client
      @tweets = twitter_accessor.client.user_timeline.take(15)
    end
  end

  # def nytimes
  #   render text: Net::HTTP.get(URI("http://api.nytimes.com/svc/news/v3/content.json?api-key=#{Rails.application.secrets.nyt_newsWire_apiKey}"))
  # end
  
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
