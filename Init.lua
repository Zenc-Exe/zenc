getrenv().getos = function() return getdevice() end
getrenv().getplatform = function() return getos() end

getrenv().playanimation = function(animationId, player)
    runanimation(animationId, player)
end

getrenv().getlocalplayer = function(name)
  return not name and getplayers()["LocalPlayer"] or getplayers()[name]
end

getrenv().playanimation = function(animationId, player)
    runanimation(animationId, player)
end

getrenv().loaded = true
getrenv().isloaded = true
getrenv().isexecutorloaded = true

getrenv().getplayers = function()
  local players = {}
  for _, x in pairs(game:GetService("Players"):GetPlayers()) do
    players[x.Name] = x
  end
  players["LocalPlayer"] = game:GetService("Players").LocalPlayer
  return players
end

getrenv().getplayer = function(name)
  return not name and getplayers()["LocalPlayer"] or getplayers()[name]
end

getrenv().getfps = function()
    local rawfps = game:GetService("Stats").Workspace.Heartbeat:GetValue()
    local fpsnum = tonumber(rawfps)
    local fps = tostring(math.round(fpsnum))
    return not suffix and fps or fps.." fps"
end

getrenv().getdevice = function()
    local inputsrv = game:GetService("UserInputService")
        if inputsrv:GetPlatform() == Enum.Platform.Windows then
            return 'Windows'
        elseif inputsrv:GetPlatform() == Enum.Platform.OSX then
            return 'macOS'
        elseif inputsrv:GetPlatform() == Enum.Platform.IOS then
            return 'iOS'
        elseif inputsrv:GetPlatform() == Enum.Platform.UWP then
            return 'Windows (Microsoft Store)'
        elseif inputsrv:GetPlatform() == Enum.Platform.Android then
            return 'Android'
    else return 'Unknown'
    end
end

getrenv().runanimation = function(animationId, player)
    local plr = player or getplayer()
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. tostring(animationId)
        humanoid:LoadAnimation(animation):Play()
    end
end

getrenv().customprint = function(text: string, properties: table, imageId: rbxasset)
    print(text)
    task.wait(.025)
    local msg = game:GetService("CoreGui").DevConsoleMaster.DevConsoleWindow.DevConsoleUI:WaitForChild("MainView").ClientLog[tostring(#game:GetService("CoreGui").DevConsoleMaster.DevConsoleWindow.DevConsoleUI.MainView.ClientLog:GetChildren())-1].msg
    for i, x in pairs(properties) do
        msg[i] = x
    end
    if imageId then msg.Parent.image.Image = imageId end
end

getrenv().getping = function()
    local rawping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local pingstr = rawping:sub(1,#rawping-7)
    local pingnum = tonumber(pingstr)
    local ping = tostring(math.round(pingnum))
    return not suffix and ping or ping.." ms"
end
getrenv().queue_on_teleport = function(scripttoexec)
 local newTPService = {
  __index = function(self, key)
   if key == 'Teleport' then
    return function(gameId, player, teleportData, loadScreen)
      teleportData = {teleportData, MOREUNCSCRIPTQUEUE=scripttoexec}
      return oldGame:GetService("TeleportService"):Teleport(gameId, player, teleportData, loadScreen)
    end
   end
  end
 }
 local gameMeta = {
  __index = function(self, key)
    if key == 'GetService' then
     return function(name)
      if name == 'TeleportService' then return newTPService end
     end
    elseif key == 'TeleportService' then return newTPService end
    return game[key]
  end,
  __metatable = 'The metatable is protected'
 }
 getrenv().game = setmetatable({}, gameMeta)
end
getrenv().queueonteleport = function(scripttoexec)
  queue_on_teleport(scripttoexec)
end