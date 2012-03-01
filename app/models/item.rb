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

class Item < ActiveRecord::Base
  belongs_to :record

  def barcode=(barcode_string)
    if not barcode_string.nil?
      write_attribute(:barcode, Item.normalize_barcode(barcode_string))
    end
  end

  def self.normalize_barcode(barcode_string)
    if barcode_string.nil? or not barcode_string.kind_of? String
      return nil
    end
    return barcode_string.gsub(/[^0-9]/, '')
  end
end
