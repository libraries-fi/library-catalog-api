class Item < ActiveRecord::Base
  belongs_to :record

  def barcode=(barcode_string)
    if not barcode_string.nil?
      write_attribute(:barcode, Item.normalize_barcode(barcode_string))
    end
  end

  def self.normalize_barcode(barcode_string)
    if barcode_string.nil? or not barcode_string.kind_of? String
      return nil
    end
    return barcode_string.gsub(/[^0-9]/, '')
  end
end
