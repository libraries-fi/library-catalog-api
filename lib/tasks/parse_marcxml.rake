require "marcxml_parser"

task :default => :parse_marcxml

desc "Parse MARCXML file to database."
task :parse_marcxml => :environment do
  filename = ENV["FILE"] || ""
  
  begin
    xml = Nokogiri::XML(File.open(filename))

    xml.css("collection record").css("leader, datafield, controlfield")
    xml.css('collection record').each do |record|
      title = Title.create!
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
            data_field.value = sub_field.inner_html
            data_field.save!
          end
        end
      end
    end
    
  rescue Errno::ENOENT
    abort "You need to pass the filename: rake parse_marcxml FILE=[existing filename]"
  end
end

task :parse_marcxml_sax => :environment do
  filename = ENV["FILE"] || ""
  
  begin
    parser = Nokogiri::XML::SAX::Parser.new(MarcxmlParser.new)
    parser.parse(File.open(filename))
  rescue Errno::ENOENT
    abort "You need to pass the filename: rake parse_marcxml FILE=[existing filename]"
  end
end
