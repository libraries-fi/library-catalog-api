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

require 'csv'

task :default => :load_additional_data

desc "Load barcodes and other additional data from text files"
task :load_additional_data => :environment do
  file_name = ENV["FILE"]

  unless file_name
    p <<MSG
        Pass wanted file path (or URL) with environment variable FILE. Example: rake load_additional_data FILE=barcodes.csv
MSG
  end

  file = open(file_name)
  file.gets
  while line = file.gets
    begin
      fields = line.parse_csv
    rescue CSV::MalformedCSVError => e
      line.tr!(';', ',')
      fields = line.parse_csv
    end
    helmet_id = "(FI-HELMET)" << fields.shift.chop
    record_a = Record.where(:helmet_id => helmet_id)
    if record_a.exists?
      record = record_a.first
      fields.each do |barcode|
	barcode = Item.normalize_barcode(barcode)
        if not barcode.nil? and barcode != 0
          newitem = record.items.find_or_initialize_by_barcode(barcode)
          print "\e[32m.\e[0m"
          begin
            newitem.save! unless newitem.nil?
	  rescue ActiveRecord::RecordNotUnique => e
            print 'duplicate barcode ', barcode
          end
        end
      end
    end
  end
  print 'done'
end
