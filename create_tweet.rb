require 'json'
require 'byebug'
require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'

require 'lib/authorize.rb'

create_tweet_url = "https://api.twitter.com/2/tweets"

# Be sure to add replace the text of the with the text you wish to Tweet.
# You can also add parameters to post polls, quote Tweets, Tweet with reply settings, and Tweet to Super Followers in addition to other features.
@json_payload = {"text": "hey its josh again now im tweeting from refactored ruby classes with oauth 1.0a"}

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

authorizer = Authorize.new
oauth_params = { consumer: authorizer.oauth_consumer, token: authorizer.oauth_token }
response = create_tweet(create_tweet_url, oauth_params)
puts response.code, JSON.pretty_generate(JSON.parse(response.body))
