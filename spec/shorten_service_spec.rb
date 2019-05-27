require 'json'
require 'ostruct'
require 'minitest/spec'
require 'minitest/autorun'
require_relative '../lib/service/shorten_service'

describe ShortenService do

  SHORTEN_KEY = 'ujg92a'
  FULL_URL = 'http://google.com'

  describe "#retrieve_full_url" do
    it "returns an stored key" do
      shorten_dao = Minitest::Mock.new
      key_generator = Minitest::Mock.new
      shorten_dao.expect('retrieve_key', FULL_URL, [SHORTEN_KEY])
      assert ShortenService.new(shorten_dao, key_generator).retrieve_full_url(SHORTEN_KEY) == FULL_URL
    end

    it 'raises KeyNotFoundException when key not found' do

      shorten_dao = Minitest::Mock.new
      key_generator = Minitest::Mock.new

      shorten_dao.expect(:retrieve_key, nil) do
        raise KeyNotFoundException
      end

      assert_raises KeyNotFoundException do
        ShortenService.new(shorten_dao, key_generator).retrieve_full_url(SHORTEN_KEY)
      end
    end

    it 'success stores a key in redis' do
      shorten_dao = Minitest::Mock.new
      key_generator = Minitest::Mock.new

      shorten_dao.expect('store_key', true, [SHORTEN_KEY, FULL_URL])
      key_generator.expect('generate_short_key', SHORTEN_KEY)

      body = JSON.parse('{"url": "' + FULL_URL + '"}', object_class: OpenStruct)

      assert ShortenService.new(shorten_dao, key_generator).shorten(body).to_json == '{"status":"success","shortenedKey":"ujg92a"}'
    end

    it 'raises DuplicatedKeyException when can not generate a valid key' do
      shorten_dao = Minitest::Mock.new
      key_generator = Minitest::Mock.new

      shorten_dao.expect('store_key', false, [SHORTEN_KEY, FULL_URL])
      shorten_dao.expect('store_key', false, [SHORTEN_KEY, FULL_URL])
      shorten_dao.expect('store_key', false, [SHORTEN_KEY, FULL_URL])
      shorten_dao.expect('store_key', false, [SHORTEN_KEY, FULL_URL])
      shorten_dao.expect('store_key', false, [SHORTEN_KEY, FULL_URL])

      key_generator.expect('generate_short_key', SHORTEN_KEY)
      key_generator.expect('generate_short_key', SHORTEN_KEY)
      key_generator.expect('generate_short_key', SHORTEN_KEY)
      key_generator.expect('generate_short_key', SHORTEN_KEY)
      key_generator.expect('generate_short_key', SHORTEN_KEY)

      body = JSON.parse('{"url": "' + FULL_URL + '"}', object_class: OpenStruct)

      assert_raises DuplicatedKeyException do
        ShortenService.new(shorten_dao, key_generator).shorten(body)
      end
    end
  end
end
