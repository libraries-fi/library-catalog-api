class MarcxmlParser < Nokogiri::XML::SAX::Document
  def start_document
    p "Started parsing..."
  end

  def end_document
    p "Ended parsing."
  end
 
  def start_element(name, attributes = [])
    if name == "record"
      @title = Title.create!
    elsif name == "leader"
      @current_field = @title.data_fields.build(:tag => "leader")

    elsif ["datafield", "leader", "controlfield"].include? name
      @current_field = @title.data_fields.build(
        :tag => find_value(attributes, "tag"),
        :ind1 => find_value(attributes, "ind1"),
        :ind2 => find_value(attributes, "ind2"),
      )
    elsif name == "subfield"
      @current_field = @current_field.clone
      @current_field.code = find_value(attributes, "code")
    end
  end

  def characters(string)
    if @current_field.is_a?(DataField)
      @current_field.value = string
    end
  end

  def end_element(name)
    if name == "record"
      @title = nil
    elsif ["datafield", "leader", "controlfield"].include? name
      @current_field.save!
      @current_field = nil
    elsif name == "subfield"
      @current_field.save!
    end
  end

  def find_value(attrs, key)
    attrs.find {|attr| attr.first == key }.try(:last)
  end
end
