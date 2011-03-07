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
      record.save!
      record_data = ""
      if record.helmet_id.blank? || record.title_main.blank? || record.author_main.blank?
        print "\e[31m.\e[0m"
      else
        print "\e[32m.\e[0m"
      end
      counter += 1
    end
  end

  p
  p "-" * 30
  puts "Added #{counter} records."
end

desc "Parse MARCXML file to database."
task :parse_marcxml => :environment do
  filename = "#{Rails.root}/lib/tasks/helmet_catalog_0001.xml"
  
  begin
    xml = Nokogiri::XML(File.open(filename))

    xml.css("collection record").css("leader, datafield, controlfield")
    xml.css('collection record').each do |record|
      title = Record.create!
      record.css("leader, datafield, controlfield").each do |field|
        if field.children.empty?
          if field.name == "leader"
            title.data_fields.create!(:tag => "leader", :value => field.inner_html)
          else
            title.data_fields.create!(:tag => field[:tag], :value => field.inner_html)
          end
        else
          field.element_children.each do |sub_field|
            data_field = title.data_fields.build
            data_field.tag = field[:tag]
            data_field.ind1 = field[:ind1] if field[:ind1].present?
            data_field.ind2 = field[:ind2] if field[:ind2].present?
            data_field.code = sub_field[:code]
            data_field.helmet_id = record.css("controlfield").first.inner_html
            data_field.value = sub_field.inner_html
            data_field.save!
          end
        end
      end
      Record.all.each do |record|
        record.author_fields = record.data_fields.where("tag = '100' OR tag = '700'").map(&:value).join(", ")
        record.isbn = record.data_fields.where("tag = '020' OR tag = '024'").first.try(:value)
        record.title_fields = record.data_fields.where("tag = '245'").map(&:value).join(", ")
        record.helmet_id = record.data_fields.first.helmet_id
        record.save
      end
    end
    
  rescue Errno::ENOENT
    abort "You need to pass the filename: rake parse_marcxml FILE=[existing filename]"
  end
end

task :parse_marcxml_sax => :environment do
  # class Dir
  #     def self.ls dir, glob = File.join('**', '**'), &block
  #       ret = [] unless block
  #       Dir.glob(File.join(dir, glob)) do |entry|
  #        block ? block.call(entry) : ret.push(entry)
  #       end
  #       ret
  #     end
  #   end
  
  #Dir.ls("#{Rails.root}/lib/tasks/helmet_catalogdata/helmet_catalogdata_1000a") do |entry|
  entry = "#{Rails.root}/lib/tasks/helmet_catalog_0001.xml"
    begin
      parser = Nokogiri::XML::SAX::Parser.new(MarcxmlParser.new)
      parser.parse(File.open(entry))
    rescue Errno::ENOENT
      abort "You need to pass the filename: rake parse_marcxml FILE=[existing filename]"
    end
  #end
end
