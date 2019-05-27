require "json"
require 'logger'
require "ostruct"
require "sinatra/base"
require "util/validation_utils"
require "service/shorten_service"
require "example"

class Application < Sinatra::Base

  LOGGER = Logger.new(STDOUT)

  def initialize(app = nil, shorten_service = ShortenService.new,
                 validation_utils = ValidationUtils.new)
    super(app)
    @shorten_service = shorten_service
    @validation_utils = validation_utils
  end

  set :views, File.join(settings.root, "/views")

  get "/" do
    erb :index, locals: {
        message: Example.new.message
    }
  end

  post "/" do
    begin
      parsed_body = JSON.parse(request.body.read, object_class: OpenStruct)
      @validation_utils.validate_shorten_request parsed_body
      @shorten_service.shorten parsed_body
    rescue InvalidRequestException => e
      LOGGER.info("InvalidRequestException error produced :: errorMessage[#{$!}] stackTrace[#{$@}]")
      halt 400, e.to_json
    rescue DuplicatedKeyException => e
      LOGGER.error("DuplicatedKeyException error produced :: errorMessage[#{$!}] stackTrace[#{$@}]")
      halt 500, e.to_json
    rescue => e
      LOGGER.error("Generic error produced :: errorMessage[#{$!}] stackTrace[#{$@}]")
      halt 500, JSON.dump({"error": "Internal error"})
    end
  end
end

