require 'rack'
require 'erb'
require 'pry'
require 'ostruct'

class Template < OpenStruct
  def render(template)
    template = ERB.new(File.read(template))
    template.result(binding)
  end
end

ROUTES = {
  GET: {}
}

def not_found
  [404, {}, ["<h1>GTFO</h1>"]]
end

def get(path, &block)
  ROUTES[:GET][path] = block
end

def erb(template, locals={})
  template_path = "views/#{template}.erb"
  Template.new(locals).render(template_path)
end

def respond(env)
  path = env['PATH_INFO']
  request_method = env["REQUEST_METHOD"].to_sym

  route = ROUTES[request_method][path]

  if route
    body = route.call
    [200, {}, [body]]
  else
    not_found
  end
end

get "/spencer" do
  erb :index, { derp: 'hello spencer' }
end

Rack::Handler::WEBrick.run method(:respond)
