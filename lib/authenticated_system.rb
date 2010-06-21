module AuthenticatedSystem

  def self.included( base )
    base.helper_method :current_user, :logged_in?
  end

  protected

  def current_user
    if instance_variable_defined?(:@current_user)
      @current_user
    else
      @current_user = login_from_session
    end
  end

  def current_user=( new_user )
    @current_user = new_user
    session[:user_id] = @current_user.id
  end
  
  def login_from_session
    return nil if session[:user_id].blank?
    User.find_by_id( session[:user_id] )
  end

  def redirect_back_or_default(default = root_url)
    redirect_path = session[:return_to] || default
    session[:return_to] = nil
    redirect_to( redirect_path )
  end

  def logged_in?
    !current_user.nil?
  end

  def login_required
    logged_in? || access_denied
  end

  def access_denied
    respond_to do |format|
      format.html do
        store_location
        flash[:error] = 'You need to login first!'
        redirect_to login_users_path
      end
    end
  end

  def store_location
    if request.get? && !request.request_uri.blank? && request.request_uri !=~ /session/ && session[:return_to].blank?
      session[:return_to] = request.request_uri
    end
  end

end