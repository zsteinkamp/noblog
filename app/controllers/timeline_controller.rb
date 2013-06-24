class TimelineController < ApplicationController
  def index
    # timeline stuff
    @tl_hash = Hash.new{ |h,k| h[k] = 0 }

    tl_conditions = [ "`disabled` = ?", false ]
    unless params[:source].blank?
      tl_conditions[0] += " AND `source` = ?"
      tl_conditions.push params[:source]
    end

    Entry.all(:select => "pub_date, source", :conditions => tl_conditions, :order => "pub_date").each do |entry|
      pd = entry.pub_date
      hkey = Time.local(pd.year, pd.month, 15).strftime("%s").to_i
      @tl_hash[hkey] += 1
    end
    @timeline = []
    @tl_hash.keys.sort.each do |tl_key|
      @timeline.push({ "date" => tl_key, "entries" => @tl_hash[tl_key] })
    end

    render :text => @timeline.to_json
  end
end
