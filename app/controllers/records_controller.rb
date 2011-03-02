class RecordsController < ApplicationController
  respond_to :json, :marcxml
  
  def index
    @records = Record.all.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => records_as_json(@records) }
      format.marcxml # index.xml.erb
      format.jsonp { render :js => records_as_json(@records, true) }
    end
  end

  def show
    @record = Record.where(:helmet_id => params[:id]).first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => record_as_json(@record) }
      format.marcxml # show.xml.erb
      format.jsonp { render :js => records_as_json(@records, true) }
    end
  end
  
end
