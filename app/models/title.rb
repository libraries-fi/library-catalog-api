class Title < ActiveRecord::Base
  has_many :data_fields, :dependent => :destroy

  def name
    data_fields.where(:tag => "245", :code => "a").first.value
  end

  def other_name
    data_fields.where(:tag => "245", :code => "b").first.try(:value)
  end
end
