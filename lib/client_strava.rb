require "publish_fb"
require "json"
require "net/https"

class ClientStrava
  def initialize(options = {})
    @api_key = options[:api_key]
  end

  def get_activities
    uri = URI.parse("https://www.strava.com/api/v3/athlete/activities?per_page=100")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = "Bearer #{@api_key}"

    response = http.request(request)

    JSON.parse(response.body).collect do |activity|
      {
        :pub_date => activity["start_date"],
        :title => activity["name"],
        :link => "http://app.strava.com/activities/#{activity["id"]}",
        :id => activity["id"],
        :activity_type => activity["type"],
        :total_elevation_gain => activity["total_elevation_gain"],
        :elapsed_time => activity["elapsed_time"],
        :distance => activity["distance"],
        :max_speed => activity["max_speed"],
        :average_speed => activity["average_speed"],
        :moving_time => activity["moving_time"],
        :location_city => activity["location_city"],
        :location_state => activity["location_state"],
      }
    end
  end
end
