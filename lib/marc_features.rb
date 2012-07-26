
module MarcXMLRecordFeatures

  def material_type
    marc_leader(6)
  end

  def bibliographic_level
    marc_leader(7)
  end

  def additional_authors_with_roles
    parsed_xml.css("datafield[tag='700'], datafield[tag='710']").map do |data_field|
      role = data_field.css("subfield[code='e']").map(&:text).join(", ").strip
      role = nil if role.empty?
      {
        :name => data_field.css("subfield[code='a']").map(&:text).join(", "),
        :role => role
          }
    end
  end

  def get_text(marc_tag, subfield)
    parsed_xml.css("datafield[tag='#{marc_tag}']")
      .css("subfield[code='#{subfield}']").text
  end

  def collect_text(marc_tag, subfield)
    parsed_xml.css("datafield[tag='#{marc_tag}']").map do |data_field|
      data_field.css("subfield[code='#{subfield}']").text
    end
  end

  def denormalize_fields
    unless marcxml.blank?

      author_fields = parsed_xml.css("datafield[tag='100'], datafield[tag='110']")
      unless author_fields.empty?
        self.author_main = author_fields.first.css("subfield[code='a']").text
      end

      authors = ''
      parsed_xml.css("datafield[tag='700'], datafield[tag='710']").map do |data_field|
        authors << ' ' << data_field.css("subfield[code='a']").text.strip
      end
      self.additional_authors = authors

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

  private
  def marc_leader(character)
    @parsed_xml.css("leader").text[character]
  end

  def parsed_xml
    @parsed_xml ||= Nokogiri::XML(self.marcxml)
  end

end
