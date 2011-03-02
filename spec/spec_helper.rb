# encoding: utf-8
#
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def marcxml_fixture
<<-END
<record>
  <leader>01661ngm  2200457   4500</leader>
  <controlfield tag="001">cls0030986</controlfield>
  <controlfield tag="008">960829s1996    xx                ||fin  </controlfield>
  <datafield tag="024" ind1="3" ind2=" ">
   <subfield code="a">6415751554957</subfield>
  </datafield>
  <datafield tag="028" ind1="4" ind2="1">
   <subfield code="b">Warner</subfield>
   <subfield code="a">WHV55495, 55495</subfield>
  </datafield>
  <datafield tag="035" ind1=" " ind2=" ">
   <subfield code="a">(FI-HELMET)b1000009</subfield>
  </datafield>
  <datafield tag="041" ind1="1" ind2=" ">
   <subfield code="a">fineng</subfield>
   <subfield code="h">(eng)</subfield>
  </datafield>
  <datafield tag="245" ind1="1" ind2="0">
   <subfield code="a">007 ja kultainen silmä /</subfield>
   <subfield code="c">directed by Martin Campbell ; story by Michael France ; director of photography Phil Meheux ; music by Eric Serra ; screenplay Jeffrey Caine and Bruce Feirsten</subfield>
  </datafield>
  <datafield tag="260" ind1=" " ind2=" ">
   <subfield code="a">[Helsinki] :</subfield>
   <subfield code="b">Warner Home Video,</subfield>
   <subfield code="c">[1996]</subfield>
  </datafield>
  <datafield tag="300" ind1=" " ind2=" ">
   <subfield code="a">1 videokasetti (125 min) :</subfield>
   <subfield code="b">vär.</subfield>
  </datafield>
  <datafield tag="440" ind1=" " ind2="0">
   <subfield code="a">James Bond 007</subfield>
  </datafield>
  <datafield tag="500" ind1=" " ind2=" ">
   <subfield code="a">Perustuu Ian Flemingin luomaan hahmoon.</subfield>
  </datafield>
  <datafield tag="505" ind1="0" ind2=" ">
   <subfield code="a">Mukana myös Tina Turnerin musiikkivideo elokuvan tunnuskappaleesta</subfield>
  </datafield>
  <datafield tag="506" ind1=" " ind2=" ">
   <subfield code="a">K15, T-99541. - Lainausoikeus</subfield>
  </datafield>
  <datafield tag="511" ind1="0" ind2=" ">
   <subfield code="a">Rooleissa: Pierce Brosnan, Sean Bean, Izabella Scorupco, Famke Janssen</subfield>
  </datafield>
  <datafield tag="534" ind1=" " ind2=" ">
   <subfield code="c">Danjaq S.A. ja United Artists, cop. 1995</subfield>
  </datafield>
  <datafield tag="546" ind1=" " ind2=" ">
   <subfield code="a">Tekstitys: suomi, ääniraita: englanti</subfield>
  </datafield>
  <datafield tag="574" ind1=" " ind2=" ">
   <subfield code="a">kipa, ei enää saatavilla</subfield>
  </datafield>
  <datafield tag="588" ind1=" " ind2=" ">
   <subfield code="a">1.4</subfield>
  </datafield>
  <datafield tag="599" ind1=" " ind2=" ">
   <subfield code="a">VIDEO</subfield>
  </datafield>
  <datafield tag="600" ind1="1" ind2="4">
   <subfield code="a">Bond, James</subfield>
  </datafield>
  <datafield tag="650" ind1=" " ind2="4">
   <subfield code="a">jännityselokuvat</subfield>
  </datafield>
  <datafield tag="650" ind1=" " ind2="4">
   <subfield code="a">elokuvat</subfield>
  </datafield>
  <datafield tag="650" ind1=" " ind2="4">
   <subfield code="a">1990-luku</subfield>
  </datafield>
  <datafield tag="651" ind1=" " ind2="4">
   <subfield code="a">Iso-Britannia</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Campbell, Martin</subfield>
   <subfield code="e">(ohj.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">France, Michael</subfield>
   <subfield code="e">(käsik.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Caine, Jeffrey</subfield>
   <subfield code="e">(käsik.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Feirstein, Bruce</subfield>
   <subfield code="e">(käsik.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Serra, Eric</subfield>
   <subfield code="e">(säv.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Fleming, Ian.</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Brosnan, Pierce</subfield>
   <subfield code="e">(näytt.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Bean, Sean</subfield>
   <subfield code="e">(näytt.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Scorupco, Izabella</subfield>
   <subfield code="e">(näytt.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Janssen, Famke</subfield>
   <subfield code="e">(näytt.)</subfield>
  </datafield>
  <datafield tag="700" ind1="1" ind2=" ">
   <subfield code="a">Turner, Tina</subfield>
   <subfield code="e">(esitt.)</subfield>
  </datafield>
  <datafield tag="740" ind1="0" ind2=" ">
   <subfield code="a">Kultainen silmä</subfield>
  </datafield>
  <datafield tag="765" ind1="0" ind2=" ">
   <subfield code="t">Goldeneye</subfield>
  </datafield>
</record>
END
end
