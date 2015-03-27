class User < ActiveRecord::Base
	has_secure_password

  def current
    respond_to do |format|
      format.json { render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
        }
      }
    end
  end

  def tweets(opts = {})
    # make call to api with optional arguments
  
    #opts might look like
    # opts = {
    # recent: true,
    # count: 5
    # etc
    # }
  end

  def get_tweets() 
    current_user.tweets(count: 10)

  end

end
