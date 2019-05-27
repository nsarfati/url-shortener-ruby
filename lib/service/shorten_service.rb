require 'securerandom'
require 'config/app_config'
require 'dao/shorten_dao'
require 'exception/duplicated_key_exception'

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
  end
end