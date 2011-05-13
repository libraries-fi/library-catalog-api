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
    record_type = leader.text[6]
    bibliographic_level = leader.text[7]

    case record_type
    when "r"
      "object"
    when "k"
      "photo"
    when "g"
      "film"
    when "i"
      "sound recording"
    when "j"
      "music recording"
    when "o"
      "kit"
    when "p"
      "kit"
    when "e"
      "map"
    when "f"
      "map"
    when "m"
      "computer file"
    when "c"
      "sheet music"
    when "d"
      "sheet music"
    when "t"
      "manuscript"
    when "a"
      if bibliographic_level == "s"
        "periodical"
      else
        "book"
      end
    else
      if bibliographic_level == "s"
        "periodical"
      else
        "book"
      end
    end
  end

  def generate_json
    unless marcxml.blank?
      self.json = {
        :type => record_type,
        :isbn => isbn,
        :title => title_main,
        :library_id => helmet_id,
        :library_link => "http://www.helmet.fi/record=#{helmet_id.match(/\(FI-HELMET\)(\w*)/)[1]}~S9*eng",
        :author => author_main,
        :author_details => parsed_xml.css("datafield[tag='700'], datafield[tag='710']").map do |data_field|
          {
            :name => data_field.css("subfield[code='a']").map(&:text).join(", "), 
            :role => data_field.css("subfield[code='e']").map(&:text).join(", ")
          }
        end,
        :extent => parsed_xml.css("datafield[tag='300']").map do |data_field|
          data_field.css("subfield[code='a']").text
        end,
        :description => parsed_xml.css("datafield[tag='500']").map do |data_field|
          data_field.css("subfield[code='a']").text
        end,
        :contents => parsed_xml.css("datafield[tag='505']").map do |data_field|
          data_field.css("subfield[code='a']").text
        end,
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
      author_fields = parsed_xml.css("datafield[tag='100'], datafield[tag='110']")
      unless author_fields.empty?
        self.author_main = author_fields.first.css("subfield[code='a']").text
      end
      title_tag = parsed_xml.css("datafield[tag='245']").first
      unless title_tag.nil?
        self.title_main = title_tag.css("subfield[code='a']").text
        subtitle_tag = title_tag.css("subfield[code='b']").first
        if subtitle_tag.nil?
          self.title_main = strip_punctuation(self.title_main)
        else
          self.title_main << ' ' << strip_punctuation(subtitle_tag.text)
        end
      end
      denormalize_isbn
      denormalize_helmet_id
    end
  end

  def strip_punctuation(title)
    return title.sub(/[ ]+[\/=:]$/, '')
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
