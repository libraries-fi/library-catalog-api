class ListsController < ApplicationController
  def show
    record_list = List.find(params[:id])
    ids = record_list.record_ids
    records = Record.where(:helmet_id => ids).all
    respond_with_records(records)
  end
end
