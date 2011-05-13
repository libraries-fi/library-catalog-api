require "marcxml_parser"
require "open-uri"

task :default => :parse_marcxml

desc "Put MARCXML documents to the database"
task :load_marcxml_files => :environment do
  file_name = ENV["FILE"]

  unless file_name
    p "Pass wanted file path (or URL) with environment variable FILE. Example: rake load_marcxml_files FILE=marcxml_file.xml"
  end

  counter = 0

  file = open(file_name)
  # Get past xml and collection declaration
  file.gets
  file.gets
  record_data = ""
  while line = file.gets
    record_data << line
    if line.match(/<\/record>/)
      record = Record.new(:marcxml => record_data)
      record.generate_json
      if record.valid?
        record.save!
        if record.helmet_id.blank? || record.title_main.blank? || record.author_main.blank?
          print "\e[31m.\e[0m"
        else
          print "\e[32m.\e[0m"
        end
        counter += 1
      else
        print "\e[33m.\e[0m"
      end
      record_data = ""
    end
  end

  puts 
  puts "-" * 30
  puts "Added #{counter} records."
end

task :migrate_isbn => :environment do
  Record.find_in_batches(:batch_size => 1000) do |record_group|
    print "."
    record_group.each do |record|
      record.send(:denormalize_isbn)
      record.save!
    end
  end
end

task :migrate_helmet_id => :environment do
  Record.find_in_batches(:batch_size => 1000) do |record_group|
    print "."
    record_group.each do |record|
      record.send(:denormalize_helmet_id)
      record.save!
    end
  end
end

task :migrate_json => :environment do
  Record.find_in_batches(:batch_size => 1000) do |record_group|
    print "."
    record_group.each do |record|
      record.generate_json
      record.save!
    end
  end
end

task :migrate_fields => :environment do
  Record.find_in_batches(:batch_size => 1000) do |record_group|
    print "."
    record_group.each do |record|
      record.send(:denormalize_fields)
      record.save!
    end
  end
end
