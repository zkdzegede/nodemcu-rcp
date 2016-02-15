MLX90614_I2CADDR = 0x5A
-- RAM
MLX90614_RAWIR1 = 0x04
MLX90614_RAWIR2 = 0x05
MLX90614_TA = 0x06
MLX90614_TOBJ1 = 0x07
MLX90614_TOBJ2 = 0x08
-- EEPROM
MLX90614_TOMAX = 0x20
MLX90614_TOMIN = 0x21
MLX90614_PWMCTRL = 0x22
MLX90614_TARANGE = 0x23
MLX90614_EMISS = 0x24
MLX90614_CONFIG = 0x25
MLX90614_ADDR = 0x0E
MLX90614_ID1 = 0x3C
MLX90614_ID2 = 0x3D
MLX90614_ID3 = 0x3E
MLX90614_ID4 = 0x3F

id=0
sda=4
scl=5

function setup()
    print("setup")
    i2c.setup(id,sda,scl,i2c.SLOW)
end

function readObjectTempC()
      return readTemp(MLX90614_TOBJ1)
end

function readAmbientTempC()
       return readTemp(MLX90614_TA)
end

function readTemp(reg_addr)
     temp = read16(reg_addr)
--     temp = temp * 0.02
--     temp = temp - 273.15
     return temp
end

function readPwmCtrl2()
       return readTemp(0x02)
end

function readPwmCtrl22()
       return readTemp(0x22)
end

-- user defined function: read from reg_addr content of dev_addr
--function read_reg(dev_addr, reg_addr)
-- i2c.start(id)
-- i2c.address(id, dev_addr ,i2c.TRANSMITTER)
-- i2c.write(id,reg_addr)
-- i2c.stop(id)
-- i2c.start(id)
-- i2c.address(id, dev_addr,i2c.RECEIVER)
-- c=i2c.read(id,1)
-- i2c.stop(id)
-- return c
--end

function read16(reg_addr)
 i2c.start(id)
 setupTrans = i2c.address(id, MLX90614_I2CADDR,i2c.TRANSMITTER)
-- if (setupTrans) then
--     print("setup trans")
-- end
 byteWrote = i2c.write(id,reg_addr)
 print("byteWrote: "..byteWrote)
 i2c.stop(id)
 i2c.start(id)
 setupReceive = i2c.address(id, MLX90614_I2CADDR,i2c.RECEIVER)
 if (setupReceive) then
     print("setup receive")
 end
 c=i2c.read(id,2)
  print(string.byte(c))
-- c = bit.bor(c, bit.lshift(i2c.read(id,1), 8))
-- print(c)
 pec = i2c.read(id,1)
 print(string.byte(pec))
--  ret = Wire.read(); // receive DATA
--  ret |= Wire.read() << 8; // receive DATA
-- 
 i2c.stop(id)
 return c
end

function writePwm(reg_addr, reg_val) 
    i2c.start(id)
    i2c.address(id, MLX90614_I2CADDR,i2c.TRANSMITTER)
    byteWroteAddr = i2c.write(id,reg_addr)
    byteWroteVal = i2c.write(id,reg_val)
    print("byteWroteAddr: "..byteWroteAddr)
    print("byteWroteVal: "..byteWroteVal)
    i2c.stop(id)
end

--uint16_t Adafruit_MLX90614::read16(uint8_t a) {
--  uint16_t ret;
--
--  Wire.beginTransmission(_addr); // start transmission to device 
--  Wire.write(a); // sends register address to read from
--  Wire.endTransmission(false); // end transmission
--  
--  Wire.requestFrom(_addr, (uint8_t)3);// send data n-bytes read
--  ret = Wire.read(); // receive DATA
--  ret |= Wire.read() << 8; // receive DATA
--
--  uint8_t pec = Wire.read();
--
--  return ret;
--}

setup()
readPwmCtrl2()
readPwmCtrl22()
--writePwm(0x02, 0x23)  -- 0000 0010 0011
--reg = readAmbientTempC()
--print(string.byte(reg))