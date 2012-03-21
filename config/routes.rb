KirjastoData::Application.routes.draw do
  resources :records, :only => [:index, :show]
  match "/search/isbn" => "search#isbn", :as => :isbn_search, :via => :get
  match "/search/author" => "search#author", :as => :author_search, :via => :get
  match "/search/title" => "search#title", :as => :title_search, :via => :get
  match "/search/item" => "search#item", :as => :item_search, :via => :get
  match "/search/form_redirect" => "search#form_redirect", :as => :search_form_redirect, :via => :get
  match "/search" => "pages#search", :as => :search_page, :via => :get
  match "/feedback" => "pages#feedback", :as => :feedback, :via => :get

  root :to => "pages#home"
end
