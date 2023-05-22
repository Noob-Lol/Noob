--put in autoexec folder
--tp in lucky world for double egg farm
loadstring(game:HttpGet("https://raw.githubusercontent.com/Noob-Lol/Noob/main/rafa.lua"))()
if game.PlaceId ==  6284583030 then
	print("normal")
	local pos = game.Players.LocalPlayer.Character.HumanoidRootPart
	pos.CFrame = CFrame.new(-72,130,1366)
	pos = nil
elseif game.PlaceId ==  10321372166 then
	print("hardcore")
end
local c =game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Chat"):FindFirstChildWhichIsA("Frame");c.Active = true;c.Draggable=false
local ChatSettings = require(game:GetService("Chat").ClientChatModules.ChatSettings)
ChatSettings.WindowResizable = true --chat resize
c = nil
game.NetworkClient.ChildRemoved:Connect(function() --reconect if disconnected
	game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)
local memory = nil
function MemoryCheck()
	while true do
	memory = game:GetService("Stats"):GetTotalMemoryUsageMb()
	if memory >= 3200 then --rejoin oh high memory
	game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
	wait(10)
	else
	memory = nil
	wait(20)
	end
    end
end
local Check = coroutine.wrap(MemoryCheck)
Check()
