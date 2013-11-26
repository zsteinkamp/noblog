require "rexml/document"
require "open-uri"
require "cgi"

class ClientFlickr
  def initialize(options = {})
    @api_key = options[:api_key] || "2b78ee62a1027fb4e72ce9c1d935a0e8"
    @user_id = options[:user_id] || "74677593@N00"
  end

  def request(method, arguments={})
    endpoint = "http://api.flickr.com/services/rest/"
    arg_map = arguments.collect {|arg,value| CGI.escape(arg)+"="+CGI.escape(value.to_s)}.join("&")
    call_uri = "#{endpoint}?api_key=#{@api_key}&method=#{method}&#{arg_map}"
    STDERR.puts call_uri
    response = REXML::Document.new(open(call_uri).read)
    if response.root.attributes["stat"] == "ok" then
      return response.root
    elsif response.root.attributes["stat"] == "fail" then
      raise "Flickr API error #{response.elements["rsp/err"].attributes["code"]}: #{response.elements["rsp/err"].attributes["msg"]}"
    else
      raise "Request status neither ok nor fail. Tried to fetch #{call_uri}."
    end
  end

  def flickr_username
    unless @username
      response = request('flickr.people.getInfo', { "user_id" => @user_id } )
      @username = response.elements["person/username"].text
    end
    @username
  end

  def get_photosets
    response = request('flickr.photosets.getList', { "user_id" => @user_id } )
    response.elements.collect("photosets/photoset") do |p| 
      {
        :id => p.attributes["id"],
        :link => "http://www.flickr.com/photos/#{flickr_username}/sets/#{p.attributes["id"]}/",
        :title => p.elements["title"].text,
        :description => p.elements["description"].text,
        :num_photos => p.attributes["photos"].to_i,
        :primary_photo_id => p.attributes["primary"],
        :primary_photo_url => "http://farm#{p.attributes["farm"]}.static.flickr.com/#{p.attributes["server"]}/#{p.attributes["primary"]}_#{p.attributes["secret"]}_m.jpg"
      }
    end
  end

  def get_photo_info(photo_id)
    response = request('flickr.photos.getInfo', { "photo_id" => photo_id.to_s } )
    {
      :id          => response.elements["photo"].attributes["id"],
      :pub_date    => response.elements["photo/dates"].attributes["taken"],
      :title       => response.elements["photo/title"].text,
      :description => response.elements["photo/description"].text,
      :thumb_url => "http://farm#{response.elements["photo"].attributes["farm"]}.static.flickr.com/#{response.elements["photo"].attributes["server"]}/#{response.elements["photo"].attributes["id"]}_#{response.elements["photo"].attributes["secret"]}_s.jpg",
    }
  end

  def get_photo_date(photo_id)
    response = request('flickr.photos.getInfo', { "photo_id" => photo_id.to_s } )
    response.elements["photo/dates"].attributes["taken"]
  end

  def get_set_extras(set)
    set[:pub_date] = get_photo_date(set[:primary_photo_id])
    set[:photos] = get_set_photos(set[:id])
    set
  end


  def get_set_photos(set_id)
    photos = []
    response = request('flickr.photosets.getPhotos', { "photoset_id" => set_id.to_s })
    response.elements.each("photoset/photo") do |p| 
      photos << get_photo_info(p.attributes["id"])
    end
    photos
  end
end
