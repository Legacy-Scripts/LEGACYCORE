Nui = {}
LocalPlayer = { state = { openBanking = false, openPinAccess = false, createInvoice = false } }
local State = LocalPlayer.state

function Nui.ShowNui(action, data)
  local state = data.Visible
  if state and State[action] then state = false end
  SetNuiFocus(state, state)
  if action == "openBanking" then
    SendNUIMessage({ action = action, data = { Visible = data.Visible, PersonalData = data.PersonalData, } })
  elseif action == "openPinAccess" then
    SendNUIMessage({ action = action, data = { Visible = data.Visible, isNew = data.isNew, } })
  elseif action == "createInvoice" then
    SendNUIMessage({ action = action, data = { Visible = data.Visible } })
  end

  if State[action] ~= nil then State[action] = state end
end

RegisterNuiCallback('LGF_Banking:CloseByIndex', function(data, cb)
  print(json.encode(data))
  if data.ui_name == "openBanking" then
    Nui.ShowNui("openBanking", {
      Visible = false,
      PersonalData = {}
    })
  elseif data.ui_name == "openPinAccess" then
    Nui.ShowNui("openPinAccess", {
      Visible = false,
      isNew = Data.GetPlayerInfo().IsNew
    })
  elseif data.ui_name == "createInvoice" then
    if TabletEntity then
      Functions.ClearPed()
    end
    Nui.openInvoiceCreator(false)
  end
  cb(true)
end)

function Nui.toggleBanking(state, data)
  Nui.ShowNui("openBanking", { Visible = state, PersonalData = data })
  SendNUIMessage({ action = "updateMoney", data = Lgf.Core:GetPlayerAccount().Bank or 0 })
end

function Nui.openAccessPin(state, isNew)
  Nui.ShowNui("openPinAccess", { Visible = state, isNew = isNew })
end

function Nui.openInvoiceCreator(state)
  Nui.ShowNui("createInvoice", { Visible = state, })
end
