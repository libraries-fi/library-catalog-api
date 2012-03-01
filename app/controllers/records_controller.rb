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
