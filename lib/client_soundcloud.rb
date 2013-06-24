require "open-uri"
require "json"

class ClientSoundcloud
  def initialize(options = {})
    @api_key = options[:api_key] || "apigee"
    @user_id = options[:user_id] || "thenobot"
  end

  def get_tracks
    JSON.parse(open("http://api.soundcloud.com/users/#{CGI.escape(@user_id)}/tracks.json?consumer_key=#{CGI.escape(@api_key)}").read)
  end
end
