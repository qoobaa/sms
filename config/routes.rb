ActionController::Routing::Routes.draw do |map|
  map.resource :user, :member => { :delete => :get }
  map.resource :user_session, :member => { :delete => :get }, :only => [:new, :create, :delete, :destroy]
  map.resources :messages, :member => { :delete => :get }, :collection => { :pending => :get, :delivered => :get, :deleted => :get }
  map.resources :gateways, :member => { :delete => :get }
  map.resources :telephone_numbers, :member => { :delete => :get }, :only => [:index, :show, :new, :create, :delete, :destroy]
  map.resources :contacts, :member => { :delete => :get }
  map.resources :recipients, :only => :index

  map.root :controller => "messages", :action => "new"
end
