KirjastoData::Application.routes.draw do
  resources :records, :only => :index
  
  match "/records/:helmet_id" => "records#show", :via => :get, :as => "show_record"
  
  match "/search/isbn" => "search#isbn", :as => :search, :via => :get
  match "/search/author" => "search#author", :as => :search, :via => :get
  match "/search/title" => "search#title", :as => :search, :via => :get, :format => :json

  root :to => "pages#home"
end
