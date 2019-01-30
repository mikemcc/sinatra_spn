require 'sinatra'

set :bind, '0.0.0.0'
get '/' do
  """
  <html>
  <head>
  <title>Sinatra Test App</title>
  </head>
  <body>
  <p1>Hello World from Sinatra.</p1>
  <p2>Updated, 2019-01-30, 2:20 PM</p2>
  <p2>Updated, 2019-01-22, 9:20 PM</p2>
  <p2>Updated, 2019-01-22, 8:22 PM</p2>
  <p2>Updated, 2019-01-22, 12:22 AM</p2>
  </body>
  </html>
  """
end

