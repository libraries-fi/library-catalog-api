# encoding: utf-8
#
require 'marc_features'
require 'list_features'

class Record < ActiveRecord::Base
  validates_uniqueness_of :helmet_id
  has_many                :items
  default_scope           :order => 'helmet_id DESC'
  attr_accessor           :item_barcode, :hold_count
  serialize               :importdata, Hash

  include PgSearch
  pg_search_scope :search_by_title,
  :against => :title_main, :using => :tsearch

  pg_search_scope :search_by_author,
  :against => :author_main, :using => :tsearch

  pg_search_scope :search_by_additional_authors,
  :against => :additional_authors, :using => :tsearch

  @@url_template =
    "http://haku.helmet.fi/iii/encore/record/C__R%s__Orightresult?lang=fin"
  @@id_pattern =
    /\(FI-HELMET\)(\w*)/

  def search_by_isbn(isbn)
    where(:isbn => isbn.tr("- ", ""))
  end

  def name
    title_main.sub(/ \/$/, '')
  end

  def marcxml=(new_marcxml)
    @parsed_xml = nil
    write_attribute(:marcxml, new_marcxml)
    extend MarcXMLRecordFeatures
    denormalize_fields
  end

  def importdata=(new_importeddata)
    @imported_data = nil
    write_attribute(:importdata, new_importeddata)
    extend ListedRecordFeatures
    denormalize_fields
  end

  def record_type
    case material_type
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

  def publisher
    text = get_text('260', 'b')
    if text
      text.strip.chomp(',')
    else
      nil
    end
  end

  def library_url
    @@url_template % helmet_id.match(@@id_pattern)[1]
  end

  # Generates the json version of the record.
  # This is currently called at record batch import time.
  #
  def generate_json
    if not marcxml.blank? or not importdata == nil
      self.json = {
        :type           => record_type,
        :isbn           => isbn,
        :title          => title_main,
        :library_id     => helmet_id,
        :library_url    => library_url,
        :author         => author_main,
        :publisher      => publisher,
        :year           => get_text('260', 'c'),
        :extent         => collect_text('300', 'a'),
        :description    => collect_text('500', 'a'),
        :contents       => collect_text('505', 'a'),
        :author_details => additional_authors_with_roles
      }.to_json
    end
  end

  private

  def strip_punctuation(title)
    return title.sub(/[ ]+[\/=:,]$/, '').sub(/,$/, '')
  end
end
