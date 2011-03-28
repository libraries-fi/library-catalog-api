class SearchController < ApplicationController
  PER_PAGE = 30

  def form_redirect
    type = params.delete(:type)
    query = params.delete(:query)
    redirect_to ({:controller => :search, :action => type, :query => query})
  end
  
  def isbn
    @search_type = :isbn
    search(@search_type)
  end
  
  def author
    @search_type = :author
    search(@search_type)
  end
  
  def title
    @search_type = :title
    search(@search_type)
  end
  
  private
  
  def search(search_type)
    @search_query = params[:query]
    case search_type
    when :isbn
      @records = Record.search_by_isbn(@search_query).paginate(:page => params[:page], :per_page => PER_PAGE)
    when :author
      @records = Record.search_by_author(@search_query).paginate(:page => params[:page], :per_page => PER_PAGE)
    when :title
      @records = Record.search_by_title(@search_query).paginate(:page => params[:page], :per_page => PER_PAGE)
    end

    respond_to do |format|
      format.html { render "index" }
      format.json {
        if params[:callback]
          render :js => records_as_json(@records, params[:callback])
        else
          render :json => records_as_json(@records)
        end
      }
      format.marcxml { render "records/index" }
    end
  end
end
