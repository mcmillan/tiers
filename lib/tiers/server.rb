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
      restrictions: restrictions
    }.to_json
  end
end
