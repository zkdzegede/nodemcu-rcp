print("setup uart")

300, 600, 1200, , , , , 

9600
74880
115200
1843200 

uart.setup(0, 9600, 8, 0, 1, 1)

uart.setup(0, 9600, 8, 0, 1, 0)

uart.on("data", 0, 
  function(data)
  	print("receive uart ["..data.."]\n")
    if data=="AT" then 
      uart.on("data") 
      print("done "..data)
    end
end, 0)

tmr.alarm(5, 2000, 1, function()
   print("write uart\n")
   uart.write(0, "qwertyuiopasdfghjklzxcvbnm")
end)

