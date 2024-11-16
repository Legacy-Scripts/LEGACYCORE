RegisterNetEvent("LGF_Banking.ManageActionAccount", function(action, amount)
    local src = source

    if not src or not tonumber(amount) or tonumber(amount) <= 0 then
        print("Cheating attempt detected! Invalid source or amount.")
        return
    end

    local PlayerAccount = Lgf.Core:GetPlayerAccount(src)
    if type(PlayerAccount) == "string" then PlayerAccount = json.decode(PlayerAccount) end

    if PlayerAccount and PlayerAccount.Bank then
        local bankAmount = tonumber(PlayerAccount.Bank)
        local amountNum = tonumber(amount)
        if action == "withdraw" then
            if bankAmount >= amountNum then
                Lgf.Core:ManageAccount(src, amountNum, "remove")
                Shared.Notification("Banking", ("Withdrawal successful: %s$"):format(amountNum), "top-right", "success",
                    src)
                Editable.AddPlayerItem(src, Config.ItemCashName, amountNum)
                TriggerClientEvent("LGF_Banking.UpdatePlayerMoney", src)
                Functions.addTransactions("Withdraw", src, amount)

                Wait(1000)
                TriggerClientEvent("LGF_Banking.UpdatePlayerTransactions", src)
            else
                Shared.Notification("Banking", ("Insufficient funds! Current balance: %s$"):format(bankAmount),
                    "top-right", "error", src)
            end
        elseif action == "deposit" then
            local PlayerCash = Editable.GetItemCount(src, Config.ItemCashName)
            if PlayerCash >= amountNum then
                Lgf.Core:ManageAccount(src, amountNum, "add")
                Editable.RemovePlayerItem(src, Config.ItemCashName, amountNum)
                Shared.Notification("Banking", ("Deposit successful: %s$"):format(amountNum), "top-right", "success", src)
                TriggerClientEvent("LGF_Banking.UpdatePlayerMoney", src)

                Functions.addTransactions("Deposit", src, amount)
                Wait(1000)
                TriggerClientEvent("LGF_Banking.UpdatePlayerTransactions", src)
            else
                Shared.Notification("Banking", ("Insufficient cash for deposit! You have: %s$"):format(PlayerCash),
                    "top-right", "error", src)
            end
        end
    end
end)

Lgf:RegisterServerCallback("LGF_Banking.isPlayerNew", function(source)
    return Functions.isPlayerNew(source)
end)


Lgf:RegisterServerCallback("LGF_Banking.GetPlayerPin", function(source)
    return Functions.getPlayerPin(source)
end)


RegisterNetEvent("LGF_Banking.UpdateDb.Pin.CreateNewPin", function(newPin)
    local src = source
    local isPinCreated = Functions.createNewPin(src, newPin)
    if isPinCreated then
        print("PIN created successfully!")
    else
        print("Failed to create PIN.")
    end
end)


RegisterNetEvent("LGF_Banking.UpdateDb.CreateNewInvoice", function(invoiceData)
    if not invoiceData then
        assert("No invoice data")
        return
    end
    Functions.createNewInvoice(invoiceData)
end)

Lgf:RegisterServerCallback("LGF_Banking.getInvoicesForTarget", function(source)
    return Functions.getInvoicesForTarget(source)
end)

RegisterNetEvent("LGF_Banking.UpdateDb.UpdateStatus", function(invoiceID, status, amount)
    local src = source
    assert(invoiceID and status, "Error: Missing invoiceID or status.")
    Functions.updateInvoiceStatus(invoiceID, status)
    Lgf.Core:ManageAccount(src, amount, "remove")
    SetTimeout(1000, function()
        Lgf:TriggerClientEvent("LGF_Banking.UpdatePlayerMoney", src)
    end)
end)

RegisterNetEvent("LGF_Banking.ChangePin", function(newPin)
    local src = source
    assert(newPin and type(newPin) == "number", "Error: Invalid or missing PIN data.")
    Functions.updatePin(src, newPin)
end)

RegisterNetEvent("LGF_Banking.UpdateDb.DeleteInvoice", function(invoiceId)
    if not invoiceId then return end
    Functions.deleteInvoice(invoiceId)
end)

Lgf:RegisterServerCallback("LGF_Banking.isPlayerOnline", function(source, target)
    return Lgf:isPlayerOnline(target)
end)


Lgf:RegisterServerCallback("LGF_Banking.getPlayerBankingData", function(source)
    return Functions.getPlayerBankingData(source)
end)


Lgf:RegisterServerCallback("LGF_Banking.GetNearbyPlayerName", function(source, target)
    return Lgf.Core:GetName(target)
end)

Lgf:RegisterServerCallback("LGF_Banking.getTransactions", function(source)
    return Functions.getTransactions(source)
end)


RegisterNetEvent("LGF_Banking.ClearAllTransactions", function()
    local src = source
    Functions.deleteAllTransactions(src)
end)
