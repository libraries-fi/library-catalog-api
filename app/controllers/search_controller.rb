class SearchController < ApplicationController
  def isbn
    search("isbn")
  end
  
  def author
    search("author")
  end
  
  def title
    search("title")
  end
  
  def search(string)
    @search_query = params[:query]
    if string == "isbn"
      @records = Record.search_by_isbn(@search_query).paginate(:page => params[:page], :per_page => 5)
    elsif string == "author"
      @records = Record.search_by_author(@search_query).paginate(:page => params[:page], :per_page => 5)
    elsif string == "title"
      @records = Record.search_by_title(@search_query).paginate(:page => params[:page], :per_page => 5)
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
