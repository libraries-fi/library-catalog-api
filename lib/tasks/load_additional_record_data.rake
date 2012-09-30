require 'csv'
require 'record_helper'
require 'csv_import'


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
      line.tr!("\\", "\t")
      fields = CSV::parse_line(line, csv_options)
    rescue CSV::MalformedCSVError => e
      line.tr!("\\", "\t")
      fields = CSV::parse_line(line, csv_options)
    end
    helmet_id = "(FI-HELMET)" << fields.shift.chop
    record_a = Record.where(:helmet_id => helmet_id)

    if record_a.exists?
      item_nos = []
      barcodes = []
      fields.chunk{|item| (item and item.match(/i[0-9]{6,}x?/) != nil)}.map do |predicate, values|
        if predicate
          item_nos = values
        else
          barcodes = values
        end
      end
      items = item_nos.zip(barcodes)

      record = record_a.first
      items.each do |item_no, barcode|
        item_no = item_no[1..-2]
        barcode = Item.normalize_barcode(barcode)
        if not barcode.nil? and barcode != 0
          newitem = record.items.find_or_initialize_by_barcode(barcode)
          newitem.item_no = item_no
          begin
            newitem.save! unless newitem.nil?
            print "\e[32m.\e[0m"
          rescue ActiveRecord::RecordNotUnique => e
            print 'duplicate barcode ', barcode
          rescue ActiveRecord::RecordInvalid => e
            puts
            puts "duplicate barcode or item no #{barcode} #{item_no}"
          rescue PGError=>e
            puts
            puts "too big barcode #{barcode}, #{e.to_s}"
          end
        end
      end
    end
  end
  print 'done'
end


desc "Load bibliographic and item data from the same csv-like text file"
task :load_full_data => :environment do
  file_name = ENV["FILE"]

  unless file_name
    p <<MSG
        Pass wanted file path (or URL) with environment variable FILE. Example: rake load_full_data FILE=barcodes.csv
MSG
  else
    puts "Beginning import of file #{file_name} at #{Time.now()}"
    recid_mappings = load_bib_data(file_name)
    handle_items(file_name, recid_mappings)
    puts "Import finished at #{Time.now()}"
  end
end

desc "Load only bibliographic data from a csv-like text file"
task :load_csv_bib_data => :environment do
  file_name = ENV["FILE"]
  unless file_name
    p <<MSG
        Pass wanted file path (or URL) with environment variable FILE. Example: rake load_full_data FILE=barcodes.csv
MSG
  else
    load_bib_data(file_name)
  end
end
