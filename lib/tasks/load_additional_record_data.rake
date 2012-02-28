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
        newitem = record.items.create(:barcode => barcode)
        print "\e[32m.\e[0m"
      end
    end
  end
  print 'done'
end
