require 'httparty'

class MapItClient
  include Singleton

  def lookup_postcode(postcode:)
    HTTParty.get(
      url(path: "/postcode/#{URI.encode_www_form_component(postcode)}")
    ).parsed_response
  end

  private

  def url(path:)
    "https://mapit.mysociety.org#{path}?api_key=#{api_key}"
  end

  def api_key
    @api_key ||= ENV.fetch('MAP_IT_API_KEY')
  end
end
