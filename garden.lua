garden = {
  server = {
    port = 3000,
    host = '192.168.0.6',
    url  = '/v1/plants/%d/reports'
  },
  plant_id = 1,
  frequency = 10000,
  timer = 6,
  sensors = {}
}

local POST = table.concat({
  'POST %s HTTP/1.1',
  'Content-Type: application/json',
  'Content-Length: %d',
  '',
  '%s',
  '',
  ''
}, '\r\n')

function garden.update (data)
  local body = cjson.encode(data)
  local url = string.format(garden.server.url, garden.plant_id)
  local request = string.format(POST, url, string.len(body), body)
  local conn = net.createConnection(net.TCP, 0)

  conn:on('receive', function(conn, response) print(response) end)
  conn:connect(garden.server.port, garden.server.host)
  print('Updating garden...')
  print(request)
  conn:send(request)
end

function garden.update_all ()
  for name, sensor in pairs(garden.sensors) do
    sensor.update()
  end
end

function garden.start ()
  tmr.alarm(garden.timer, garden.frequency, 1, garden.update_all)
end

function garden.stop ()
  tmr.stop(garden.timer)
end

