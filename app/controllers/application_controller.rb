class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def records_as_json(records, jsonp = nil)
    json = "\"records\":[#{records.map(&:json).join(",")}]"
    if records.respond_to? :current_page
      json = json + ",\"current_page\":#{records.current_page},\"per_page\":#{records.per_page},\"total_entries\":#{records.total_entries}"
    end

    if jsonp
      "#{jsonp}({#{json.to_json}})"
    else
      "{" + json + "}"
    end
  end

  def record_as_json(record, jsonp = nil)
    if jsonp
      "#{jsonp}(#{record.json})"
    else
      record.json
    end
  end
end
