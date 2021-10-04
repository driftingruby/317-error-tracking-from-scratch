require 'net/http'
class CaptureExceptions
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue StandardError => e
      @exception = e
      capture_exceptions(env)
      raise e
    end
  end

  private

  def capture_exceptions(env)
    uri = URI('http://localhost:3001/record_exceptions')
    Net::HTTP.post_form(uri,
      message: @exception.message,
      backtrace: @exception.backtrace[0..5].join("\n"),
      source_location: source_location,
      method: env['REQUEST_METHOD'],
      uri: env['REQUEST_URL']
    )
  end

  def source_location
    lines[start_line..end_line].join
  end

  def source
    @exception.backtrace.first.split(':')
  end

  def file_location
    source[0]
  end

  def start_line
    [source[1].to_i - 5, 0].max
  end

  def end_line
    source[1].to_i + 5
  end

  def lines
    File.readlines(file_location)
  end

end