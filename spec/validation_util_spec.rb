require 'json'
require 'ostruct'
require 'minitest/spec'
require 'minitest/autorun'
require_relative '../lib/util/validation_util'

describe ValidationUtil do
  describe "#validate_shorten_request" do
    it "raise InvalidRequestException when url json key is nil" do
      body = JSON.parse(JSON.dump({"urll": "fff"}), object_class: OpenStruct)

      assert_raises InvalidRequestException do
        ValidationUtil.new.validate_shorten_request(body)
      end
    end

    it "raise InvalidRequestException when url json key is empty" do
      body = JSON.parse(JSON.dump({"url": ""}), object_class: OpenStruct)

      assert_raises InvalidRequestException do
        ValidationUtil.new.validate_shorten_request(body)
      end
    end

    it "doesn't fail when request is ok" do
      body = JSON.parse(JSON.dump({"url": "ok"}), object_class: OpenStruct)

      assert ValidationUtil.new.validate_shorten_request(body) == nil
    end

  end
end

