require 'exception/invalid_request_exception'

class ValidationUtils
  def validate_shorten_request(req)
    if req.url.nil? or req.url.to_s.strip.empty?
      raise InvalidRequestException
    end
  end
end
