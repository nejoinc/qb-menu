local QBCore = exports['qb-core']:GetCoreObject()

local headerShown = false
local sendData = nil
local thread = false
local ToDisable = { 14, 15, 16, 17, 18, 24, 25, 27, 50, 68, 69, 70, 91, 92, 96, 97, 99, 106, 114, 115, 122, 135, 142, 144, 176, 177, 180, 181, 198, 222, 223, 229, 237, 238, 241, 242, 257, 261, 262, 329, 330, 331, 334, 335, 336, 346, 348, 347 }

-- Functions
local function openMenu(data)
    if not data or not next(data) then return end
	for _,v in pairs(data) do
		if v["icon"] then
			if QBCore.Shared.Items[tostring(v["icon"])] then
				if not string.find(QBCore.Shared.Items[tostring(v["icon"])].image, "//") and not string.find(v["icon"], "//") then
                    v["icon"] = "nui://origen_inventory/html/images/"..QBCore.Shared.Items[tostring(v["icon"])].image
				end
			end
		end
	end
    SetNuiFocus(true, false)
    if not data[1] or not data[1].isMenuHeader or not data[1].nokeepinput then
        SetNuiFocusKeepInput(true) 
    end
    headerShown = false
    sendData = data
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = table.clone(data)
    })
    if not thread then
        thread = true
        Citizen.CreateThread(function()
            while thread do
                Citizen.Wait(0)
                for i = 1, #ToDisable do
                    DisableControlAction(0, ToDisable[i], true)
                end
            end
        end)
        Citizen.CreateThread(function()
            while sendData do
                Citizen.Wait(1200)
            end
            thread = false
        end)
    end
end

local function clearMenuData()
    sendData = nil
    headerShown = false
    SetNuiFocus(false)
    SetNuiFocusKeepInput(false)
end

local function closeMenu()
    clearMenuData()
    SendNUIMessage({
        action = 'CLOSE_MENU'
    })
end

local function showHeader(data)
    if not data or not next(data) then return end
    headerShown = true
    sendData = data
    SendNUIMessage({
        action = 'SHOW_HEADER',
        data = table.clone(data)
    })
end

local function UpdateOption(option, key, value)
    if sendData then
        sendData[option][key] = value
    end
    SendNUIMessage({
        action = 'UPDATE_OPTION',
        option = option,
        key = key,
        value = value
    })
end

local function HideMenu()
    SendNUIMessage({
        action = 'HIDE_MENU'
    })
end

local function ShowMenu()
    SendNUIMessage({
        action = 'SHOW_MENU'
    })
end

-- Events

RegisterNetEvent('qb-menu:client:openMenu', function(data)
    openMenu(data)
end)

RegisterNetEvent('qb-menu:client:closeMenu', function()
    closeMenu()
end)

-- NUI Callbacks

RegisterNUICallback('clickedButton', function(option, cb)
    if sendData then
        local data = sendData[tonumber(option)]
        sendData = nil
        if data then
            if data.params.event then
                if data.params.isServer then
                    TriggerServerEvent(data.params.event, data.params.args)
                elseif data.params.isCommand then
                    ExecuteCommand(data.params.event)
                elseif data.params.isQBCommand then
                    TriggerServerEvent('QBCore:CallCommand', data.params.event, data.params.args)
                elseif data.params.isAction then
                    data.params.event(data.params.args)
                else
                    TriggerEvent(data.params.event, data.params.args)
                end
            end
        end
    end
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(_, cb)
    clearMenuData()
    cb('ok')
    TriggerEvent("qb-menu:client:menuClosed")
end)

-- Command and Keymapping

RegisterCommand('playerfocus', function()
    if headerShown then
        SetNuiFocus(true, false)
        SetNuiFocusKeepInput(true)
    end
end)

RegisterKeyMapping('playerFocus', 'Give Menu Focus', 'keyboard', 'LMENU')

-- Exports

exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('showHeader', showHeader)
exports('UpdateOption', UpdateOption)
exports('HideMenu', HideMenu)
exports('ShowMenu', ShowMenu)

RegisterCommand("qbmenutest", function(source, args, raw)
    openMenu({
        {
            header = "MENU TITLE",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            icon = 'fa-solid fa-user',
            params = {
                event = "qb-menu:client:testMenu2",
                args = {
                    number = 1,
                }
            }
        },
        {
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            icon = "fa-solid fa-briefcase",
            params = {
                event = "qb-menu:client:testMenu2",
                args = {
                    number = 1,
                }
            }
        },
        {
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            icon = "fa-solid fa-house",
            params = {
                event = "qb-menu:client:testMenu2",
                args = {
                    number = 1,
                }
            }
        },
        {
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            icon = "fa-solid fa-car",
            params = {
                event = "qb-menu:client:testMenu2",
                args = {
                    number = 1,
                }
            }
        }
    })
end)