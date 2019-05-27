class CustomExceptionHandler < StandardError
  def initialize(msg)
    super(msg)
    @msg = msg
  end

  def to_json
    JSON.dump({"status": "failure", "error": @msg})
  end
end

