Data = {}


function Data.GetAllTransactions()
    local AllTransactions = Lgf:TriggerServerCallback("LGF_Banking.getTransactions")
    local Transactions = {}
    for _, transaction in ipairs(AllTransactions) do
        Transactions[#Transactions + 1] = {
            type = transaction.Type,
            amount = transaction.Amount,
            dateTime = transaction.CurrentTime,
            id = transaction.id,
        }
    end
    return Transactions
end

function Data.GetPlayerInfo()
    local PlayerData = {}
    local isPlayerNew = Lgf:TriggerServerCallback("LGF_Banking.isPlayerNew")
    PlayerData.PlayerName = Lgf.Core:GetName()
    PlayerData.Location = Functions.GetHashKeyStreet(Lgf.Player:Coords())
    local playerAccount = Lgf.Core:GetPlayerAccount()
    PlayerData.AmountBank = playerAccount and playerAccount.Bank or 0
    PlayerData.IsNew = isPlayerNew
    return PlayerData
end

RegisterNUICallback("LGF_Banking.ManageActionAccount", function(body, resultCallback)
    print(json.encode(body))
    local Action = body.Action
    local Target = body.PlayerID
    local Amount = tonumber(body.Amount)
    if Action == "withdraw" or Action == "deposit" then
        TriggerServerEvent("LGF_Banking.ManageActionAccount", Action, Amount)
    elseif Action == "transfered" then

    end
    resultCallback(true)
end)


RegisterNetEvent("LGF_Banking.UpdatePlayerMoney", function()
    SendNUIMessage({
        action = "updateMoney",
        data = Lgf.Core:GetPlayerAccount().Bank or 0
    })
end)

RegisterNetEvent("LGF_Banking.UpdatePlayerTransactions", function()
    SendNUIMessage({
        action = "updateTransactions",
    })
end)


RegisterNUICallback("LGF_Banking.ChangePin", function(body, resultCallback)
    local newPin = tonumber(body.pin)
    local changed = body.changed

    if changed == true then
        Shared.Notification("Pin Change", "Your PIN has been changed successfully.", "top", "success")
        TriggerServerEvent("LGF_Banking.ChangePin", newPin)
        resultCallback(true)
    else
        Shared.Notification("Pin Change", "PINs do not match or Not validate Checkbox, Please try again.", "top", "error")
        resultCallback(false)
    end
end)


RegisterNUICallback("LGF_Banking.GetCreditCardInfo", function(body, resultCallback)
    local playerName = Lgf.Core:GetName()
    local CardInfo = Lgf:TriggerServerCallback("LGF_Banking.getPlayerBankingData")
    if not CardInfo then CardInfo = {} end


    local creditCardInfo = {
        name = playerName,
        expiry = CardInfo.Expiry,
        cvc = CardInfo.CVC,
        number = CardInfo.CardNumber
    }

    resultCallback(creditCardInfo)
end)

RegisterNUICallback("LGF_Banking.GetAllTransaction", function(body, resultCallback)
    local AllTransactions = Data.GetAllTransactions()

    resultCallback(AllTransactions)
end)

RegisterNUICallback("LGF_Banking.ClearAllTransactions", function(body, resultCallback)
    TriggerServerEvent("LGF_Banking.ClearAllTransactions")
    Shared.Notification("Transaction History", "All transactions have been cleared successfully.", "top", "success")
    resultCallback(true)
end)
