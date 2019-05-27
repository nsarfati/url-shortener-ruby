class ShortenedResponse
  def initialize(shortened_key)
    @shortened_key = shortened_key
  end

  def to_json
    JSON.dump({"status": "success", "shortenedKey": @shortened_key})
  end
end
