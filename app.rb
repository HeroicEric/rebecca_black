require 'rack'
require 'erb'
require 'pry'

def routes
  {
    '/' => Proc.new do
      derp =  'hello'
      template = ERB.new(File.read('views/index.erb'))
      html = template.result(binding)

      [200, {}, [html]]
    end
  }
end

def find_route(path)
  routes[path]
end

def respond(env)
  path = env['PATH_INFO']

  route = find_route(path)
  route ? route.call : [404, {}, ["<h1>GTFO</h1>"]]
end

Rack::Handler::WEBrick.run method(:respond)
