class Tiers::Restriction
  attr_reader :area_name

  def initialize(area_name:, alert_level_number:, start_date:, start_time:)
    @area_name = area_name
    @alert_level_number = alert_level_number
    @start_date = start_date
    @start_time = start_time
  end

  def starts_at
    @starts_at ||= DateTime.parse("#{start_date} #{start_time}")
  end

  def ends_at
    nil
  end

  def alert_level_name
    case alert_level_number
    when 2
      :high
    when 3
      :very_high
    else
      :medium
    end
  end

  def guidance_url
    case alert_level_name
    when :high
      'https://www.gov.uk/guidance/local-covid-alert-level-high'
    when :very_high
      'https://www.gov.uk/guidance/local-covid-alert-level-very-high'
    else
      'https://www.gov.uk/guidance/local-covid-alert-level-medium'
    end
  end

  def to_json(*args)
    {
      area_name: area_name,
      alert_level: alert_level_number,
      alert_level_name: alert_level_name,
      starts_at: starts_at,
      ends_at: ends_at,
      guidance_url: guidance_url
    }.to_json(*args)
  end

  private

  attr_reader :alert_level_number, :start_date, :start_time
end
