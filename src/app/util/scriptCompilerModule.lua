print("scriptCompilerModule: heap "..node.heap())
local scriptCompilerModule, module = {}, ...

function scriptCompilerModule.listStats()
   local remaining, used, total = file.fsinfo()
   print("\nUsed: "..used.." Bytes")
   print("Remaining: "..remaining.." Bytes")
end

function scriptCompilerModule.deleteCompiledFiles(files)
   print("\nDelete Compiled Files: "..node.heap())
   for k,v in pairs(files) do
       if (string.find(k, ".lc") ~= nil) then
           print("Delete "..k..": heap "..node.heap())
           file.remove(k)
       end
   end
end

function scriptCompilerModule.listFiles(files)
   print("\nList files: "..node.heap())
   for k,v in pairs(files) do
     print(k..", size:"..v)
   end
end

function scriptCompilerModule.compileFiles(files)
   print("\nCompile Files: "..node.heap())
   for k,v in pairs(files) do
     if ((string.find(k, ".lua") == nil) or 
         (string.find(k, "Compiler") ~= nil)
         )then
       print("Skip "..k..": heap "..node.heap())
     else
       print("Before Compile "..k..": heap "..node.heap())
       node.compile(string.gsub(k, ".lua", ".lua"))
       print("After Compile "..k..": heap "..node.heap())
     end
   end
end

function scriptCompilerModule.run()
   package.loaded[module]=nil
   scriptCompilerModule.listStats()
   scriptCompilerModule.deleteCompiledFiles(file.list())
   scriptCompilerModule.compileFiles(file.list())
   scriptCompilerModule.listFiles(file.list())
end

return scriptCompilerModule
