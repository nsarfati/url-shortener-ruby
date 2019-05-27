require 'exception/invalid_request_exception'

class ValidationUtil
  def validate_shorten_request(req)
    if req.url.nil? or req.url.to_s.strip.empty?
      raise InvalidRequestException
    end
  end

  def validate_redirect_key(key)
    if key.nil? or key.strip.empty?
      raise InvalidRequestException
    end
  end
end
