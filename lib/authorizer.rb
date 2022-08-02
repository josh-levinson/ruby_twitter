require 'oauth'

class Authorizer
  def initialize
    @consumer_key = ENV["CONSUMER_KEY"]
    @consumer_secret = ENV["CONSUMER_SECRET"]
  end

  def oauth_consumer
    consumer 
  end

  def oauth_token
    return use_existing_access_token(consumer) if ENV["ACCESS_TOKEN"]

    # PIN-based OAuth flow - Step 1
    request_token = get_request_token(consumer)
    # PIN-based OAuth flow - Step 2
    pin = get_user_authorization(request_token)
    # PIN-based OAuth flow - Step 3
    obtain_access_token(consumer, request_token, pin)
  end

  private

  def consumer
    @consumer ||= 
      OAuth::Consumer.new(@consumer_key, @consumer_secret,
                          :site => 'https://api.twitter.com',
                          :authorize_path => '/oauth/authenticate',
                          :debug_output => false)
  end

  def get_request_token(consumer)
    request_token = consumer.get_request_token()

    return request_token
  end

  def get_user_authorization(request_token)
    puts "Follow this URL to have a user authorize your app: #{request_token.authorize_url()}"
    puts "Enter PIN: "
    pin = gets.strip

    return pin
  end

  def obtain_access_token(consumer, request_token, pin)
    token = request_token.token
    token_secret = request_token.secret
    hash = { :oauth_token => token, :oauth_token_secret => token_secret }
    request_token  = OAuth::RequestToken.from_hash(consumer, hash)

    # Get access token
    access_token = request_token.get_access_token({:oauth_verifier => pin})

    return access_token
  end

  def use_existing_access_token(consumer)
    oauth_hash = { oauth_token: ENV["ACCESS_TOKEN"], oauth_token_secret: ENV["ACCESS_TOKEN_SECRET"] }
    OAuth::AccessToken.from_hash(consumer, oauth_hash)
  end
end
