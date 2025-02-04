require 'rack/response'

autoload :MultiJson, 'multi_json'

module Weary
  class Response
    include Rack::Response::Helpers
    include Rack::Request::Env

    def initialize(body, status, headers)
      @response = Rack::Response.new body, status, headers
      @status = self.status
    end

    def status
      @response.status.to_i
    end

    def header
      @response.header
    end
    alias headers header

    def body
      buffer = ""
      @response.body.each {|chunk| buffer << chunk }
      buffer
    end

    def each(&iterator)
      @response.body.each(&iterator)
    end

    def finish
      [status, header, self]
    end

    def success?
      @response.successful?
    end

    def redirected?
      @response.redirection?
    end

    def length
      @response.length
    end

    def call(env)
      self.finish
    end

    def content_type
      @response.content_type
    end

    def parse
      raise "The response does not contain a body" if body.nil? || body.empty?
      if block_given?
        yield body, content_type
      elsif content_type&.any?{|t| t =~ /json($|;.*)/ }
        MultiJson.decode body
      else
        raise "Unable to parse Content-Type: #{content_type}"
      end
    end
  end
end
