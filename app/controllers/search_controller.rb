class SearchController < ApplicationController
  
  def isbn
    search("isbn")
  end
  
  def author
    search("author")
  end
  
  def title
    search("title")
  end
  
  def search(string)
    @search_query = params[:query]
    if string == "isbn"
      @records = Record.search_by_isbn(@search_query).paginate(:page => params[:page], :per_page => 5)
    elsif string == "author"
      @records = Record.search_by_author(@search_query).paginate(:page => params[:page], :per_page => 5)
    elsif string == "title"
      @records = Record.search_by_title(@search_query).paginate(:page => params[:page], :per_page => 5)
    end

    respond_to do |format|  
      format.json {  
        render :json => {  
          :current_page => @records.current_page,
          :per_page => @records.per_page,
          :total_entries => @records.total_entries,
          :entries => @records.map do |record|
            {
              :leader => record.data_fields.where(:field_type => "leader").first.value,
              :title_main => record.title_main,
              :helmet_id => record.helmet_id,
              :author_main => record.author_main,
              :author_group => record.data_fields.where(:tag => "110").map do |data_field|
                data_field.subfields.where(:code => "a").map(&:value).join(", ")
              end,
              :author => record.data_fields.where(:tag => "700").map do |data_field|
                data_field.subfields.where("code = 'a' OR code = 'e'").map(&:value)
              end,
              :description => record.data_fields.where(:tag => "300").map do |data_field|
                data_field.subfields.where("code = 'a'").first.value
              end,
              # :leader => record.data_fields.where("field_type = 'leader'").first.value,
              # :controlfields => record.data_fields.where("field_type = 'controlfield'").map do |controlfield|
              #   {
              #     :tag => controlfield.tag,
              #     :value => controlfield.value,
              #   }
              # end,
              # :datafields => record.data_fields.where("field_type = 'datafield'").map do |data_field|
              #   {
              #     :tag => data_field.tag,                
              #     :ind1 => data_field.ind1,
              #     :ind2 => data_field.ind2,
              #     :subfields => data_field.subfields.map do |sub_field|
              #       {
              #         :code => sub_field.code,
              #         :value => sub_field.value,
              #       }
              #     end,
              #   }
              # end,
            }
          end
        }
      }
      format.marcxml {
        render :template => "search/index"
      }
    end
  end
end
