require 'minitest/spec'
require 'minitest/autorun'
require_relative '../lib/util/key_generator'

describe KeyGenerator do
  describe "#generate_short_key" do
    it "generates a key of 6 chars" do
      assert KeyGenerator.new.generate_short_key.length == 6
    end
  end
end

