Noblog::Application.routes.draw do
  # entries
  root :to => 'entry#index'
  match 'rss.xml'                   => 'entry#rss'
  match 'ip'                        => 'entry#ip'
  match 'page/:page'                => 'entry#index'
  match 'source/:source'            => 'entry#index'
  match 'source/:source/page/:page' => 'entry#index'
  match 'timeline.json'             => 'timeline#index'

  # admin
  match 'admin'                     => 'admin#index'
  match 'admin/add'                 => 'admin#edit', :new => "1"
  match 'admin/photo'               => 'admin#photo'
  match 'admin/edit/:id'            => 'admin#edit'
  match 'admin/publish_to_fb/:id'   => 'admin#publish_to_fb'

  match 'workout'                   => 'workout#index'
  match 'workout/json'              => 'workout#json'

  # static
  match 'resume' => 'static#index', :page => 'resume'
  match 'sweat'  => 'static#index', :page => 'sweat'
  match 'hikes'  => 'static#index', :page => 'hikes'
  match 'links'  => 'static#index', :page => 'links'
  match 'static/:page', :controller => 'static', :action => 'index'

  # entry / item
  match ':entry_id/:item_id/*junk'  => 'entry#item',   :constraints => { :entry_id => /\d+/, :item_id => /\d+/ }
  match ':entry_id/*junk'           => 'entry#single', :constraints => { :entry_id => /\d+/ }
  #match ':year/:month'              => 'entry#index', :constraints => { :year => /\d{4}/, :month => /\d{2}/ }
end
