class Tiers::Server < Sinatra::Base
  set :server, :puma

  before do
    content_type :json
  end

  get '/v1/restrictions' do
    begin
      gss_codes = Tiers::PostcodeLookupService.new(postcode: params['postcode']).gss_codes
    rescue Tiers::PostcodeLookupService::LookupError => e
      status :bad_request
      return { error: e }.to_json
    end
    restrictions = Tiers::RestrictionLookupService.new(gss_codes: gss_codes).restrictions

    {
      restrictions: restrictions,
      legal: {
        disclaimer: 'This data is provided without warranty and may be inaccurate. Do not depend on it for anything important.',
        data_source: 'https://github.com/alphagov/collections/blob/2e410b97c64793b853d3947998a1109585f5c3a3/test/fixtures/local-restrictions.yaml'
      }
    }.to_json
  end
end
