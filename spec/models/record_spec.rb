# encoding: utf-8
#
require "spec_helper"

describe Record do
  describe "#marcxml" do
    it "populates fields needed for searching" do
      record = Record.new(:marcxml => marcxml_fixture)
      record.helmet_id.should eq("(FI-HELMET)b1000009")
      record.title_main.should eq("007 ja kultainen silmä /")
      record.author_main.should eq("Campbell, Martin")
      record.isbn.should be_nil
    end
  end

  describe "#generate_json" do
    it "sets json attribute" do
      record = Record.new(:marcxml => marcxml_fixture)
      record.json.should be_blank
      record.generate_json
      record.json.should eq(%q|{"leader":"01661ngm  2200457   4500","title_main":"007 ja kultainen silm\\u00e4 /","helmet_id":"(FI-HELMET)b1000009","library_link":"http://www.helmet.fi/record=b1000009~S9*eng","author_main":"Campbell, Martin","author_group":[{"name":"Campbell, Martin","relationship":"(ohj.)"},{"name":"France, Michael","relationship":"(k\\u00e4sik.)"},{"name":"Caine, Jeffrey","relationship":"(k\\u00e4sik.)"},{"name":"Feirstein, Bruce","relationship":"(k\\u00e4sik.)"},{"name":"Serra, Eric","relationship":"(s\\u00e4v.)"},{"name":"Fleming, Ian.","relationship":""},{"name":"Brosnan, Pierce","relationship":"(n\\u00e4ytt.)"},{"name":"Bean, Sean","relationship":"(n\\u00e4ytt.)"},{"name":"Scorupco, Izabella","relationship":"(n\\u00e4ytt.)"},{"name":"Janssen, Famke","relationship":"(n\\u00e4ytt.)"},{"name":"Turner, Tina","relationship":"(esitt.)"}],"description":["1 videokasetti (125 min) :"]}|)
    end
  end
end
