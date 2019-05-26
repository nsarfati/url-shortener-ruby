require "sinatra/base"
require "example"

class Application < Sinatra::Base
  set :views, File.join(settings.root, "/views")

  get "/" do
    erb :index, locals: {
        message: Example.new.message
    }
  end
end

