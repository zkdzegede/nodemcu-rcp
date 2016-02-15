--print("### metaModule ### heap "..node.heap())

-- TODO save to metaSettings.txt 

local metaModule, module = {}, ...

function metaModule.init()
    package.loaded[module]=nil
end

function metaModule.get_meta_msg(count)
    return {s={t=count,meta=metaModule.get_meta()}}
end

function metaModule.get_meta()
    return getSimpleChannelMeta()
end

function metaModule.convert_meta(channelmeta)
    local msg = {s={t=count,meta={}}}
    local meta = {}

    -- BIG TODO
    for k, v in pairs(channelmeta) do
        print("Channel name: "..k)
        table.insert(meta, {
            nm= v.name,
            ut= v.units,
            min= v.min,
            max= v.max,
            prec = v.prec,
            sr= v.sr,
        })
     end

     return meta
    -- msg.s.meta = meta
    -- return(cjson.encode(msg))
end

function getSimpleChannelMeta()
    return {
              {nm="Interval"},
              {nm="Utc"},
              {nm="Battery"},
              {nm="AccelX"},
              {nm="AccelY"},
              {nm="AccelZ"},
              {nm="Yaw"},
              {nm="Pitch"},
              {nm="Roll"},
              {nm="Latitude"},
              {nm="Longitude"},
              {nm="Speed"},
              {nm="Distance"},
              {nm="Altitude"},
              {nm="GPSSats"},
              {nm="GPSQual"},
              {nm="GPSDOP"},
              {nm="LapCount"},
              {nm="LapTime"},
              {nm="Sector"},
              {nm="SectorTime"},
              {nm="PredTime"},
              {nm="ElapsedTime"},
              {nm="CurrentLap"},
              {nm="SusTravelF"},
              {nm="SusTravelR"},
              {nm="TPS"},
              {nm="RPM"},
            }
end

function getChannelMeta()
    return {
              {nm="Interval",ut="ms",min=0,max=0,prec=0,sr=1},
              {nm="Utc",ut="ms",min=0,max=0,prec=0,sr=1},
              {nm="Battery",ut="Volts",min=0.0,max=20.0,prec=2,sr=1},
              {nm="AccelX",ut="G",min=-3.0,max=3.0,prec=2,sr=25},
              {nm="AccelY",ut="G",min=-3.0,max=3.0,prec=2,sr=25},
              {nm="AccelZ",ut="G",min=-3.0,max=3.0,prec=2,sr=25},
              {nm="Yaw",ut="Deg/Sec",min=-300.0,max=300.0,prec=1,sr=25},
              {nm="Pitch",ut="Deg/Sec",min=-300.0,max=300.0,prec=1,sr=25},
              {nm="Roll",ut="Deg/Sec",min=-300.0,max=300.0,prec=1,sr=25},
              {nm="Latitude",ut="Degrees",min=-180.0,max=180.0,prec=6,sr=10},
              {nm="Longitude",ut="Degrees",min=-180.0,max=180.0,prec=6,sr=10},
              {nm="Speed",ut="MPH",min=0.0,max=150.0,prec=2,sr=10},
              {nm="Distance",ut="Miles",min=0.0,max=0.0,prec=3,sr=10},
              {nm="Altitude",ut="Feet",min=0.0,max=4000.0,prec=1,sr=10},
              {nm="LapCount",ut="",min=0,max=0,prec=0,sr=10},
              {nm="LapTime",ut="Min",min=0.0,max=0.0,prec=4,sr=10},
              {nm="Sector",ut="",min=0,max=0,prec=0,sr=10},
              {nm="SectorTime",ut="Min",min=0.0,max=0.0,prec=4,sr=10},
              {nm="PredTime",ut="Min",min=0.0,max=0.0,prec=4,sr=5},
              {nm="ElapsedTime",ut="Min",min=0.0,max=0.0,prec=4,sr=10},
              {nm="CurrentLap",ut="",min=0,max=0,prec=0,sr=10},
              {nm="GPSSats",ut="",min=0,max=20,prec=0,sr=10},
              {nm="GPSQual",ut="",min=0,max=5,prec=0,sr=10},
              {nm="GPSDOP",ut="",min=0.0,max=20.0,prec=1,sr=10},
              {nm="GPSDOP",ut="",min=0.0,max=20.0,prec=1,sr=10},
              {nm="SusTravelF",ut="mm",min=0.0,max=150.0,prec=1,sr=10},
              {nm="SusTravelR",ut="mm",min=0.0,max=80.0,prec=1,sr=10},
              {nm="TPS",ut="%",min=0.0,max=100.0,prec=1,sr=10},
              {nm="RPM",ut="rpm",min=0.0,max=18000.0,prec=1,sr=10},
            }
end

return metaModule
