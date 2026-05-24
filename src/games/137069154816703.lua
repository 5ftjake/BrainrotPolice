-- hack vault for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()

    local plr = game:GetService("Players").LocalPlayer
    getgenv().FarmRots = false

    elements:Toggle("Farm Brainrots", section, function(v)
        if v then
            getgenv().FarmRots = true

            while getgenv().FarmRots do
                plr.Character:MoveTo(Vector3.new(-2494, 4, -726))
                task.wait(0.5)
                for _, br in pairs(workspace.EntitiesFolder:GetChildren()) do
                    if not br:GetAttribute("SpawnZone") == 22 or not br.PrimaryPart then
                        continue
                    end

                    plr.Character:MoveTo(br.PrimaryPart.Position)
                    task.wait()
                    repeat fireproximityprompt(br.PrimaryPart.TakeBrainrotPrompt) task.wait() until br.PrimaryPart:FindFirstChild("Attachment")
                    plr.Character:MoveTo(Vector3.new(77, 4, -729))
                    task.wait(1)
                end
            end
        else
            getgenv().FarmRots = false
        end
    end)
end
