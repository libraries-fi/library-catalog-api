
$csv_options = {
  :col_sep => "\t",
  # the quote char should never be found in the data
  :quote_char => "\u{10ffff}",
  :headers => false
}

def load_bib_data(file_name)
  file = File.open(file_name, "r")
  headers = nil
  row = nil
  counter = 0
  rows = []
  last_record_no = nil

  helmet_ids_to_record_ids = Hash.new()
  
  file.each_line do |line|
    if file.lineno > 1
      row = CSV::parse_line(preprocess_line(line), $csv_options)
    else
      headers = CSV::parse_line(line, $csv_options)
    end
    if row
      # row.map! do |item|
      #   new_item = []
      #   if item
      #     new_item = item.split("\\")
      #   end
      #   if new_item.length > 1
      #     new_item
      #   else
      #     item
      #   end
      # end
      row_hash = Hash[*headers.zip(row).flatten(1)]
      record_no = row_hash["RECORD #(BIBLIO)"].chop
      if record_no == last_record_no
        next
      else
        last_record_no = record_no
      end

      helmet_id = "(FI-HELMET)" + record_no
      record = Record.find_or_initialize_by_helmet_id(helmet_id)
      record.marcxml = nil
      record.importdata = row_hash
      begin
        counter = handle_record(record, counter)
        helmet_ids_to_record_ids[helmet_id] = record.id
      rescue Exception => e
        puts
        puts "line number #{file.lineno}"
        puts e.message  
        puts e.backtrace.inspect
      end
    end
  end
  puts "Imported/updated #{counter} title records."
  return helmet_ids_to_record_ids
end

def handle_items(file_name, helm_to_id)
  file = open(file_name)
  file.gets

  counter = 0
  errocounter = 0
  while line = file.gets
    begin
      line.tr!("\\", "\t")
      fields = CSV::parse_line(line, $csv_options)
    rescue CSV::MalformedCSVError => e
      line.tr!("\\", "\t")
      fields = CSV::parse_line(line, $csv_options)
    end
    helmet_id = "(FI-HELMET)" << fields.shift.chop
    rec_id = helm_to_id[helmet_id]
    unless rec_id.nil?

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

      items.each do |item_no, barcode|
        item_no = item_no[1..-2]
        barcode = Item.normalize_barcode(barcode)
        if not barcode.nil? and barcode != 0 and barcode != ''
          begin
            Item.connection.execute "INSERT INTO items (barcode, item_no, created_at, updated_at, record_id) VALUES (#{barcode}, #{item_no}, now(), now(), #{rec_id});"
            counter += 1
          rescue ActiveRecord::RecordNotUnique => e
            puts "The item or barcode already exists: #{barcode}, i#{item_no}, #{rec_id}"
            errocounter += 1
          end
        end
      end
    end
  end
  puts "Imported #{counter} items, with #{errocounter} items/barcodes already found in database."
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
