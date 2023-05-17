local WantedBoosts = {
    ["Insane Luck"] = true,
    ["Super Breaker"] = false,
    ["Super Lucky"] = false,
    ["Triple Coins"] = false,
    ["Triple Damage"] = false,
}
local YourWebhook = "" -- [[ Enter your webook, or keep empty if you don't want to use a webhook ]]
local TeleportOnExpire = true -- [[ Will teleport you once your selected boosts expire ]]
local SecondsPerUpdate = 10 -- [[ How many seconds you'd like to wait before updating timers (Will only show notifications for "Insane Luck" and "Super Breaker" since the other boosts show bottom corner anyways) ]] 
 
repeat wait() until game:IsLoaded()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
local Library = require(ReplicatedStorage:WaitForChild("Library"))
Library.Load()
local Player = Players.LocalPlayer
local Notifications = {}
local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .."/servers/Public?sortOrder=Desc&limit=100"
Player:WaitForChild("__LOADED")
Player.PlayerGui:WaitForChild("GUIFX Holder")
 
task.wait(5)
local function CollectBoosts()
    local CollectedBoosts = {}
    
    for Boost, Data in pairs(Library.ServerBoosts.GetActiveBoosts()) do
        if WantedBoosts[Boost] then
            CollectedBoosts[Boost] = Data["totalTimeLeft"]
        end
    end
    return CollectedBoosts
end
 
local function toDHMS(s)
    return ("%i:%02i:%02i:%02i"):format(s/60^2/24, s/60^2, s/60%60, s%60)
end
 
local function ListServers(cursor)
    local Raw = game:HttpGet(Servers .. ((cursor and "&cursor="..cursor) or ""))
    return HttpService:JSONDecode(Raw)
end
 
local function Teleport()
    local Next; repeat
        local ServerList = ListServers(Next)
        for i,v in next, ServerList.data do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                local s,r = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, v.id, Player)
                if s then break end
            end
        end
 
        Next = ServerList.nextPageCursor
    until not Next
end
 
local function SendWebhook()
    if not YourWebhook or YourWebhook == "" then return end
    local CollectedBoosts = CollectBoosts()
    local fields = {}
    
    if next(CollectedBoosts) then
        for Boost, TimeLeft in pairs(CollectedBoosts) do
            table.insert(fields, {["name"] = "__"..Boost.."__", ["value"] = toDHMS(TimeLeft) })
        end
    end
    
    local ScriptString = "```game:GetService('TeleportService'):TeleportToPlaceInstance(" .. game.PlaceId .. ", '" .. game.JobId .. "', Player)```"
    
    table.insert(fields, {["name"] = "__Server Info__", ["value"] = "Place Id: `" .. game.PlaceId .. "` Job Id: `" .. game.JobId .. "`"})
    table.insert(fields, {["name"] = "__Teleport To Server Script__", ["value"] = ScriptString})
    
    local data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "**Boosts Finder**",
                ["type"] = "rich",
                ["color"] = tonumber(0x7269da),
                ["fields"] = fields
            }           
        }
    }
    
    local newdata = HttpService:JSONEncode(data)
 
    local headers = {
        ["content-type"] = "application/json"
    }
 
    (syn and syn.request or http_request or http.request) 
    {   
        Url = YourWebhook, 
        Method = "POST", 
        Headers = headers,
        Body = newdata,
    }
    
end
local function HandleNotifications()
    if #Notifications then
        for _, v in ipairs(Notifications) do
            v:delete()
        end
    end
    
    local CollectedBoosts = CollectBoosts()
    
    if next(CollectedBoosts) then
        for Boost, Time in pairs(CollectBoosts()) do
            if Boost == "Insane Luck" or Boost == "Super Breaker" then
                task.wait()
                table.insert(Notifications, Notification.new("message", Boost, toDHMS(Time)))
            end
        end
    end
end
 
local function UpdateUntilNoBoost()
    local CollectedBoosts = CollectBoosts()
    
    if not next(CollectedBoosts) then
        -- No boosts that we want
        if TeleportOnExpire then
            -- Teleport
            repeat
                task.spawn(Teleport)
                task.wait(5)
            until true == false
        end
    else
        HandleNotifications()
        task.wait(SecondsPerUpdate)
        UpdateUntilNoBoost()
    end
end
 
local function Start()
    local CollectedBoosts = CollectBoosts()
    
    if not next(CollectedBoosts) then
        repeat
            task.spawn(Teleport)
            task.wait(5)
        until true == false
    else
        SendWebhook()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Noob-Lol/Noob/main/auto%20lucky.lua"))()
        --your code here
        UpdateUntilNoBoost()
    end
end
 
Start()
