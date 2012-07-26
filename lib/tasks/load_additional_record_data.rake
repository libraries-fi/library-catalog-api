require 'csv'
require 'record_helper'

csv_options = {
  :col_sep => "\t",
  :quote_char => '~',
  :headers => false
}


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
      fields = CSV::parse_line(line, csv_options)
    rescue CSV::MalformedCSVError => e
      line.tr!(';', ',')
      fields = line.parse_csv
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
    file = File.open(file_name, "r")
    headers = nil
    row = nil
    counter = 0
    rows = []
    file.each_line do |line|
      if file.lineno > 1
        row = CSV::parse_line(preprocess_line(line), csv_options)
      else
        headers = CSV::parse_line(line, csv_options)
      end
      if row
        row.map! do |item|
          new_item = []
          if item
            new_item = item.split("\\")
          end
          if new_item.length > 1
            new_item
          else
            item
          end
        end
        row_hash = Hash[*headers.zip(row).flatten(1)]
        record = Record.find_or_initialize_by_helmet_id(
          "(FI-HELMET)" + row_hash["RECORD #(BIBLIO)"].chop)
        record.marcxml = nil
        record.importdata = row_hash
        counter = handle_record(record, counter)
        record.ensure_array(
          row_hash["BARCODE"]).zip(
            record.ensure_array(
              row_hash["RECORD #(ITEM)"])).each do |barcode, itemno|

          barcode = Item.normalize_barcode(barcode)
          if not barcode.nil? and barcode != 0 and not itemno.nil? and itemno != 0
            newitem = record.items.find_or_initialize_by_barcode(barcode)

            #strip leading i and trailing checksum
            newitem.item_no = itemno[1..-2]
            print "\e[34m.\e[0m"
            begin
              newitem.save! unless newitem.nil?
            rescue ActiveRecord::RecordNotUnique => e
              puts
              puts 'duplicate barcode #{barcode}'
            rescue ActiveRecord::RecordInvalid => e
              puts
              puts "duplicate barcode or item no #{barcode} #{itemno}"
            end
          end
        end
      end
    end
  end
end

def preprocess_line(line)
  fields = line.split("\t")
  fixed_fields = fields[0..29]
  variable_fields = fields[30..-1]
  pattern = /i[0-9]{6,}x?/
  variable_fields.chunk {|field| pattern.match(field) != nil}.each do |item_id, values|
    fixed_fields.push(values.join("\\"))
  end
  return fixed_fields.join("\t")
end
