# encoding: utf-8
#
class Record < ActiveRecord::Base
  has_many :data_fields, :dependent => :destroy
  include PgSearch

  pg_search_scope :search_by_isbn, :against => :isbn, :using => {
    :tsearch => {
      :dictionary => "finnish"
    }
  }
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

  def other_name
    # FIXME
    # data_fields.where(:tag => "245").first.subfields.where(:code => "b").first.try(:value)
  end
  
  def marcxml=(new_marcxml)
    @parsed_xml = nil
    write_attribute(:marcxml, new_marcxml)
    denormalize_fields
  end

  def generate_json
    unless marcxml.blank?
      self.json = {
        :leader => parsed_xml.css("leader").text,
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
        end
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
      isbn_field = parsed_xml.css("datafield[tag='020']").first
      unless isbn_field.nil?
        self.isbn = isbn_field.css("subfield").children.first.text
      end
      self.helmet_id = parsed_xml.css("datafield[tag='035']").first.css("subfield[code='a']").text
    end
  end
end
