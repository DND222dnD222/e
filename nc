local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local noclipEnabled = false
local heartbeatConnection

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Parent = screenGui
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 1
frame.Position = UDim2.new(0.95, -110, 0, 10)
frame.Size = UDim2.new(0, 100, 0, 40)

local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Parent = frame
button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
button.BorderSizePixel = 0
button.Position = UDim2.new(0, 5, 0, 5)
button.Size = UDim2.new(1, -10, 1, -10)
button.Font = Enum.Font.SourceSansBold
button.Text = "Noclip: OFF"
button.TextColor3 = Color3.new(1, 0, 0)
button.TextSize = 14

-- Noclip Logic
local function onHeartbeat()
    -- This is the core of the noclip. It sets the player's position
    -- to where they *should* be, ignoring collisions.
    if noclipEnabled and rootPart and humanoid.MoveDirection.Magnitude > 0 then
        rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * humanoid.WalkSpeed * RunService.Heartbeat:Wait())
    end
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        -- Enable noclip
        heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
        humanoid:ChangeState(Enum.HumanoidStateType.Physics) -- Set state to physics for better control
        button.Text = "Noclip: ON"
        button.TextColor3 = Color3.new(0, 1, 0)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Noclip] Enabled";
            Color = Color3.new(0, 1, 0);
            Font = Enum.Font.SourceSansBold;
        })
    else
        -- Disable noclip
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- Reset state
        button.Text = "Noclip: OFF"
        button.TextColor3 = Color3.new(1, 0, 0)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Noclip] Disabled";
            Color = Color3.new(1, 0, 0);
            Font = Enum.Font.SourceSansBold;
        })
    end
end

-- Connect the toggle function to the button click
button.MouseButton1Click:Connect(toggleNoclip)

-- Also allow a keybind, for example 'N'
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
        toggleNoclip()
    end
end)
