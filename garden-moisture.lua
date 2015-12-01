local moisture = {}

function moisture.update ()
  local data = adc.read(0) / 1024
  garden.update({name='moisture', value=data})
end

garden.sensors.moisture = moisture

