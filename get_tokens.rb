require 'json'
require 'byebug'
require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'

$LOAD_PATH << './lib'
require 'authorizer'

def create_tweet(url, oauth_params)
	options = {
	    :method => :post,
	    headers: {
	     	"User-Agent": "v2CreateTweetRuby",
        "content-type": "application/json"
	    },
	    body: JSON.dump(@json_payload)
	}
	request = Typhoeus::Request.new(url, options)
	oauth_helper = OAuth::Client::Helper.new(request, oauth_params.merge(:request_uri => url))
	request.options[:headers].merge!({"Authorization" => oauth_helper.header}) # Signs the request
	response = request.run

	return response
end

authorizer = Authorizer.new
token = authorizer.oauth_token
puts "OAuth Access Token: #{token.token}"
puts "OAuth Token Secret: #{token.secret}"
puts "Write these down!!!"
