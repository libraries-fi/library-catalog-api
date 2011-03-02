# encoding: utf-8
#
class Record < ActiveRecord::Base
  has_many :data_fields, :dependent => :destroy
  include PgSearch
  pg_search_scope :search_by_isbn, :against => :isbn
  pg_search_scope :search_by_title, :against => :title_main
  pg_search_scope :search_by_author, :against => :author_main
  
  validates_uniqueness_of :helmet_id

  def name
    title_main
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
        :author_main => author_main,
        :author_group => parsed_xml.css("datafield[tag='110'], datafield[tag='700']").map do |data_field|
          data_field.css("subfield[code='a']").map(&:text).join(", ")
        end,
        :description => parsed_xml.css("datafield[tag='300']").map do |data_field|
          data_field.css("subfield[code='a']").text
        end
      }.to_json
    end
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
      self.title_main = parsed_xml.css("datafield[tag='245']").first.css("subfield[code='a']").text
      isbn_fields = parsed_xml.css("datafield[tag='024'], datafield[tag='020']")
      unless isbn_fields.empty?
        self.isbn = isbn_fields.first.css("subfield").children.first.text
      end
      self.helmet_id = parsed_xml.css("controlfield[tag='001']").first.text
    end
  end
end
