class Record < ActiveRecord::Base
  has_many :data_fields, :dependent => :destroy
  include PgSearch
  pg_search_scope :search_by_isbn, :against => :isbn
  pg_search_scope :search_by_title, :against => :title_main
  pg_search_scope :search_by_author, :against => :author_main

  def name
    data_fields.where(:tag => "245", :code => "a").first.value
  end

  def other_name
    data_fields.where(:tag => "245", :code => "b").first.try(:value)
  end
  
  before_save :denormalize_fields
    
  private
    
  def denormalize_fields
    author_main = ""
    data_fields.where("tag = '100' OR tag = '700'").each do |data_field|
      author_main += data_field.subfields.where("code = 'a'").first.try(:value)
    end
    title_main = ""
    data_fields.where("tag = '245'").each do |data_field|
      title_main += data_field.subfields.where("code = 'a'").first.try(:value)
    end
    self.author_main = author_main
    self.title_main = title_main
    # self.isbn = data_fields.where("tag = '024' OR tag = '020'").first.subfields.first.try(:value)
    self.helmet_id = data_fields.where("tag = '001'").first.try(:value)
  end
end
