require 'json'
require 'logger'
require 'ostruct'
require 'sinatra/base'
require 'util/validation_utils'
require 'service/shorten_service'

class Application < Sinatra::Base

  LOGGER = Logger.new(STDOUT)

  def initialize(app = nil, shorten_service = ShortenService.new,
                 validation_utils = ValidationUtils.new)
    super(app)
    @shorten_service = shorten_service
    @validation_utils = validation_utils
  end

  get "/:key" do
    begin
      redirect_to = @shorten_service.retrieve_full_url params[:key]
    rescue KeyNotFoundException => e
      LOGGER.error("KeyNotFoundException error produced :: errorMessage[#{$!}] stackTrace[#{$@}]")
      redirect_to = "https://properati.com/"
    rescue => e
      LOGGER.error("Generic error produced :: errorMessage[#{$!}] stackTrace[#{$@}]")
      redirect_to = "https://properati.com/"
    end

    redirect to(redirect_to), 301
  end

  post "/" do
    begin
      parsed_body = JSON.parse(request.body.read, object_class: OpenStruct)
      @validation_utils.validate_shorten_request parsed_body
      response = @shorten_service.shorten parsed_body
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

    response.to_json
  end
end

