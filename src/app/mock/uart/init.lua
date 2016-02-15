--9600
--115200

uart.setup(0, 9600, 8, 0, 1, 0)

uart.on("data", "AT", 
  function(data)
     print("receive uart ["..data.."]\n")
     uart.write(0, "OK")
end, 0)

uart.on("data", "AT+BAUD4", 
  function(data)
     print("receive uart ["..data.."]\n")
     uart.write(0, "OK")
end, 0)

--uart.on("data", 0, 
--  function(data)
--      print("receive uart ["..data.."]\n")
--    if data=="AT" then 
--      uart.on("data") 
--      print("done "..data)
--    end
--end, 0)


--tmr.alarm(5, 2000, 1, function()
--   print("\nwrite uart\n")
--   uart.write(0, "OK")
--end)

