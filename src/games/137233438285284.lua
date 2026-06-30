local Event = game:GetService("ReplicatedStorage").Paper.Remotes.__remoteevent
local depositAtMultiplier = true -- Toggle for deposit mode

-- Intercept the event and check for 1.5x multiplier
for _, Connection in getconnections(Event.OnClientEvent) do
    local old; old = hookfunction(Connection.Function, function(...)
        local args = {...}
        
        -- Check if this is the 1.5x multiplier event and if deposit mode is enabled
        if depositAtMultiplier and args[1] == "UI-Notification" and args[2] and args[2].Text then
            if args[2].Text == "Egg Multiplier rose to 1.5x!" then
                print("1.5x multiplier detected! Depositing eggs...")
                
                -- Just deposit the eggs (they're already collected)
                local mainFunction = game:GetService("ReplicatedStorage").Paper.Remotes.__remotefunction
                pcall(function()
                    mainFunction:InvokeServer("Deposit Eggs")
                    print("Eggs deposited at 1.5x multiplier!")
                end)
            end
        end
        
        print(`Intercepted (Connection) {Event.Name}.OnClientEvent`, ...)
        return old(...)
    end)
end

return function(section, data)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer

    env.Farming = false
    env.AutoBuy = false

    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farming = setdata.farming or false
    setdata.autoBuy = setdata.autoBuy or false
    setdata.depositMode = setdata.depositMode or true
    data[tostring(game.PlaceId)] = setdata
    writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode(data))

    local cashval = plr.PlayerGui.Main.Currencies.Cash.List.Amount

    local mainEvent = game:GetService("ReplicatedStorage").Paper.Remotes.__remoteevent
    local mainFunction = game:GetService("ReplicatedStorage").Paper.Remotes.__remotefunction
    local buyBtns = workspace.Plots[plr.Name].Buttons.BuyChickens

    local addedCon
    local buyLoop
    local farmLoop

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

    -- Create UI Elements - Make sure we're using the correct section
    local mainSection = section or "Main"
    
    elements:Label("BUY YOUR FIRST CHICKEN BEFORE AUTOFARMING (OTHERWISE WHOLE GAME BREAKS)")

    -- Toggle for deposit mode
    elements:Toggle("Deposit at 1.5x only", mainSection, setdata.depositMode, function(v)
        depositAtMultiplier = v
        setdata.depositMode = v
        data[tostring(game.PlaceId)] = setdata
        writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode(data))
        
        if v then
            print("Deposit mode: Only at 1.5x multiplier")
        else
            print("Deposit mode: Always deposit")
        end
    end)

    -- Autofarm Toggle
    elements:Toggle("Autofarm", mainSection, setdata.farming, function(v)
        env.setconfig("farmrots", v)
        env.Farming = v

        if not env.Farming then 
            if addedCon then addedCon:Disconnect() end
            if buyLoop then buyLoop:Disconnect() end
            if farmLoop then farmLoop:Disconnect() end
            return 
        end

        -- Initial collection of any existing eggs
        for i, v in pairs(workspace.Eggs:GetChildren()) do
            mainEvent:FireServer(
                "Collect Egg",
                v.Name
            )
            task.wait()
            v:Destroy()
        end

        task.wait()

        -- If deposit mode is OFF, deposit immediately
        if not depositAtMultiplier then
            mainFunction:InvokeServer("Deposit Eggs")
            print("Deposited eggs (always deposit mode)")
        end

        -- Collect eggs when they appear
        addedCon = workspace.Eggs.ChildAdded:Connect(function(c)
            task.wait(1)
            mainEvent:FireServer(
                "Collect Egg",
                c.Name
            )
            task.wait()
            c:Destroy()
            
            -- If deposit mode is OFF, deposit after each collection
            if not depositAtMultiplier then
                mainFunction:InvokeServer("Deposit Eggs")
                print("Deposited eggs (always deposit mode)")
            end
        end)

        -- Start loops
        startBuyLoop()
        startFarmingLoop()
    end)
    
    -- Auto Buy Chickens Toggle (separate from autofarm)
    elements:Toggle("Auto Buy Chickens", mainSection, setdata.autoBuy, function(v)
        env.AutoBuy = v
        setdata.autoBuy = v
        data[tostring(game.PlaceId)] = setdata
        writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode(data))
        
        if not v then
            if buyLoop then 
                buyLoop:Disconnect() 
                buyLoop = nil
            end
        elseif env.Farming then
            startBuyLoop()
        end
    end)
    
    -- Function to start the buy loop
    function startBuyLoop()
        if buyLoop then 
            buyLoop:Disconnect() 
            buyLoop = nil
        end
        
        buyLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if not env.Farming or not env.AutoBuy then return end
            
            pcall(function()
                local tobuy = 0
                local result = parseSuffixedNumber(cashval.Text)
                if parseSuffixedNumber(buyBtns.Buy100.Button.UI.Cost.Text) <= result then
                    tobuy = 100
                elseif parseSuffixedNumber(buyBtns.Buy25.Button.UI.Cost.Text) <= result then
                    tobuy = 25
                elseif parseSuffixedNumber(buyBtns.Buy5.Button.UI.Cost.Text) <= result then
                    tobuy = 5
                elseif parseSuffixedNumber(buyBtns.Buy1.Button.UI.Cost.Text) <= result then
                    tobuy = 1
                end
                
                if tobuy > 0 then
                    mainFunction:InvokeServer("Buy Chickens", tobuy)
                    task.wait()
                    mainFunction:InvokeServer("Merge Chickens")
                end
            end)
        end)
    end
    
    -- Function to start the farming loop
    function startFarmingLoop()
        if farmLoop then 
            farmLoop:Disconnect() 
            farmLoop = nil
        end
        
        farmLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if not env.Farming then return end
            
            pcall(function()
                mainFunction:InvokeServer("Collect Cash")
                task.wait()
                mainFunction:InvokeServer("Upgrade Process Level")
                task.wait(1)
            end)
        end)
    end
end
