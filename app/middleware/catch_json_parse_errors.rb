# from: https://robots.thoughtbot.com/catching-json-parse-errors-with-custom-middleware

class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => error
      if env['HTTP_ACCEPT'] =~ /application\/json/
        messages = Hash.new
        messages[:info] = Array.new
        messages[:warning] = Array.new
        messages[:error] = Array.new
        messages[:error] << "There was a problem in the JSON you submitted: #{error}"
        return [
            400, { "Content-Type" => "application/json" },
            [ { status: 400, messages: messages }.to_json ]
        ]
      else
        raise error
      end
    end
  end
end