id=0
scl=2 --GPIO0
sda=1 --GPIO2

function setup()
    i2c.setup(id, sda, scl, i2c.SLOW)
end

function read_reg(dev_addr, reg_addr) -- Read MCP9808 data
  i2c.start(id)
  i2c.address(id, dev_addr ,i2c.TRANSMITTER)
  i2c.write(id,reg_addr)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, dev_addr,i2c.RECEIVER)

  data = i2c.read(id,3)
  print(data)
  print(data:len())
  data_low, data_high, pec = data:byte()
--  data_low = string.byte(i2c.read(id,1),1)
--  data_high = string.byte(i2c.read(id,1),1)
--  pec = string.byte(i2c.read(id,1),1)
  print(data_low)
  print(data_high)
  print(pec)
  i2c.stop(id)

  tempData = bit.bor(bit.lshift(bit.band(data_high, 0x007F), 8), data_low)
  print(tempData)
  
  return tempData
end


function convert(tempval) -- convert 2 byte value
  t = tonumber(string.byte(tempval,1))
  t = bit.lshift(t,8) + tonumber(string.byte(tempval,2))
  temp = bit.band(t, 0x0FFF) / 16
   if t > 127 then t = t - 255 end
  return temp
end 

function print_temp(c) 
  print("Raw:"..c)
  h,l = string.byte(c,1,2)
  print("H:"..h)
  print("L:"..l)
  if h > 127 then h = h - 255 end        
  if l > 127 then l = 5 else l = 0 end   
  temp=string.format("%d.%d", h,l)
  print(temp)
end

function lets_go(dev, reg)
    setup()
    --print("Temp=",convert(read_reg(0x18, 0x05)))
    print_temp(read_reg(dev, reg))
end