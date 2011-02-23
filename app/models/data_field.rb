class DataField < ActiveRecord::Base
  belongs_to :record
  has_many :subfields
end
