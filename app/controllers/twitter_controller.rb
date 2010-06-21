
class TwitterController < ApplicationController

  before_filter :twitter_wrapper, :login_required

  def index
    @twitter = @wrapper.get_twitter
    if @twitter
      @account = @twitter.user_timeline(:count => 1).first.user.screen_name
      @tweets = @twitter.home_timeline
    end
  end
  
  def signin
    begin
      session[:rtoken], session[:rsecret] = @wrapper.request_tokens
      redirect_to @wrapper.authorize_url
    rescue
      flash[:error] = 'Error while connecting with Twitter. Please try again.'
      redirect_to :action => :index
    end
  end
  
  def auth
    begin
      @wrapper.auth(session[:rtoken], session[:rsecret], params[:oauth_verifier])
      flash[:notice] = "Successfully signed in with Twitter."
    rescue
      flash[:error] = 'You were not authorized by Twitter!'
    end
    redirect_to :action => :index
  end
  
  def tweet
    @twitter = @wrapper.get_twitter
    if @twitter
      begin
        @twitter.update params[:tweet]
        flash[:notice] = "Tweet successfully sent!"
      rescue
        flash[:error] = "Error sending the tweet!"
      end
    else
      flash[:error] = "Your connection with Twitter was lost. Please sign in again."
    end
    redirect_to :action => :index
  end
  
  private
  
  def twitter_wrapper
    @wrapper = TwitterWrapper.new File.join(Rails.root, 'config', 'twitter.yml'), current_user
  end

end