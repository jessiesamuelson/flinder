class SessionsController < ApplicationController
	before_action :require_current_user, only: [:destroy, :update]

	def new
		@user = User.new
	end

	def create
		@user = User.find_by(email: session_params[:email])

		if @user && @user.authenticate(session_params[:password])
			login!(@user)
			redirect_to root_path
		else
			redirect_to new_session_url
		end
	end

	def destroy
		logout!

		redirect_to root_path
	end

	private

	def session_params
		@session_params ||= params.require(:session).permit(:email, :password)
	end
end
