Selector = {}

function Selector:OpenMainSelector()
    local OptionsData = {}

    for _, data in pairs(Config.SpawnSelector) do
        local x, y, z, w = data.PositionSpawn.x, data.PositionSpawn.y, data.PositionSpawn.z, data.PositionSpawn.w
        table.insert(OptionsData, {
            title = data.Title,
            description = data.Description,
            icon = 'hand',
            disabled = false,
            onSelect = function()
                Utils:doScreenFade('out', 1000)
                local timer = lib.timer(2000, function()
                    Utils:TeleportPlayer(x, y, z, w, Legacy.CACHE:GetCache('ped').pedId)
                    Utils:clearPeds()
                    Wait(1000)
                    Utils:doScreenFade('in', 1000)
                end, true)
            end
        })
    end

    lib.registerContext({
        id = 'main_menu',
        title = Locale:GetTranslation('title_SpawnSelector'),
        options = OptionsData
    })

    lib.showContext('main_menu')
end

exports('OpenSelector', Selector.OpenMainSelector)


