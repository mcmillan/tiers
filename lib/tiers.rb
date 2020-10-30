require 'sinatra'

require_relative 'map_it_client'

class Tiers < Sinatra::Base
  get '/' do
    MapItClient.instance.lookup_postcode(postcode: 'M4 6WX').to_json
  end
end
