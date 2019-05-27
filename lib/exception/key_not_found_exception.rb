require 'exception/custom_exception_handler'

class KeyNotFoundException < CustomExceptionHandler
  def initialize(msg="Key not found")
    super(msg)
  end
end
