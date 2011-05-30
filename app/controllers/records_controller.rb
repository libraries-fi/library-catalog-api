class RecordsController < ApplicationController
  respond_to :json, :marcxml
  
  def index
    @records = Record.all.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        if params[:callback]
          render :js => records_as_json(@records, params[:callback]), :content_type => 'application/javascript'
        else
          render :json => records_as_json(@records)
        end
      }
      format.marcxml # index.xml.erb
    end
  end

  def show
    @record = Record.where(:helmet_id => params[:id]).first

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        if params[:callback]
          render :js => record_as_json(@record, params[:callback]), :content_type => 'application/javascript'
        else
          render :json => record_as_json(@record)
        end
      }
      format.marcxml # show.xml.erb
    end
  end
  
end
