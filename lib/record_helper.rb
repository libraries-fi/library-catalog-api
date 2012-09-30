
def handle_record(record, counter)
  record.generate_json
  if record.valid?
    record.save!
    counter += 1
  end
  return counter
end
