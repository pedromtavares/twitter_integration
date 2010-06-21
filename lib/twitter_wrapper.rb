 class TwitterWrapper
   attr_reader :tokens
   
   def initialize(config, user)
     @config = config
     @tokens = YAML::load_file @config
     @callback_url = @tokens['callback_urls'][Rails.env]
     @auth = Twitter::OAuth.new @tokens['consumer_token'], @tokens['consumer_secret']
     @user = user
   end
   
   def request_tokens
     rtoken = @auth.request_token :oauth_callback => @callback_url
     [rtoken.token, rtoken.secret]
   end
   
   def authorize_url
     @auth.request_token(:oauth_callback => @callback_url).authorize_url
   end
   
   def auth(rtoken, rsecret, verifier)
     @auth.authorize_from_request(rtoken, rsecret, verifier)
     @user.access_token, @user.access_secret = @auth.access_token.token, @auth.access_token.secret
     @user.save
   end
   
   def get_twitter
     @auth.authorize_from_access(@user.access_token, @user.access_secret)
     twitter = Twitter::Base.new @auth
     begin
      twitter.home_timeline(:count => 1)
      twitter
     rescue
      nil
     end
   end
 end