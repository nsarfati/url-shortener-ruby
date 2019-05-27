require 'exception/custom_exception_handler'

class DuplicatedKeyException < CustomExceptionHandler
  def initialize(msg="Can't shorten url")
    super(msg)
  end
end
