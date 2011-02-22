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
      @results = Record.search_by_isbn(@search_query).paginate(:page => params[:page], :per_page => 5)
    elsif string == "author"
      @results = Record.search_by_author(@search_query).paginate(:page => params[:page], :per_page => 5)
    elsif string == "title"
      @results = Record.search_by_title(@search_query).paginate(:page => params[:page], :per_page => 5)
    end
    respond_to do |format|  
      format.json {  
        render :json => {  
          :current_page => @results.current_page,
          :per_page => @results.per_page,
          :total_entries => @results.total_entries,
          :entries => @results  
        }
      }
    end
  end
end
