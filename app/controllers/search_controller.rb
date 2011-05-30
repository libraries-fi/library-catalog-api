class SearchController < ApplicationController
  PER_PAGE = 30

  def form_redirect
    type = params.delete(:type)
    query = params.delete(:query)
    redirect_to ({:controller => :search, :action => type, :query => query})
  end
  
  def isbn
    @search_type = :isbn
    @record = Record.search_by_isbn(params[:query]).first
    respond_with_record(@record)
  end
  
  def author
    @search_type = :author
    main = Record.search_by_author(params[:query])
    more = Record.search_by_additional_authors(params[:query])
    @records = (main + more).paginate(:page => params[:page], :per_page => PER_PAGE)
    respond_with_records(@records)
  end
  
  def title
    @search_type = :title
    @records = Record.search_by_title(params[:query]).paginate(:page => params[:page], :per_page => PER_PAGE)
    respond_with_records(@records)
  end
  
  private
  
  def respond_with_records(records)
    respond_to do |format|
      format.html { render "index" }
      format.json {
        if params[:callback]
          render :js => records_as_json(records, params[:callback]), :content_type => 'application/javascript'
        else
          render :json => records_as_json(records)
        end
      }
      format.marcxml { render "records/index" }
    end
  end

  def respond_with_record(record)
    respond_to do |format|
      format.html { render "index" }
      format.json {
        if params[:callback]
          render :js => record_as_json(record, params[:callback]), :content_type => 'application/javascript'
        else
          render :json => record_as_json(record)
        end
      }
      format.marcxml { render "records/index" }
    end
  end
end
