# This file is part of Library Catalog API
# Copyright (C) 2011,2012  Kisko Labs Oy
#
# Library Catalog API is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class MarcxmlParser < Nokogiri::XML::SAX::Document
  def start_document
    p "Started parsing..."
  end

  def end_document
    p "Ended parsing."
  end
 
  def start_element(name, attributes = [])
    if name == "record"
      @record = Record.create!
    elsif name == "leader"
      @current_field = @record.data_fields.build(:field_type => "leader")

    elsif ["datafield", "leader", "controlfield"].include? name
      @current_field = @record.data_fields.build(
        :field_type => name,
        :tag => find_value(attributes, "tag"),
        :ind1 => find_value(attributes, "ind1"),
        :ind2 => find_value(attributes, "ind2")
      )
      @current_field.save!
    elsif name == "subfield"
      @current_subfield = @current_field.subfields.build(
        :code => find_value(attributes, "code")
      )
    end
  end

  def characters(string)
    if @current_field.is_a?(DataField)
      unless string.blank?
        @current_field.value = string
      end
    end
    if @current_subfield.is_a?(Subfield)
      unless string.blank?
        @current_subfield.value = string
      end
    end
  end

  def end_element(name)
    if name == "record"
      @record = nil
    elsif ["datafield", "leader", "controlfield"].include? name
      @current_field.save!
      @current_field = nil
      @record.save!
    elsif name == "subfield"
      @current_subfield.save!
      @current_subfield = nil
    end
  end

  def find_value(attrs, wanted_key)
    attrs.find {|key, value| key == wanted_key }.try(:last)
  end
end
