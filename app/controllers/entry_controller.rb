require 'digest/md5'

class EntryController < ApplicationController
  def index
    @group_sources = {
      'pictures' => ['flickr'],
      'videos' => ['quicktime','youtube','vimeo'],
      'words' => ['post','twitter'],
      'sounds' => ['soundcloud']
    }

    conditions = [ "`disabled` = ?", false ]

    unless params[:source].blank?
      conditions[0] += " AND `source` IN (?)"
      conditions.push @group_sources[params[:source]] || [params[:source]]
    end

    unless params[:search].blank?
      conditions[0] += " AND `data` LIKE ?"
      conditions.push "%#{params[:search]}%"
    end

    unless params[:year].blank?
      conditions[0] += " AND YEAR(pub_date) = ?"
      conditions.push params[:year].to_i
    end
    unless params[:month].blank?
      conditions[0] += " AND MONTH(pub_date) = ?"
      conditions.push params[:month].to_i
    end

    query_args = { :conditions => conditions, :order => "pub_date DESC" }

    # limit 20 if no yr/mo
    if (params[:year].blank? && params[:month].blank? && params[:source].blank?)
      query_args[:limit] = 20
    end

    # gather entries to show
    @entries = Entry.all(query_args)

    t0 = Time.now

    newest_entry = Entry.last(:order => "updated_at")
    timeline_hash = Digest::MD5.hexdigest(query_args.to_yaml)

    unless ((tl_cache = TimelineCache.find_by_tl_hash(timeline_hash)) && tl_cache.created_at > newest_entry.updated_at)
      logger.info "*** TL Cache Miss"
      # timeline stuff
      @timeline = {}
      @timeline[:histo] = Hash.new{ |h,k| h[k] = 0 }
      @timeline[:hmax] = 0

      tl_conditions = [ "`disabled` = ?", false ]
      unless params[:source].blank?
        tl_conditions[0] += " AND `source` IN (?)"
        tl_conditions.push @group_sources[params[:source]] || params[:source]
      end

      logger.info(tl_conditions.inspect)
      logger.info(@group_sources[params[:source]])

      Entry.all(:select => "pub_date, source", :conditions => tl_conditions, :order => "pub_date").each do |entry|
        hkey = entry.pub_date.strftime("%Y-%m")
        @timeline[:histo][hkey] += 1
        @timeline[:hmax] = @timeline[:histo][hkey] if @timeline[:histo][hkey] > @timeline[:hmax]
      end
      hkeys = @timeline[:histo].keys.sort
      mmin = hkeys[0]
      mmax = hkeys[-1]
      @timeline[:ymin] = mmin.split("-").first.to_i
      @timeline[:ymax] = mmax.split("-").first.to_i
      TimelineCache.create(:tl_hash => timeline_hash, :data => @timeline)
    else
      @timeline = tl_cache.data
      logger.info "*** TL Cache Hit"
    end

    logger.info "HISTO: #{Time.now - t0}"
  end

  def rss
    query_args = { :conditions => "`disabled` = false", :order => "pub_date DESC" }
    if params[:num].blank?
      query_args[:limit] = 20
    else
      query_args[:limit] = params[:num].to_i
    end
    @entries = Entry.all(query_args)
    response.content_type = "application/xml; charset=utf-8"
    render :layout => false
  end

  def single
    # urls have the ID as the first item
    unless @entry = Entry.find_by_id(params[:entry_id])
      return not_found
    end
  end

  def item
    # urls have the ID as the first item
    unless @entry = Entry.find_by_id(params[:entry_id])
      return not_found
    end
  end

  def ip
    render :text => request.remote_ip
  end
end
