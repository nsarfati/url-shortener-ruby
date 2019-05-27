require 'securerandom'

class KeyGenerator

  RANDOM_KEY_LENGTH = 4

  def generate_short_key
    SecureRandom.urlsafe_base64(RANDOM_KEY_LENGTH).downcase
  end
end
