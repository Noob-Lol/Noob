--put in autoexec folder
--tp in lucky world for double egg farm
loadstring(game:HttpGet("https://raw.githubusercontent.com/Noob-Lol/Noob/main/rafa.lua"))()
task.wait(1)
CurrentWorld = save.World
if Current world == "Lucky Block World" then
	local pos = game.Players.LocalPlayer.Character.HumanoidRootPart
	pos.CFrame = CFrame.new(-72,130,1366) 
else
	print("wrong world")
game.NetworkClient.ChildRemoved:Connect(function() --reconect if disconnected
   game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)
local memory = game:GetService("Stats"):GetTotalMemoryUsageMb()
while true do
	memory = game:GetService("Stats"):GetTotalMemoryUsageMb()
	if memory >= 3100 then break --rejoin oh high memory
	else
	wait(20)
	end
end 
game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
