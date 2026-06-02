local scratching = false


local function getslot()
    local ped = PlayerPedId()
    local weaponhash = GetSelectedPedWeapon(ped)
    if weaponhash == `WEAPON_UNARMED` then return nil end

    local weapons = exports.ox_inventory:GetPlayerItems() --  https://overextended.dev/ox_inventory/Functions/Client#getplayeritems
    if not weapons then return nil end

    for _, item in pairs(weapons) do
        if item.metadata then
            local hash = joaat(item.name:upper())
            if hash == weaponhash then
                return item.slot, item.name, item.metadata
            end
        end
    end
    return nil, nil, nil
end


exports('usescratch', function()
    if scratching then return end

    local ped = PlayerPedId()
    local weaponhash = GetSelectedPedWeapon(ped)

    if weaponhash == `WEAPON_UNARMED` then
        lib.notify({  description = 'Musíš držet zbraň v ruce!', type = 'error' })
        return
    end

    local slot, itemname, metadata = getslot()
    if not slot then
        lib.notify({  description = 'Zbraň nebyla nalezena v inventáři.', type = 'error' })
        return
    end

    if metadata.serial == dnj.scratchhook then
        lib.notify({  description = 'Sériové číslo je již smazáno.', type = 'inform' })
        return
    end

    for _, v in ipairs(dnj.weaponblacklist) do
        if joaat(v) == weaponhash then
            lib.notify({  description = 'Tuto zbraň nelze upravit.', type = 'error' })
            return
        end
    end

    scratching = true

    --lib.requestAnimDict('mp_arresting')
    --TaskPlayAnim(ped, 'mp_arresting', 'a_uncuff', 2.0, -2.0, -1, 49, 0, false, false, false)

    local success = lib.progressBar({
        duration     = 6000,
        label        = 'Mažeš sériové číslo...',
        useWhileDead = false,
        canCancel    = true,
        disable      = { move = true, car = true, combat = true },
        anim         = { dict = 'mp_arresting', clip = 'a_uncuff', flag = 49 },
    })

    ClearPedTasks(ped)
    scratching = false

    if success then
        TriggerServerEvent('dnj_scratcher:scratch', slot, itemname)
    end
end)

RegisterNetEvent('dnj_scratcher:notify', function(key)
    local messages = {
        success     = { description = 'Sériové číslo bylo úspěšně smazáno.', type = 'success' },
        alreadydone = { description = 'Sériové číslo je již smazáno.', type = 'inform' },
        failed      = { description = 'Něco se pokazilo.', type = 'error' },
    }
    local n = messages[key]
    if n then
        lib.notify({  description = n.description, type = n.type })
    end
end)