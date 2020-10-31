class Tiers::RestrictionLookupService
  DATA = YAML.load_file("#{__dir__}/../../../data/restrictions.yml").freeze

  attr_reader :gss_codes

  def initialize(gss_codes:)
    @gss_codes = gss_codes
  end

  def restrictions
    @restrictions ||= areas.flat_map do |area|
      area['restrictions'].map do |restriction|
        Tiers::Restriction.new(
          area_name: area['name'],
          alert_level_number: restriction['alert_level'],
          start_date: restriction['start_date'],
          start_time: restriction['start_time']
        )
      end.max_by(&:starts_at)
    end
  end

  def areas
    @areas ||= DATA.slice(*gss_codes).values
  end
end
