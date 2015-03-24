class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def twitter_login
    if current_user && current_user.oauth_token
      redirect_to "/users/#{current_user.id}"
    else  
      session[:twitter_request_token] = twitter_accessor.get_request_token 
      redirect_to session[:twitter_request_token].authorize_url
    end

  end

  def twitter_callback
    request_token = session[:twitter_request_token]
    access_token = twitter_accessor.authorize(request_token, params[:oauth_verifier])
    
    current_user.oauth_token = access_token.token
    current_user.oauth_secret = access_token.secret

    current_user.save!

    redirect_to "/users/#{current_user.id}"
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        login!(@user)
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user == current_user
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to users_path, notice: "You can't edit that user"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user == current_user
      @user.destroy
      reset_session
      respond_to do |format|
        format.html { redirect_to signup_path, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to users_path, notice: "You can't delete that user"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :region)
    end

    def user_is_current_user
      user = User.find(params[:id])

      if current_user
        redirect_to user_path(current_user) unless user == current_user
      else
        redirect_to new_session_path
      end
    end
end
