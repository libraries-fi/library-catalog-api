class Record < ActiveRecord::Base
  has_many :data_fields, :dependent => :destroy
  include PgSearch
  pg_search_scope :search_by_isbn, :against => :isbn
  pg_search_scope :search_by_title, :against => :title_fields
  pg_search_scope :search_by_author, :against => :author_fields

  def name
    data_fields.where(:tag => "245", :code => "a").first.value
  end

  def other_name
    data_fields.where(:tag => "245", :code => "b").first.try(:value)
  end
  
  before_save :denormalize_fields
    
  private
    
  def denormalize_fields
    self.author_fields = data_fields.where("tag = '100' OR tag = '700'").map(&:value).join(", ")
    self.isbn = data_fields.where("tag = '024' OR tag = '020'").first.try(:value)
    self.title_fields = data_fields.where("tag = '245'").map(&:value).join(", ")
    self.helmet_id = data_fields.where("tag = '001'").first.try(:value)
  end
end
