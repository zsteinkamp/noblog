class StaticController < ApplicationController
  def index
    begin
      @no_header_footer = (params[:page] == "resume")
      render :template => "/static/#{params[:page]}"
    rescue ActionView::MissingTemplate => e
      logger.error e
      render :status => 404, :text => "Not Found"
    end
  end
end
