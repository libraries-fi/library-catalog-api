class PagesController < ApplicationController
  def home
  end
  
  def search
    @search_type = :title
  end
end