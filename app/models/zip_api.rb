require 'soda'

class ZipAPI
  include HTTParty

  PROPERTY_SALES = "w8m7-eib7"
  BUSINESS_LICENSES = "v4da-ysyn"
  FUTURE_DEMOLITIONS = "tsqq-qtet"
  PAST_DEMOLITIONS = "rv44-e9di"
  BLIGHT = "teu6-anhh"
  EMERGENCY = "hxss-88i6"

  attr_reader :zip

  def initialize(zip)
    @zip = zip
    @client = SODA::Client.new({:domain => "data.detroitmi.gov", :app_token => ENV["socrata_app"]})
    # @zomato = Zomato::Base.new('d1c4dda1a7aedc0335d08907352bef89')
  end

  def dollar_sales
    @dol_sales ||= @client.get(PROPERTY_SALES, {
      "$select" => "count(lsprice) AS dollar_homes",
      "$where" => "lsprice = 1.00 AND propzip = '#{@zip}'"
     }
    ).first["dollar_homes"].to_i
  end

  def avg_sale_price
    @avg_price ||= @client.get(PROPERTY_SALES, {
      "$select" => "avg(lsprice) AS avg_price",
      "$where" => "lsprice IS NOT NULL AND propzip = '#{@zip}'"
     }
    ).first["avg_price"].to_i
  end

  def business_licenses
    @bus_licns ||= @client.get(BUSINESS_LICENSES, {
      "$select" => "count(*) AS num_licenses",
      "$where" => "business_city_state_zip = 'Detroit, MI #{@zip}'"
     }
    ).first["num_licenses"].to_i
  end

  def demos
    @demolitions ||= @client.get(PAST_DEMOLITIONS, {
      "$select" => "count(*) AS num_demos, avg(price) AS avg_price",
      "$where" => "demolition_date > '01/01/2016'"
     }
    )
  end

  def future_demos
    @fu_demolitions ||= @client.get(FUTURE_DEMOLITIONS, {
      "$select" => "count(*) AS num_demos, avg(price) AS avg_price"
     }
    )
  end

  def next_demo
    @next_one ||= @client.get(FUTURE_DEMOLITIONS, {
      "$select" => "address, demolish_by_date, location",
      "$limit" => "1",
      "$order" => "demolish_by_date DESC"
     }
    ).first
  end

  def blight
    @blight_cases ||= @client.get(BLIGHT, {
      "$select" => "count(*) AS blight",
      "$where" => "mailingzipcode = '#{@zip}'"
     }
    ).first["blight"].to_i
  end

  def emergency_calls
    @calls ||= @client.get(EMERGENCY, {
      "$select" => "category, count(*) AS incidents",
      "$group" => "category",
      "$order" => "incidents DESC",
      "$limit" => "10"
     }
    )
  end

  def restaurants
    response = HTTParty.get('https://developers.zomato.com/api/v2.1/location_details?entity_id=285&entity_type=city')
  end
end
