
TabletEntity = nil

RegisterNUICallback("LGF_Banking.CreateNewInvoice", function(body, resultCallback)
    if not body then return end
    local Target = body.PlayerID
    local IsOnlineTarget = Lgf:TriggerServerCallback("LGF_Banking.isPlayerOnline", Target)

    if not IsOnlineTarget then
        Shared.Notification("Create Invoice", ("Player with ID %s is not Online."):format(Target), "top", "warning")
        return
    end

    TriggerServerEvent("LGF_Banking.UpdateDb.CreateNewInvoice", body)

    if LocalPlayer.state["createInvoice"] then
        Nui.openInvoiceCreator(false)
    end


    resultCallback(true)
end)




RegisterNUICallback("LGF_Banking.GetAllInvoice", function(body, resultCallback)
    local InvoiceToSend = {}
    local AllInvoices = Lgf:TriggerServerCallback("LGF_Banking.getInvoicesForTarget")


    TriggerEvent("LGF_Banking.UpdatePlayerMoney")

    for k, data in pairs(AllInvoices) do
        local title = data.type == "society" and ("%s Invoice %s - %s"):format(data.type, data.invoiceID, data.society) or
            ("%s Invoice %s"):format(data.type, data.invoiceID)

        InvoiceToSend[#InvoiceToSend + 1] = {
            id          = data.invoiceID,
            title       = title,
            amount      = tonumber(data.amount),
            date        = data.created_at,
            status      = data.status,
            invoiceType = data.type,
            description = data.description,
            societyName = data.society,
        }
    end

    resultCallback(InvoiceToSend)
end)


RegisterNUICallback("LGF_Banking.MarkInvoiceAsPaid", function(body, resultCallback)
    if not body then return end

    local Payed = body.payed
    local Amount = body.amount
    local IdInvoice = body.id
    local PlayerCashBank = Data.GetPlayerInfo().AmountBank

    if not Payed then
        print("Payment flag is not set, aborting.")
        return
    end

    if PlayerCashBank >= Amount then
        TriggerServerEvent("LGF_Banking.UpdateDb.UpdateStatus", IdInvoice, "paid", Amount)
        Shared.Notification("Mark Invoice", ("Invoice %s successfully marked as paid."):format(IdInvoice), "top", "success")
        resultCallback(true)
    else
        Shared.Notification("Mark Invoice", ("Insufficient funds to mark invoice %s as paid."):format(IdInvoice), "top","error")
        resultCallback(false)
    end
end)

RegisterNUICallback("LGF_Banking.DeleteInvoicePayed", function(body, resultCallback)
    if not body then return end
    local IdInvoice = body.id
    TriggerServerEvent("LGF_Banking.UpdateDb.DeleteInvoice", IdInvoice)
end)

RegisterNetEvent("LGF_Banking.updateInvoice", function()
    SendNUIMessage({
        action = "updateInvoice"
    })
end)


RegisterNUICallback("LGF_Banking.GetclosestPlayer", function(body, resultCallback)
    resultCallback(Functions.GetNearbyPlayer())
end)

exports('createInvoice', function(data, slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            local Obj = Functions.startPlayerAnim("base", "amb@world_human_tourist_map@male@base", "prop_cs_tablet")
            TabletEntity = Obj
            Nui.openInvoiceCreator(true)
        end
    end)
end)
