require "net/https"

class PublishFB
  include ApplicationHelper
  def publish(entry)
    url = URI.parse("https://graph.facebook.com/#{CFG["facebook"]["username"]}/feed")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(url.path)
    form_data = {
      "access_token" => CFG["facebook"]["access_token"]
    }
    if entry.thumb_url
      form_data["picture"] = entry.thumb_url
    end
    if entry.fb_link
      form_data["name"] = entry.disp_title
      form_data["link"] = entry.fb_link
      form_data["caption"] = CFG["facebook"]["link_caption"]
      form_data["description"] = entry.data[:desc] || entry.data[:description] || entry.data[:excerpt]
    else
      form_data["message"] = entry.disp_title
    end
    req.set_form_data(form_data)

    http.request(req)
  end
end
