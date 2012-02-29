class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_access_control_headers
 
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
    headers['Access-Control-Request-Method'] = '*'
  end

  private

  def records_as_json_with_itemids(records, callback = nil)
    json = (records.map {|record| "\"#{record.item_barcode}\": #{record.json}"}).join(",")
    json = wrap_page("\"records\":{#{json}}", records)
    wrap_json(json, callback)
  end

  def records_as_json(records, callback = nil)
    json = "\"records\":[#{records.map(&:json).join(",")}]"
    json = wrap_page(json, records)
    wrap_json(json, callback)
  end

  def wrap_json(json, callback = nil)
    if callback
      "#{callback}({#{json}})"
    else
      "{" + json + "}"
    end
  end

  def wrap_page(json, records = nil)
    if records and records.respond_to? :current_page
      json + ",\"current_page\":#{records.current_page},\"per_page\":#{records.per_page},\"total_entries\":#{records.total_entries}"
    else
      json
    end
  end

  def record_as_json(record, callback = nil)
    wrap_json(record.try(:json))
  end
end
