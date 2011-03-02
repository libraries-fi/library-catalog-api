class RecordsController < ApplicationController
  respond_to :json
  
  def index
    @records = Record.all.paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml # index.xml.erb
    end
  end

  def show
    @record = Record.where(:helmet_id => params[:helmet_id]).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @record.to_xml(:include => :data_fields, :except => [:created_at, :updated_at]) }
    end
  end
  
end
