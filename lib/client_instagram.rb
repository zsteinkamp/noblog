require 'net/https'
require 'date'

class ClientInstagram
  def initialize(options = {})
    @client_id = options[:client_id] || "207e759c3f4647d3b4f7104d3d66247a"
    @client_secret = options[:client_secret] || "9a8faaca038b492497719e01cb6a621b"
    @client_code = options[:client_code] || "74b08fb4355143b0b6628289054bacef"
    @token = options[:token] || '1931944135.207e759.0b7c980dc03347ffb5ff81c5f5a776b6'
  end

  def fetch_token
    uri = URI.parse("https://api.instagram.com/oauth/access_token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)

    request.set_form_data({
      'client_id' => @client_id,
      'client_secret' => @client_secret,
      'grant_type' => 'authorization_code',
      'redirect_uri' => 'http://steinkamp.us/',
      'code' => @client_code
    })

    response = http.request(request)
    response.body
  end

  def get_photos
    uri = URI.parse("https://api.instagram.com/v1/users/self/media/recent/?access_token=#{@token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    d = JSON.parse(response.body)
    d['data'].collect do |img|
      {
        :pub_date => Time.at(img['created_time'].to_i).to_datetime,
        :id => img['id'],
        :link => img['link'],
        :title => img['caption'] && img['caption']['text'] || '(untitled)',
        :thumb_url => img['images']['thumbnail']['url'],
        :image => img['images']['standard_resolution']
      }
    end
  end
end

