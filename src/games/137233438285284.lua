local Event = game:GetService("ReplicatedStorage").Paper.Remotes.__remoteevent
local bestMultiplier = 0
local currentMultiplier = 1.0
local hasDepositedForCurrentMultiplier = false

-- Function to parse multiplier from event text
local function parseMultiplierFromText(text)
    local multiplier = text:match("([%d.]+)x")
    if multiplier then
        return tonumber(multiplier)
    end
    return nil
end

-- Intercept the event and track multiplier changes
for _, Connection in getconnections(Event.OnClientEvent) do
    local old; old = hookfunction(Connection.Function, function(...)
        local args = {...}
        
        -- Check if this is the multiplier event
        if args[1] == "UI-Notification" and args[2] and args[2].Text then
            local multiplier = parseMultiplierFromText(args[2].Text)
            if multiplier then
                currentMultiplier = multiplier
                
                -- Update best multiplier if this one is higher
                if multiplier > bestMultiplier then
                    bestMultiplier = multiplier
                    hasDepositedForCurrentMultiplier = false
                    print(`New best multiplier detected: {bestMultiplier}x`)
                    
                    -- Trigger deposit since this is the best multiplier so far
                    triggerDeposit()
                end
            end
        end
        
        print(`Intercepted (Connection) {Event.Name}.OnClientEvent`, ...)
        return old(...)
    end)
end

-- Function to trigger egg deposit
local function triggerDeposit()
    local mainFunction = game:GetService("ReplicatedStorage").Paper.Remotes.__remotefunction
    local mainEvent = game:GetService("ReplicatedStorage").Paper.Remotes.__remoteevent
    
    -- First collect all eggs
    for i, v in pairs(workspace.Eggs:GetChildren()) do
        pcall(function()
            mainEvent:FireServer("Collect Egg", v.Name)
            task.wait(0.1)
        end)
    end
    
    -- Then deposit them
    pcall(function()
        mainFunction:InvokeServer("Deposit Eggs")
        print(`Deposited eggs at {currentMultiplier}x multiplier (Best: {bestMultiplier}x)`)
    end)
    
    hasDepositedForCurrentMultiplier = true
end

return function(section, data)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer

    env.Farming = false

    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farming = setdata.farming or false
    data[tostring(game.PlaceId)] = setdata
    writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode(data))

    local cashval = plr.PlayerGui.Main.Currencies.Cash.List.Amount

    local mainEvent = game:GetService("ReplicatedStorage").Paper.Remotes.__remoteevent
    local mainFunction = game:GetService("ReplicatedStorage").Paper.Remotes.__remotefunction
    local buyBtns = workspace.Plots[plr.Name].Buttons.BuyChickens

    local addedCon

    local suffixes = {
        "K","M","B","T","Qd","Qn","Sx","Sp","Oc","No","De",
        "UDe","DDe","TDe","QdDe","QnDe","SxDe","SpDe","OcDe","NoDe","Vt",
        "UVt","DVt","TVt","QdVt","QnVt","SxVt","SpVt","OcVt","NoVt","Tg",
        "UTg","DTg","TTg","QdTg","QnTg","SxTg","SpTg","OcTg","NoTg","qg",
        "Uqg","Dqg","Tqg","Qdqg","Qnqg","Sxqg","Spqg","Ocqg","Noqg","Qg",
        "UQg","DQg","TQg","QdQg","QnQg","SxQg","SpQg","OcQg","NoQg","sg",
        "Usg","Dsg","Tsg","Qdsg","Qnsg","Sxsg","Spsg","Ocsg","Nosg","Sg",
        "USg","DSg","TSg","QdSg","QnSg","SxSg","SpSg","OcSg","NoSg","Og",
        "UOg","DOg","TOg","QdOg","QnOg","SxOg","SpOg","OcOg","NoOg","Ng",
        "UNg","DNg","TNg","QdNg","QnNg","SxNg","SpNg","OcNg","NoNg","Ce","UCe"
    }

    local suffixValue = {}
    for i, suf in ipairs(suffixes) do
        suffixValue[suf] = 1000 ^ i
    end

    local function parseSuffixedNumber(str)
        str = str:gsub("[%$,%s]", "")

        local numberPart, suffixPart = str:match("^(-?%d*%.?%d+)(%a*)$")

        local base = tonumber(numberPart)

        if suffixPart == "" then
            return base
        end

        local multiplier = suffixValue[suffixPart]

        return base * multiplier
    end

    local suffixValue = {}
    for i, suf in ipairs(suffixes) do
        suffixValue[suf] = 1000 ^ i
    end

    elements:Label("BUY YOUR FIRST CHICKEN BEFORE AUTOFARMING (OTHERWISE WHOLE GAME BREAKS)")

    elements:Toggle("Autofarm", section, setdata.farming, function(v)
        env.setconfig("farmrots", v)

        env.Farming = v

        if not env.Farming then 
            if addedCon then addedCon:Disconnect() end
            return 
        end

        -- Reset best multiplier tracking
        bestMultiplier = 0
        currentMultiplier = 1.0
        hasDepositedForCurrentMultiplier = false

        -- Initial deposit (in case there are eggs already)
        for i, v in pairs(workspace.Eggs:GetChildren()) do
            mainEvent:FireServer(
                "Collect Egg",
                v.Name
            )
            task.wait(0.1)
            v:Destroy()
        end

        task.wait()

        mainFunction:InvokeServer(
            "Deposit Eggs"
        )

        addedCon = workspace.Eggs.ChildAdded:Connect(function(c)
            task.wait(1)
            mainEvent:FireServer(
                "Collect Egg",
                c.Name
            )
            task.wait()
            c:Destroy()
            
            -- Only deposit if we haven't deposited for the current best multiplier yet
            if not hasDepositedForCurrentMultiplier and bestMultiplier > 0 then
                mainFunction:InvokeServer("Deposit Eggs")
                hasDepositedForCurrentMultiplier = true
                print(`Deposited at best multiplier: {bestMultiplier}x`)
            end
        end)

        while env.Farming do
            mainFunction:InvokeServer(
                "Collect Cash"
            )
            task.wait()
            mainFunction:InvokeServer(
                "Upgrade Process Level"
            )
            task.wait()
            local tobuy = 0
            local result = parseSuffixedNumber(cashval.Text)
            if parseSuffixedNumber(buyBtns.Buy100.Button.UI.Cost.Text) <= result  then
                tobuy = 100
            elseif parseSuffixedNumber(buyBtns.Buy25.Button.UI.Cost.Text) <= result then
                tobuy = 25
            elseif parseSuffixedNumber(buyBtns.Buy5.Button.UI.Cost.Text) <= result then
                tobuy = 5
            elseif parseSuffixedNumber(buyBtns.Buy1.Button.UI.Cost.Text) <= result then
                tobuy = 1
            end
            mainFunction:InvokeServer(
                "Buy Chickens",
                tobuy
            )
            task.wait()
            mainFunction:InvokeServer(
                "Merge Chickens"
            )
            task.wait(1)
        end
    end)
end
