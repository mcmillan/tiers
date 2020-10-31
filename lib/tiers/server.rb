class Tiers::Server < Sinatra::Base
  set :server, :puma

  get '/2020-10-31/restrictions' do
    gss_codes = Tiers::PostcodeLookupService.new(postcode: params['postcode']).gss_codes
    restrictions = Tiers::RestrictionLookupService.new(gss_codes: gss_codes).restrictions

    content_type :json
    {
      restrictions: restrictions
    }.to_json
  end
end
