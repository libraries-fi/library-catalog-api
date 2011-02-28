class Record < ActiveRecord::Base
  has_many :data_fields, :dependent => :destroy
  include PgSearch
  pg_search_scope :search_by_isbn, :against => :isbn
  pg_search_scope :search_by_title, :against => :title_main
  pg_search_scope :search_by_author, :against => :author_main
  
  validates_uniqueness_of :helmet_id

  def name
    data_fields.where(:tag => "245").first.subfields.where(:code => "a").first.try(:value)
  end

  def other_name
    data_fields.where(:tag => "245").first.subfields.where(:code => "b").first.try(:value)
  end
  
  before_save :denormalize_fields
    
  private
    
  def denormalize_fields
    self.author_main = data_fields.where("tag = '100' OR tag = '700'").first.subfields.where("code = 'a'").first.value if data_fields.where("tag = '100' OR tag = '700'").any?
    self.title_main = data_fields.where("tag = '245'").first.subfields.where(:code => "a").first.value if data_fields.where("tag = '245'").any?
    self.isbn = data_fields.where("tag = '024' OR tag = '020'").first.subfields.first.try(:value) if data_fields.where("tag = '024' OR tag = '020'").any?
    self.helmet_id = data_fields.where("tag = '001'").first.try(:value)
  end
end
