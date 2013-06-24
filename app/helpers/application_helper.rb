module ApplicationHelper
  def render_entry_short(entry)
    render :partial => "entry/short_#{entry.source}", :locals => { :entry => entry }
  end

  def render_entry(entry)
    begin
      render :partial => "entry/full_#{entry.source}", :locals => { :entry => entry }
    rescue ActionView::MissingTemplate => e
      render :partial => "entry/short_#{entry.source}", :locals => { :entry => entry }
    end
  end

  def render_entry_item(entry)
    begin
      render :partial => "entry/item_#{entry.source}", :locals => { :entry => entry, :item_id => params[:item_id].to_i }
    rescue ActionView::MissingTemplate => e
      render_entry(entry)
    end
  end
end
