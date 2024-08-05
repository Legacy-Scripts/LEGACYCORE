local GetResMeta = GetResourceMetadata
local GetResName = GetCurrentResourceName
local REQUIRED_VERSION = '3.24.0'

if not _VERSION:find('5.4') then error('Lua 5.4 is required Put It in your Manifest!', 2) end

if not lib then error("LegacyCore requires Ox Lib to work and must be started before the Framework.") return end

if not lib.checkDependency('ox_lib', REQUIRED_VERSION, true) then return end

if lib.context == 'server' then lib.load("@oxmysql/lib/MySQL")end

exports('GetCoreData', function() return _ENV.Legacy end)

print(("^2[SUCCESS]^0 LegacyCore version ^2%s^0 has been successfully initialized."):format(GetResMeta(GetResName(), 'version', 0)))