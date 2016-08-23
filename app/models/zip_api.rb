require 'soda'

class ZipAPI
  PROPERTY_SALES = "w8m7-eib7"

  def initialize
    @client = SODA::Client.new({:domain => "data.detroitmi.gov", :app_token => ENV["socrata_app"]})
  end

  def dollar_sales(zip)
    @client.get(PROPERTY_SALES, {
      "$select" => "count(lsprice) AS dollar_homes",
      "$where" => "lsprice = 1.00 AND propzip = '#{zip}'"
     }
    )
  end
end
