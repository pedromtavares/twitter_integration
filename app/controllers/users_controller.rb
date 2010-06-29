
class UsersController < ApplicationController
  
  def index
    if current_user && current_user.admin!=0
      @users = User.all(:order => "id ASC")
    else
      redirect_to twitter_index_path
    end
  end

  def new
    redirect_to twitter_index_path if current_user && current_user.admin==0
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    if @user.save
      self.current_user = @user
      flash[:notice] = 'Registration was successful!'
      redirect_to twitter_index_path
    else
      flash.now[:error] = @user.errors.full_messages.join( ", " )
      render :new
    end
  end
  
  def login
    if request.post?
      @user = User.authenticate(params[:email], params[:password])
      if @user
        self.current_user = @user
        flash[:notice] = "Login successful!"
        redirect_to twitter_index_path
      else
        flash.now[:error] = 'Login unsuccessful'
      end
    else
      redirect_to twitter_index_path if current_user
    end
  end
  
  def logoff
    session[:user_id] = nil
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default
  end

end