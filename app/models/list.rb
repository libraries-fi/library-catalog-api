class List
  attr_reader :identifier, :record_ids, :date, :title, :description

  def self.all
    config = Rails.configuration
    config.lists.map {|identifier,contents|
      new(identifier, contents, nil, identifier, identifier)
    }
  end

  def self.find(identifier)
    all.detect { |l| l.identifier == identifier } || raise(ActiveRecord::RecordNotFound)
  end

  def initialize(identifier, record_ids, date, title, description)
    @identifier = identifier
    @record_ids = record_ids
    @date = date
    @title = title
    @description = description
  end
end
