class AdminController < ApplicationController
  before_filter :authenticate

  def index
    @entries = Entry.all(:order => "pub_date DESC")
  end

  def photo
    if request.get?
      return render
    end

    require 'lib/client_flickr'
    c = ClientFlickr.new
    attrs = c.get_photo_info(params[:url])
    e = Entry.create(
      :source => EntryPost::SOURCE_NAME, 
      :pub_date => attrs[:pub_date], 
      :data => attrs 
    )
    return redirect_to(:controller => "admin", :action => "index")
  end


  def edit
    @entry = Entry.find_by_id(params[:id])
    unless @entry || params[:new] == "1"
      return render :status => 404, :text => "Not Found"
    end

    unless @entry
      @entry = Entry.new( :source => EntryPost::SOURCE_NAME, :pub_date => Time.now, :data => { :title => "" } )
    end

    if request.get?
      return render
    end

    @entry.disabled = params[:disabled] == "1"
    @entry.data[:title] = params[:title]
    @entry.pub_date = params[:pub_date]

    unless params[:addl_fields].blank?
      params[:addl_fields].split(/,/).each do |field|
        @entry.data[field.to_sym] = params[field.to_sym]
      end
    end

    @entry.save

    return redirect_to :controller => "admin", :action => "index"
  end

  # publish to facebook
  def publish_to_fb
    @entry = Entry.find_by_id(params[:id])
    unless @entry
      return render :status => 404, :text => "Not Found"
    end
    resp = @entry.publish_to_fb
    render :text => resp.body
  end

  protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "zs" && password == "asimov"
    end
  end
end
