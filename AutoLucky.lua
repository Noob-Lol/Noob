--put in autoexec folder
--tp in lucky world for double egg farm
loadstring(game:HttpGet("https://raw.githubusercontent.com/Noob-Lol/Noob/main/rafa.lua"))()
local pos = game.Players.LocalPlayer.Character.HumanoidRootPart
pos.CFrame = CFrame.new(-72,130,1366) 
local c =game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Chat"):FindFirstChildWhichIsA("Frame");c.Active = true;c.Draggable=false
local ChatSettings = require(game:GetService("Chat").ClientChatModules.ChatSettings)
ChatSettings.WindowResizable = true --chat resize
pos = nil
c = nil
game.NetworkClient.ChildRemoved:Connect(function() --reconect if disconnected
   game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)
local memory = nil
while true do
	memory = game:GetService("Stats"):GetTotalMemoryUsageMb()
	if memory >= 3100 then break --rejoin oh high memory
	else
	memory = nil
	wait(20)
	end
end 
game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
