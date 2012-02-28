class Item < ActiveRecord::Base
  belongs_to :record

  def barcode=(barcode_string)
    write_attribute(:barcode, self.denormalize_barcode(barcode_string))
  end

  def denormalize_barcode(barcode_string)
    return barcode_string.gsub(/[^0-9]/, '')
  end
end
