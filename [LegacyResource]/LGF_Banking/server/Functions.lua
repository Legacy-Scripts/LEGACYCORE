Functions = {}

function Functions.isPlayerNew(target)
    local Identifier = Lgf.Core:GetIdentifier(target)

    if not Identifier then
        return false
    end

    local hasPin = MySQL.scalar.await('SELECT `Pin` FROM `lgf_banking` WHERE `Owner` = ? LIMIT 1', {
        Identifier
    })

    return not hasPin
end

function Functions.getPlayerPin(target)
    local Identifier = Lgf.Core:GetIdentifier(target)

    if not Identifier then
        return nil
    end

    return MySQL.scalar.await('SELECT `Pin` FROM `lgf_banking` WHERE `Owner` = ? LIMIT 1', {
        Identifier
    })
end

function Functions.createNewPin(target, newPin)
    local Identifier = Lgf.Core:GetIdentifier(target)
    local CreditCardNumber = Functions.generateCreditCardNumber()
    local ExpiryCard = Functions.generateCreditCardExpiry()
    local CVC = Functions.generateCreditCardCVC()

    if not Identifier then
        return false
    end

    if not Functions.isPlayerNew(target) then
        return false
    end


    local success = MySQL.insert.await(
        'INSERT INTO `lgf_banking` (`Owner`, `Pin`, `CardNumber`, `Expiry`, `CVC`) VALUES (?, ?, ?, ?, ?)',
        {
            Identifier,
            newPin,
            CreditCardNumber,
            ExpiryCard,
            CVC
        }
    )

    return success
end

function Functions.updatePin(target, newPin)
    local Identifier = Lgf.Core:GetIdentifier(target)

    if not Identifier then
        return false
    end

    local currentPin = Functions.getPlayerPin(target)
    if not currentPin then
        return false
    end

    return MySQL.update.await('UPDATE `lgf_banking` SET `Pin` = ? WHERE `Owner` = ?', {
        newPin,
        Identifier
    })
end

function Functions.updateInvoiceStatus(invoiceId, newStatus)
    if newStatus ~= "paid" and newStatus ~= "unpaid" then
        error("Invalid status. Must be 'paid' or 'unpaid'.")
    end

    local success = MySQL.update.await('UPDATE `lgf_invoice` SET `status` = ? WHERE `invoiceID` = ?', {
        newStatus,
        invoiceId
    })

    return success
end

function Functions.getInvoicesForTarget(target)
    local Identifier = Lgf.Core:GetIdentifier(target)

    if not Identifier then
        return nil
    end

    local invoices = MySQL.query.await('SELECT * FROM `lgf_invoice` WHERE `sender` = ?', {
        Identifier
    })

    for _, invoice in ipairs(invoices) do
        if invoice.created_at then
            local seconds = math.floor(invoice.created_at / 1000)
            invoice.created_at = os.date("%Y-%m-%d %H:%M:%S", seconds)
        end
    end

    return invoices
end

function Functions.generateInvoiceId()
    local FinalID
    local idExists = true

    while idExists do
        local Id = Lgf.string:RandStr(4, "aln")
        Id = string.upper(Id)
        FinalID = ("#%s"):format(Id)
        local existingId = MySQL.query.await("SELECT COUNT(*) as count FROM `lgf_invoice` WHERE `invoiceID` = ?",
            { FinalID })
        idExists = existingId[1].count > 0
    end

    return FinalID
end

function Functions.createNewInvoice(invoiceData)
    local src         = source
    local data        = invoiceData
    local Sender      = Lgf.Core:GetIdentifier(src)
    local Recipient   = Lgf.Core:GetName(tonumber(data.PlayerID))
    local Id          = Functions.generateInvoiceId()
    local Amount      = data.Amount
    local InvoiceType = data.InvoiceType
    local Description = data.Description
    local Status      = "unpaid"

    local Society     = ""

    if InvoiceType == "Society" then
        local playerJob = Lgf.Core:GetJob(tonumber(data.PlayerID))
        Society = (playerJob == "unemployed") and "" or playerJob
    end

    local success = MySQL.insert.await(
        'INSERT INTO `lgf_invoice` (`invoiceID`, `sender`, `recipient`, `amount`, `type`, `status`, `description`, `society`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        {
            Id,
            Sender,
            Recipient,
            Amount,
            InvoiceType,
            Status,
            Description,
            Society
        })

    Shared.Notification("New Invoice", ("You have Received a new Invoice with ID : %s"):format(Id), "top", "inform",
        tonumber(data.PlayerID))

    return success
end

function Functions.deleteInvoice(invoiceId)
    local source = source
    local existingInvoice = MySQL.scalar.await('SELECT COUNT(*) FROM `lgf_invoice` WHERE `invoiceID` = ? LIMIT 1', {
        invoiceId
    })

    if existingInvoice == 0 then
        print("Invoice with ID", invoiceId, "does not exist.")
        return false
    end

    local success = MySQL.update.await('DELETE FROM `lgf_invoice` WHERE `invoiceID` = ?', {
        invoiceId
    })

    if success then
        Shared.Notification("Delete Invoice", ("Invoice with ID %s has been successfully deleted."):format(invoiceId),
            "top", "inform", source)
        Lgf:TriggerClientEvent("LGF_Banking.updateInvoice", source)
    else
        print("Failed to delete invoice with ID", invoiceId)
    end

    return success
end

function Functions.getPlayerBankingData(target)
    local Identifier = Lgf.Core:GetIdentifier(target)

    if not Identifier then
        return nil
    end


    local bankingData = MySQL.query.await('SELECT * FROM `lgf_banking` WHERE `Owner` = ? LIMIT 1', {
        Identifier
    })


    if not bankingData or #bankingData == 0 then
        print("No banking data found for player:", Identifier)
        return nil
    end

    return bankingData[1]
end

function Functions.addTransactions(type, target, amount)
    local identifier = Lgf.Core:GetIdentifier(target)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    local transactionId = ("#%s"):format(Lgf.string:RandStr(1, 'num'))
    print("addTransactions", identifier)
    local newTransaction = {
        Type = type,
        Amount = amount,
        CurrentTime = currentTime,
        id = transactionId
    }

    local existingData = MySQL.query.await('SELECT Transaction FROM lgf_banking WHERE Owner = ?', { identifier })
    local existingTransactions = {}

    if existingData[1] and existingData[1].Transaction then
        existingTransactions = json.decode(existingData[1].Transaction) or {}
    end

    table.insert(existingTransactions, newTransaction)

    local updatedTransactionsJson = json.encode(existingTransactions)

    MySQL.update.await('UPDATE lgf_banking SET Transaction = ? WHERE Owner = ?', {
        updatedTransactionsJson,
        identifier
    })
end

function Functions.getTransactions(target)
    local identifier = Lgf.Core:GetIdentifier(target)
    print("transactions", identifier)
    if not identifier then return end 
    local existingData = MySQL.query.await('SELECT Transaction FROM lgf_banking WHERE Owner = ?', { identifier })
    local transactions = {}

    if existingData[1] and existingData[1].Transaction then
        transactions = json.decode(existingData[1].Transaction) or {}
    end
    print("eseguito")
    return transactions
end

function Functions.generateCreditCardNumber()
    local number = ""
    for i = 1, 4 do
        local segment = tostring(math.random(1000, 9999))
        number = number .. segment .. (i < 4 and " " or "")
    end
    return number
end

function Functions.generateCreditCardExpiry()
    local currentTime = os.time()
    local currentYear = tonumber(os.date("%Y", currentTime)) % 100
    local currentMonth = tonumber(os.date("%m", currentTime))

    local additionalYears = math.random(1, 3) == 1 and 1 or 3

    local year = currentYear + additionalYears

    local month = math.random(1, 12)
    if month < currentMonth then
        year = year + 1
    end

    return string.format("%02d/%02d", month, year)
end

function Functions.generateCreditCardCVC()
    return tostring(math.random(100, 999))
end

function Functions.deleteAllTransactions(target)
    local identifier = Lgf.Core:GetIdentifier(target)
    local success = MySQL.update.await('UPDATE lgf_banking SET Transaction = NULL WHERE Owner = ?', { identifier })
end

exports('isPlayerNew', Functions.isPlayerNew)
exports('getPlayerPin', Functions.getPlayerPin)
exports('createNewPin', Functions.createNewPin)
exports('updatePin', Functions.updatePin)
exports('updateInvoiceStatus', Functions.updateInvoiceStatus)
exports('getInvoicesForTarget', Functions.getInvoicesForTarget)
exports('createNewInvoice', Functions.createNewInvoice)
exports('deleteInvoice', Functions.deleteInvoice)
exports('getPlayerBankingData', Functions.getPlayerBankingData)
exports('getTransactions', Functions.getTransactions)
exports('deleteAllTransactions', Functions.deleteAllTransactions)
