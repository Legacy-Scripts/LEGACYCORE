if not lib then error("Require Ox Lib.") end

if lib.context == 'server' then lib.load("@oxmysql/lib/MySQL") end

exports('GetCoreData', function()  return _ENV.Legacy end)

