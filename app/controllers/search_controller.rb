require 'will_paginate/array'

class SearchController < ApplicationController
  PER_PAGE = 12

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

  def item
    barcodes = params[:query]
    @search_type = :item
    @items = Item.where(:barcode => barcodes)
    @records = @items.collect do |item|
      record = item.record
      record.item_barcode = item.barcode
      barcodes.delete(item.barcode.to_s)
      record
    end
    # Any barcodes left were not found in the database
    # and require 
    if barcodes.length > 0
      Rails.logger.warn "#{Time.new} Missing items #{barcodes}"
    end
    respond_with_records(@records)
  end
  
  private
  
  def respond_with_records(records)
    respond_to do |format|
      format.html { render "index" }
      format.json {
        if params[:callback]
          if @search_type == :item
            json = records_as_json_with_itemids(records, params[:callback])
          else
            json = records_as_json(records, params[:callback])
          end
          render :js => json, :content_type => 'application/javascript'
        else
          if @search_type == :item
            render :json => records_as_json_with_itemids(records)
          else
            render :json => records_as_json(records)
          end
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
