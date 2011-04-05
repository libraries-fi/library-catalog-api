# encoding: utf-8
#
class Record < ActiveRecord::Base
  include PgSearch

  def self.search_by_isbn(isbn)
    where(:isbn => isbn.tr("- ", ""))
  end

  pg_search_scope :search_by_title, :against => :title_main, :using => {
    :tsearch => {
      :dictionary => "finnish"
    }
  }
  pg_search_scope :search_by_author, :against => :author_main, :using => {
    :tsearch => {
      :dictionary => "finnish"
    }
  }
  
  validates_uniqueness_of :helmet_id

  def name
    if title_main.match(/ \/$/)
      title_main[0..-3]
    else
      title_main
    end
  end

  def marcxml=(new_marcxml)
    @parsed_xml = nil
    write_attribute(:marcxml, new_marcxml)
    denormalize_fields
  end

  def record_type
    leader = parsed_xml.css("leader")
    record_type = leader.text[5]
    bibliographic_level = leader.text[6]

    case record_type
    when "r"
      "Object"
    when "k"
      "Photo"
    when "g"
      "Projected medium"
    when "i"
      "Sound recording"
    when "j"
      "Music"
    when "o"
      "Kit"
    when "p"
      "Kit"
    when "e"
      "Map"
    when "f"
      "Map"
    when "m"
      "Computer file"
    when "c"
      "Sheet music"
    when "d"
      "Sheet music"
    when "t"
      "Manuscript"
    when "a"
      if bibliographic_level == "s"
        "Periodical"
      else
        "Book"
      end
    else
      if bibliographic_level == "s"
        "Periodical"
      else
        "Book"
      end
    end
  end

  def generate_json
    unless marcxml.blank?
      self.json = {
        :record_type => record_type,
        :isbn => isbn,
        :title_main => title_main,
        :helmet_id => helmet_id,
        :library_link => "http://www.helmet.fi/record=#{helmet_id.match(/\(FI-HELMET\)(\w*)/)[1]}~S9*eng",
        :author_main => author_main,
        :author_group => parsed_xml.css("datafield[tag='110'], datafield[tag='700']").map do |data_field|
          {
            :name => data_field.css("subfield[code='a']").map(&:text).join(", "), 
            :relationship => data_field.css("subfield[code='e']").map(&:text).join(", ")
          }
        end,
        :description => parsed_xml.css("datafield[tag='300']").map do |data_field|
          data_field.css("subfield[code='a']").text
        end,
        :leader => parsed_xml.css("leader").text
      }.to_json
    end
  end

  def to_param
    helmet_id
  end

  private

  def parsed_xml
    @parsed_xml ||= Nokogiri::XML(self.marcxml)
  end
    
  def denormalize_fields
    unless marcxml.blank?
      author_fields = parsed_xml.css("datafield[tag='100'], datafield[tag='700']")
      unless author_fields.empty?
        self.author_main = author_fields.first.css("subfield[code='a']").text
      end
      title_tag = parsed_xml.css("datafield[tag='245']").first
      unless title_tag.nil?
        self.title_main = title_tag.css("subfield[code='a']").text
      end
      denormalize_isbn
      denormalize_helmet_id
    end
  end

  def denormalize_helmet_id
    self.helmet_id = parsed_xml.css("datafield[tag='035']").first.css("subfield[code='a']").text
  end

  def denormalize_isbn
    isbn_field = parsed_xml.css("datafield[tag='020']").first
    unless isbn_field.nil?
      match = isbn_field.css("subfield").children.first.text.match(/^[\d\-X]+/).try(:[], 0)
      if match
        self.isbn = match.tr("-", "")
      end
    end
  end
end
