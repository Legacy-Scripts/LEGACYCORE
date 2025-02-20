local Chars = require "modules.server.sv-characters"

lib.addCommand('relog', {
    help = 'Relog Character',


}, function(source, args, raw)
    Chars.relog(source)
end)
