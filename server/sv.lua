local cooldowns = {}

RegisterNetEvent('dnj_scratcher:scratch', function(slot, itemname)
    local src = source
    local now = os.time()

    if cooldowns[src] and (now - cooldowns[src]) < 10 then return end
    cooldowns[src] = now
    local item = exports.ox_inventory:GetSlot(src, slot) -- https://overextended.dev/ox_inventory/Functions/Server#getslot

    if not item or item.name ~= itemname then
        TriggerClientEvent('dnj_scratcher:notify', src, 'failed')
        return
    end

    if item.metadata.serial == dnj.scratchhook then
        TriggerClientEvent('dnj_scratcher:notify', src, 'alreadydone')
        return
    end

    local scratcherslot = exports.ox_inventory:GetItemSlots(src, dnj.scratcheritem) -- https://overextended.dev/ox_inventory/Functions/Server#getitemslots
    if not scratcherslot then
        TriggerClientEvent('dnj_scratcher:notify', src, 'failed')
        return
    end

    local removed = exports.ox_inventory:RemoveItem(src, dnj.scratcheritem, 1)
    if not removed then
        TriggerClientEvent('dnj_scratcher:notify', src, 'failed')
        return
    end

    local newmeta = item.metadata
    newmeta.serial = dnj.scratchhook

    exports.ox_inventory:SetMetadata(src, slot, newmeta) -- https://overextended.dev/ox_inventory/Functions/Server#setmetadata
    TriggerClientEvent('dnj_scratcher:notify', src, 'success')

    print(('[dnj_scratcher] hrac %s zoskrabal serial na zbrani %s (slot %d)'):format(GetPlayerIdentifier(src, 0) or src, itemname, slot))
end)