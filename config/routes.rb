KirjastoData::Application.routes.draw do
  resources :records, :only => [:index, :show]
  match "/search/isbn" => "search#isbn", :as => :isbn_search, :via => :get
  match "/search/author" => "search#author", :as => :author_search, :via => :get
  match "/search/title" => "search#title", :as => :title_search, :via => :get, :format => :json

  root :to => "pages#home"
end
