-- fly for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()

    local plr = game:GetService("Players").LocalPlayer
    getgenv().Farming = false
    getgenv().FarmWings = false
    getgenv().AutoBest = false

    elements:Label("Auto rejoin on kick recommended. (Settings tab)")

    elements:Toggle("Farm Brainrots", section, function(v)
        if v then
            getgenv().Farming = true

            while getgenv().Farming do
                for _, v in pairs(workspace.Brainrots:GetChildren()) do
                    if v:GetAttribute("Rarity") ~= "ADMIN"
                    and v:GetAttribute("Rarity") ~= "Lucky"
                    and v:GetAttribute("Rarity") ~= "Ascendant"
                    and v:GetAttribute("Rarity") ~= "Transcendent"
                    and v:GetAttribute("Rarity") ~= "OG" then
                        continue
                    end

                    if v.PrimaryPart then
                        plr.Character:MoveTo(v.PrimaryPart.Position)
                        if v:FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart"):FindFirstChildOfClass("ProximityPrompt") then
                            repeat
                                fireproximityprompt(v:FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart"):FindFirstChildOfClass("ProximityPrompt"))
                                task.wait()
                            until not v or v.Parent ~= workspace.Brainrots
                            task.wait()
                            plr.Character:MoveTo(Vector3.new(7, 10, 44))
                            task.wait(0.25)
                        end
                    end
                end
                task.wait(0.1)
            end
        else
            getgenv().Farming = false
        end
    end)

    elements:Toggle("Auto Buy Speed", section, function(v)
        if v then
            getgenv().FarmWings = true

            while getgenv().FarmWings do
                local Event = game:GetService("ReplicatedStorage").Libraries.Packet.RemoteEvent
                Event:FireServer(
                    buffer.fromstring("\x15\x01")
                )
                task.wait()
            end
        else
            getgenv().FarmWings = false
        end
    end)

    elements:Toggle("Auto Equip Best", section, function(v)
        if v then
            getgenv().AutoBest = true

            while getgenv().AutoBest do
                local Event = game:GetService("ReplicatedStorage").Libraries.Packet.RemoteEvent
                Event:FireServer(
                    buffer.fromstring("\x0E")
                )
                task.wait(1)
            end
        else
            getgenv().AutoBest = false
        end
    end)
end
