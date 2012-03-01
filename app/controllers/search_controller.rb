# This file is part of Library Catalog API
# Copyright (C) 2011,2012  Kisko Labs Oy
#
# Library Catalog API is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

  def item
    @search_type = :item
    @items = Item.where(:barcode => params[:query])
    @records = @items.collect do |item|
      record = item.record
      record.item_barcode = item.barcode
      record
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
