require 'exception/custom_exception_handler'

class InvalidRequestException < CustomExceptionHandler
  def initialize(msg="Invalid request")
    super(msg)
  end
end
