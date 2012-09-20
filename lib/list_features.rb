
module ListedRecordFeatures

  def material_type
    imported_data['000 REC TYPE']
  end

  def bibliographic_level
    imported_data['000 BIB LEVEL']
  end

  def format_helmet_id
    "(FI-HELMET)" + imported_data["RECORD #(BIBLIO)"].chop
  end

  def additional_authors_with_roles
    authors  = collect_text('700', 'a').zip(collect_text('700', 'e'))
    authors += collect_text('710', 'a').zip(collect_text('710', 'e'))
    authors.reject!{|element| element[0] == nil}
    authors.map do |name, role|
      if role
        role.strip!
      end
      { :name => strip_punctuation(name),
        :role => role }
    end
  end

  def clean_isbn(isbn_field)
    if isbn_field
      match = isbn_field.first.match(/^[\d\-X]+/).try(:[], 0)
      if match
        match.tr("-", "")
      else
        nil
      end
    else
      nil
    end
  end

  def get_text(marc_tag, subfield)
    key = data_key(marc_tag, subfield)
    if imported_data.has_key?(key)
      val = imported_data[key]
      if Enumerable === val
        return val.join
      elsif val and val.empty?
        return nil
      else
        return val
      end
    else
      raise IndexError.new("Field not available: #{key}")
    end
  end

  def collect_text(marc_tag, subfield)
    key = data_key(marc_tag, subfield)
    if imported_data.has_key?(key)
      return ensure_array(imported_data[key])
    else
      raise IndexError.new("Field not available: #{key}")
    end
  end


  def denormalize_fields
    unless imported_data.blank?
      self.author_main =
        strip_punctuation((get_text('100', 'a') || get_text('110', 'a') || ""))
      self.additional_authors =
        additional_authors_with_roles.map{|val| val[:name]}.join(" ")

      unless imported_data["TITLE"].nil? or imported_data["TITLE"].empty?
        self.title_main = get_text('245', 'a') || ''
        subtitle = get_text('245', 'b') || ''
        if subtitle.nil?
          self.title_main = strip_punctuation(self.title_main)
        else
          self.title_main << ' ' << strip_punctuation(subtitle)
        end
      end

      self.helmet_id = format_helmet_id
      self.isbn = clean_isbn(imported_data["020|a"])
    end
  end

  def ensure_array(array_or_element)
    return ((Enumerable === array_or_element) ?
            array_or_element :
            [array_or_element]) unless array_or_element.nil?
    []
  end

  private

  def imported_data
    @imported_data ||= self.importdata
  end
end

def data_key(marc_tag, subfield)
  "#{marc_tag}|#{subfield}"
end

