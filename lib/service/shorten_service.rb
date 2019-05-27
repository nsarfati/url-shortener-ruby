require 'config/app_config'
require 'dao/shorten_dao'
require 'util/key_generator'
require 'response/shortened_response'
require 'exception/duplicated_key_exception'
require 'exception/key_not_found_exception'

class ShortenService

  MAX_RETRY_TIMES = 5

  def initialize(shorten_dao = ShortenDao.new(AppConfig.new.get_config), key_generator = KeyGenerator.new)
    @shorten_dao = shorten_dao
    @key_generator = key_generator
  end

  def shorten(request)
    status = false
    count = 0

    while not status and count < MAX_RETRY_TIMES do
      random_key = @key_generator.generate_short_key
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