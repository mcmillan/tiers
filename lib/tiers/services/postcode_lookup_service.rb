class Tiers::PostcodeLookupService
  LookupError = Class.new(StandardError)

  attr_reader :postcode

  def initialize(postcode:)
    @postcode = postcode
  end

  def gss_codes
    @gss_codes ||= map_it_response['areas'].filter_map { |_, area| area.dig('codes', 'gss') }
  end

  private

  def map_it_response
    @map_it_response = HTTParty.get(
      map_it_url(path: "/postcode/#{URI.encode_www_form_component(postcode)}"),
      headers: {
        'User-Agent': 'Tiers (https://github.com/mcmillan/tiers)'
      }
    ).tap do |response|
      next if response.code == 200

      message = response.parsed_response['error'] || "#{response.code} error"

      raise LookupError, message
    end.parsed_response
  end

  def map_it_url(path:)
    "https://mapit.mysociety.org#{path}?api_key=#{map_it_api_key}"
  end

  def map_it_api_key
    @api_key ||= ENV.fetch('MAP_IT_API_KEY')
  end
end
