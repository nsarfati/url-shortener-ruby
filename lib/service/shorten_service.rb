require 'securerandom'
require 'config/app_config'
require 'dao/shorten_dao'
require 'response/shortened_response'
require 'exception/duplicated_key_exception'
require 'exception/key_not_found_exception'

class ShortenService

  RANDOM_KEY_LENGTH = 5
  MAX_RETRY_TIMES = 5

  def initialize(shorten_dao = ShortenDao.new(AppConfig.parsed_body))
    @shorten_dao = shorten_dao
  end

  def shorten(request)
    status = false
    count = 0

    while not status and count < MAX_RETRY_TIMES do
      random_key = SecureRandom.urlsafe_base64(RANDOM_KEY_LENGTH).downcase
      status = @shorten_dao.store_key(random_key, request.url)
      count += 1
    end

    if not status
      raise DuplicatedKeyException
    end

    ShortenedResponse.new(random_key)
  end

  def retrieve_full_url(key)
    full_url = @shorten_dao.retrieve_key(key)

    if full_url.nil?
      raise KeyNotFoundException
    end

    full_url
  end
end