local Nui = {}
LocalPlayer.state.multicharBusy = false
LocalPlayer.state.identityBusy = false

function Nui.ShowNui(action, data)
  SetNuiFocus(data.Visible, data.Visible)
  SendNUIMessage({ action = action, data = data })
  LocalPlayer.state.multicharBusy = data.Visible
end

RegisterNuiCallback("Revoria_Multichar:CloseUiByIndex", function(data, cb)
  if data.name == "openIdentity" then
    SendNUIMessage({ action = "openIdentity", data = { Visible = false } })
    LocalPlayer.state.identityBusy = false
  end
  cb(true)
end)

return Nui
