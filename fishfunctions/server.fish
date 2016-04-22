function server
	set -q PORT; or set -l PORT 8000
  open "http://localhost:$PORT"
  python -c "import SimpleHTTPServer; m = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map; m[''] = 'text/plain'; m.update(dict([(k, v + ';charset=UTF-8') for k, v in m.items()])); SimpleHTTPServer.test();"
end
