--[[
For a more in depth explanation and rundown of this script, I recommend you check out https://github.com/IcantAffordSynapse/BrainrotPolice
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end
local env = getgenv()

if not isfolder("BrainrotPolice") then makefolder("BrainrotPolice") end
if not isfile("BrainrotPolice/Config.json") then
    writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode({
        settings = {
            auto_rejoin_on_kick = false,
            disable_3d_rendering = false
        }
    }))
end

function env.import(id)
    return game:GetObjects(id)[1]
end

function env.getgitpath(where)
    local mainBuild = "https://raw.githubusercontent.com/IcantAffordSynapse/BrainrotPolice/refs/heads/main/"
    if where == "src" then
        return mainBuild .. "src/"
    elseif where == "games" then
        return mainBuild .. "src/games/"
    end
end

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if env.autorjjjj then
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

loadstring(game:HttpGet(getgitpath("src").."ui.lua"))()

if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/IcantAffordSynapse/BrainrotPolice/refs/heads/main/src/init.lua"))()')
end
