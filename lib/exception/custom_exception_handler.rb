class CustomExceptionHandler < StandardError
  def initialize(msg)
    super(msg)
    @msg = msg
  end

  def to_json
    JSON.dump({"error": @msg})
  end
end

