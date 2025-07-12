local identityChecked = false

local function checkIdentity()
    if identityChecked then return end
    identityChecked = true
    Wait(1000)
    TriggerServerEvent('sky-identity:checkIdentity')
end

AddEventHandler('esx:loadingscreenOff', checkIdentity)
AddEventHandler('playerSpawned', checkIdentity)

AddEventHandler('esx:loadingscreenOff', function()
    Wait(1000)
    TriggerServerEvent('sky-identity:checkIdentity')
end)

RegisterNetEvent('sky-identity:openForm')
AddEventHandler('sky-identity:openForm', function()
    SetNuiFocus(true, true) 
    SendNUIMessage({ type = "open" })

    local ped = PlayerPedId()

    SetLocalPlayerAsGhost(true) 
    NetworkSetEntityInvisibleToNetwork(ped, true)

end)

RegisterNUICallback("submitPassport", function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent("sky-identity:register", data)

    TriggerEvent('esx_skin:openSaveableMenu')

    local ped = PlayerPedId()

    SetLocalPlayerAsGhost(false)
    NetworkSetEntityInvisibleToNetwork(ped, false)

    cb("ok")
end)