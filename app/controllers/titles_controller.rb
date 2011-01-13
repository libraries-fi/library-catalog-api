class TitlesController < ApplicationController
  def index
    @titles = Title.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titles.to_xml(:include => :data_fields, :except => [:created_at, :updated_at]) }
    end
  end

  def show
    @title = Title.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @title.to_xml(:include => :data_fields, :except => [:created_at, :updated_at]) }
    end
  end
end

