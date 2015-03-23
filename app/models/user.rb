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
end
