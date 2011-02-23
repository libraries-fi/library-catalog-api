xml.instruct!
xml.collection do
  @records.each do |record|
    xml.record do
      record.data_fields.group_by(&:tag).each do |tag, data_fields|
        if data_fields.first.field_type == "leader"
          xml.leader data_fields.first.value
        elsif data_fields.first.field_type == "controlfield"
          xml.controlfield :tag => data_fields.first.tag do
            xml.text! data_fields.first.value
          end
        elsif data_fields.first.field_type == "datafield"
          xml.datafield :tag => data_fields.first.tag, :ind1 => data_fields.first.ind1, :ind2 => data_fields.first.ind2 do
            data_fields.first.subfields.each do |subfield|
              xml.subfield :code => subfield.code do
                xml.text! subfield.value.to_s
              end
            end
          end
        end
      end
    end
  end
end