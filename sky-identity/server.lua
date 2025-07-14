RegisterNetEvent('sky-identity:checkIdentity')
AddEventHandler('sky-identity:checkIdentity', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    MySQL.query('SELECT firstname FROM users WHERE identifier = ?', {identifier}, function(result)
        if result[1] and (result[1].firstname == nil or result[1].firstname == '') then
            TriggerClientEvent('sky-identity:openForm', src)
        end
    end)
end)

local function StripIdentifierPrefix(identifier)
    return identifier:match(":(.+)$") or identifier
end

RegisterServerEvent("sky-identity:register")
AddEventHandler("sky-identity:register", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    MySQL.update([[
        UPDATE users 
        SET 
            firstname = ?, 
            lastname = ?, 
            dateofbirth = ?, 
            height = ?, 
            sex = ?, 
            nationality = ? 
        WHERE identifier = ?
    ]], {
        data.firstName,
        data.lastName,
        data.dob,
        tonumber(data.height),
        data.gender,
        data.nationality,
        identifier 
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print(('Identity updated for %s'):format(identifier))
        else
            print(('Identity update failed for %s'):format(identifier))
        end
    end)
end)

RegisterCommand("restry", function(source, args)
    local xAdmin = ESX.GetPlayerFromId(source)
    if not xAdmin or xAdmin.getGroup() ~= "admin" then return end

    local targetId = tonumber(args[1])
    if not targetId then return end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then return end

    local identifier = xTarget.identifier

    MySQL.update([[
        UPDATE users
        SET
            firstname = NULL,
            lastname = NULL,
            dateofbirth = NULL,
            height = NULL,
            sex = NULL,
            nationality = NULL
        WHERE identifier = ?
    ]], {identifier}, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('sky-identity:openForm', targetId)
        end
    end)
end)

RegisterCommand("delchar", function(source, args)
    local xAdmin = ESX.GetPlayerFromId(source)
    if not xAdmin then return end

    local adminGroup = xAdmin.getGroup()
    if adminGroup ~= "admin" and adminGroup ~= "superadmin" then return end

    local targetId = tonumber(args[1])
    if not targetId then return end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then return end

    local identifier = xTarget.identifier

    MySQL.update('DELETE FROM users WHERE identifier = ?', {identifier}, function(rowsChanged)
        if rowsChanged > 0 then
            DropPlayer(targetId, "Karakter kamu telah dihapus oleh admin.")
        end
    end)
end)

