class Item < ActiveRecord::Base
  belongs_to :record

  def denormalize_barcode(barcode_string)
    print #todo here
  end
end
