
def handle_record(record, counter)
  record.generate_json
  if record.valid?
    record.save!
    if record.helmet_id.blank? || record.title_main.blank?
      print "\e[31m.\e[0m"
    elsif record.author_main.blank?
      print "\e[37m.\e[0m"
    else
      print "\e[32m.\e[0m"
    end
  else
    print "\e[33m.\e[0m"
  end
  return counter
end
