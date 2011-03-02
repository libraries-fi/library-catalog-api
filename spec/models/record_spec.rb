# encoding: utf-8
#
require "spec_helper"

describe Record do
  describe "#marcxml" do
    it "populates fields needed for searching" do
      record = Record.new(:marcxml => marcxml_fixture)
      record.isbn.should eq("6415751554957")
      record.helmet_id.should eq("cls0030986")
      record.title_main.should eq("007 ja kultainen silmä /")
      record.author_main.should eq("Campbell, Martin")
    end
  end

  describe "#generate_json" do
    it "sets json attribute" do
      record = Record.new(:marcxml => marcxml_fixture)
      record.json.should be_blank
      record.generate_json
      record.json.should eq(%q|{"leader":"01661ngm  2200457   4500","title_main":"007 ja kultainen silm\\u00e4 /","helmet_id":"cls0030986","author_main":"Campbell, Martin","author_group":["Campbell, Martin","France, Michael","Caine, Jeffrey","Feirstein, Bruce","Serra, Eric","Fleming, Ian.","Brosnan, Pierce","Bean, Sean","Scorupco, Izabella","Janssen, Famke","Turner, Tina"],"description":["1 videokasetti (125 min) :"]}|)
    end
  end
end
