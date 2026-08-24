--========================================================
-- Mi 4K / ADMIN MENU
-- ПОЛНАЯ ВЕРСИЯ + FPS / PING
-- ЗАЩИТА ОТ ПОВТОРНОГО ЗАПУСКА
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================================================
-- ЗАЩИТА ОТ ПОВТОРНОГО ЗАПУСКА
--========================================================

local existingMenu = playerGui:FindFirstChild(
	"FinalMegaMenu4K_Fixed"
)

if existingMenu then
	existingMenu:Destroy()
end

--========================================================
-- НАСТРОЙКИ
--========================================================

local flySpeed = 50
local customWalkSpeed = 16
local customJumpPower = 50
local defaultWalkSpeed = 16
local defaultJumpPower = 50
local defaultJumpHeight = 7.2

--========================================================
-- СОСТОЯНИЯ
--========================================================

local isFlying = false
local isSpeedHackActive = false
local isJumpHackActive = false
local isNoclipActive = false
local isInfJumpActive = false
local isMinimized = false

--========================================================
-- FPS / PING НАСТРОЙКИ
--========================================================

local showPerformanceInfo = true
local showFPS = true
local showPing = true
local performancePosition = "default"

local currentFPS = 0
local currentPing = 0
local frameCounter = 0
local fpsElapsed = 0

--========================================================
-- ПЕРСОНАЖ
--========================================================

local character
local humanoid
local rootPart

local function updateCharacter()

	character = player.Character

	if not character then

		humanoid = nil
		rootPart = nil

		return
	end

	humanoid = character:FindFirstChildOfClass("Humanoid")
	rootPart = character:FindFirstChild("HumanoidRootPart")

end

updateCharacter()

player.CharacterAdded:Connect(function(newCharacter)

	character = newCharacter

	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")

	if humanoid then

		humanoid.PlatformStand = false
		humanoid.WalkSpeed = defaultWalkSpeed

		if humanoid.UseJumpPower then

			humanoid.JumpPower = defaultJumpPower

		else

			humanoid.JumpHeight = defaultJumpHeight

		end

	end

	isFlying = false
	isSpeedHackActive = false
	isJumpHackActive = false
	isNoclipActive = false
	isInfJumpActive = false

end)

--========================================================
-- SCREEN GUI
--========================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FinalMegaMenu4K_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

--========================================================
-- MAIN FRAME
--========================================================

local MainFrame = Instance.new("Frame")

MainFrame.Name = "MainFrame"

MainFrame.Size = UDim2.new(
	0,
	340,
	0,
	500
)

MainFrame.Position = UDim2.new(
	1,
	-360,
	0,
	20
)

MainFrame.BackgroundColor3 = Color3.fromRGB(
	20,
	20,
	20
)

MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")

MainCorner.CornerRadius = UDim.new(
	0,
	12
)

MainCorner.Parent = MainFrame

--========================================================
-- ВЕРХНЯЯ ПАНЕЛЬ
--========================================================

local Header = Instance.new("Frame")

Header.Name = "Header"

Header.Size = UDim2.new(
	1,
	0,
	0,
	50
)

Header.Position = UDim2.new(
	0,
	0,
	0,
	0
)

Header.BackgroundTransparency = 1
Header.Parent = MainFrame

--========================================================
-- TITLE
--========================================================

local Title = Instance.new("TextLabel")

Title.Name = "Title"

Title.Size = UDim2.new(
	1,
	-50,
	1,
	0
)

Title.Position = UDim2.new(
	0,
	5,
	0,
	0
)

Title.BackgroundTransparency = 1
Title.Text = "MI V2 Panel"

Title.TextColor3 = Color3.fromRGB(
	255,
	255,
	255
)

Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

--========================================================
-- КНОПКА МИНУС
--========================================================

local MinimizeBtn = Instance.new("TextButton")

MinimizeBtn.Name = "MinimizeButton"

MinimizeBtn.Size = UDim2.new(
	0,
	35,
	0,
	35
)

MinimizeBtn.Position = UDim2.new(
	1,
	-40,
	0,
	7
)

MinimizeBtn.BackgroundColor3 = Color3.fromRGB(
	45,
	45,
	45
)

MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "−"

MinimizeBtn.TextColor3 = Color3.fromRGB(
	255,
	255,
	255
)

MinimizeBtn.TextSize = 24
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")

MinimizeCorner.CornerRadius = UDim.new(
	0,
	8
)

MinimizeCorner.Parent = MinimizeBtn

--========================================================
-- SCROLL FRAME
--========================================================

local ScrollFrame = Instance.new("ScrollingFrame")

ScrollFrame.Name = "ScrollFrame"

ScrollFrame.Size = UDim2.new(
	1,
	-20,
	1,
	-60
)

ScrollFrame.Position = UDim2.new(
	0,
	10,
	0,
	55
)

ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 5

ScrollFrame.AutomaticCanvasSize =
	Enum.AutomaticSize.Y

ScrollFrame.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		0
	)

ScrollFrame.Parent = MainFrame

--========================================================
-- СПИСОК
--========================================================

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Padding = UDim.new(
	0,
	6
)

UIListLayout.HorizontalAlignment =
	Enum.HorizontalAlignment.Center

UIListLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

UIListLayout.Parent = ScrollFrame

--========================================================
-- КНОПКА
--========================================================

local function createButton(text, order, color)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(
		0,
		300,
		0,
		38
	)

	button.BackgroundColor3 = color
	button.BorderSizePixel = 0
	button.Text = text

	button.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	button.TextSize = 13
	button.Font = Enum.Font.GothamMedium
	button.LayoutOrder = order
	button.AutoButtonColor = false
	button.Selectable = true
	button.Parent = ScrollFrame

	local corner = Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(
			0,
			6
		)

	corner.Parent = button

	button.MouseEnter:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.1),
			{
				BackgroundColor3 =
					color:Lerp(
						Color3.fromRGB(
							255,
							255,
							255
						),
						0.2
					)
			}
		):Play()

	end)

	button.MouseLeave:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(0.1),
			{
				BackgroundColor3 = color
			}
		):Play()

	end)

	return button

end

--========================================================
-- TEXTBOX
--========================================================

local function createTextBox(
	placeholder,
	defaultText,
	order
)

	local box = Instance.new("TextBox")

	box.Size = UDim2.new(
		0,
		300,
		0,
		34
	)

	box.BackgroundColor3 =
		Color3.fromRGB(
			45,
			45,
			45
		)

	box.BorderSizePixel = 0
	box.Text = defaultText
	box.PlaceholderText = placeholder

	box.PlaceholderColor3 =
		Color3.fromRGB(
			160,
			160,
			160
		)

	box.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	box.TextSize = 13
	box.Font = Enum.Font.GothamMedium
	box.LayoutOrder = order
	box.ClearTextOnFocus = false
	box.Parent = ScrollFrame

	local corner = Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(
			0,
			6
		)

	corner.Parent = box

	return box

end

--========================================================
-- ЭЛЕМЕНТЫ МЕНЮ
--========================================================

local FlyBtn = createButton(
	"ВКЛЮЧИТЬ ПОЛЕТ",
	1,
	Color3.fromRGB(
		46,
		139,
		87
	)
)

local FlySpeedInput = createTextBox(
	"Скорость полета...",
	"50",
	2
)

local SpeedHackBtn = createButton(
	"ВКЛЮЧИТЬ СКОРОСТЬ ХОДЬБЫ",
	3,
	Color3.fromRGB(
		30,
		144,
		255
	)
)

local WalkSpeedInput = createTextBox(
	"Скорость ходьбы...",
	"16",
	4
)

local JumpHackBtn = createButton(
	"ВКЛЮЧИТЬ СУПЕР ПРЫЖОК",
	5,
	Color3.fromRGB(
		138,
		43,
		226
	)
)

local JumpPowerInput = createTextBox(
	"Сила прыжка...",
	"50",
	6
)

local NoclipBtn = createButton(
	"ВКЛЮЧИТЬ NOCLIP",
	7,
	Color3.fromRGB(
		218,
		165,
		32
	)
)

local InfJumpBtn = createButton(
	"ВКЛЮЧИТЬ БЕСКОНЕЧНЫЕ ПРЫЖКИ",
	8,
	Color3.fromRGB(
		72,
		61,
		139
	)
)

local CloseBtn = createButton(
	"ЗАКРЫТЬ И СБРОСИТЬ",
	9,
	Color3.fromRGB(
		178,
		34,
		34
	)
)

--========================================================
-- FPS / PING КНОПКИ
--========================================================

local PerformanceButton = createButton(
	"FPS / PING: ВКЛ",
	10,
	Color3.fromRGB(
		52,
		73,
		94
	)
)

local PerformanceSettingsButton = createButton(
	"НАСТРОЙКИ FPS / PING ▼",
	11,
	Color3.fromRGB(
		70,
		70,
		70
	)
)

--========================================================
-- FPS / PING ОТОБРАЖЕНИЕ
--========================================================

local PerformanceLabel = Instance.new("TextLabel")

PerformanceLabel.Name = "PerformanceInfo"

PerformanceLabel.Size = UDim2.new(
	0,
	190,
	0,
	58
)

PerformanceLabel.Position = UDim2.new(
	0,
	12,
	0,
	12
)

PerformanceLabel.BackgroundColor3 =
	Color3.fromRGB(
		15,
		15,
		15
	)

PerformanceLabel.BackgroundTransparency = 0.15
PerformanceLabel.BorderSizePixel = 0

PerformanceLabel.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

PerformanceLabel.TextSize = 16
PerformanceLabel.Font = Enum.Font.GothamBold

PerformanceLabel.TextXAlignment =
	Enum.TextXAlignment.Left

PerformanceLabel.TextYAlignment =
	Enum.TextYAlignment.Center

PerformanceLabel.Text =
	"FPS: --\nPing: --"

PerformanceLabel.Visible =
	showPerformanceInfo

PerformanceLabel.ZIndex = 100
PerformanceLabel.Parent = ScreenGui

local PerformanceCorner =
	Instance.new("UICorner")

PerformanceCorner.CornerRadius =
	UDim.new(
		0,
		10
	)

PerformanceCorner.Parent =
	PerformanceLabel

local PerformancePadding =
	Instance.new("UIPadding")

PerformancePadding.PaddingLeft =
	UDim.new(
		0,
		12
	)

PerformancePadding.Parent =
	PerformanceLabel

--========================================================
-- ЦЕНТРАЛЬНОЕ ОКНО НАСТРОЕК
--========================================================

local settingsOpen = false

local SettingsOverlay =
	Instance.new("Frame")

SettingsOverlay.Name =
	"PerformanceSettingsOverlay"

SettingsOverlay.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

SettingsOverlay.Position =
	UDim2.new(
		0,
		0,
		0,
		0
	)

SettingsOverlay.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

SettingsOverlay.BackgroundTransparency = 0.45
SettingsOverlay.BorderSizePixel = 0
SettingsOverlay.Visible = false
SettingsOverlay.ZIndex = 200
SettingsOverlay.Parent = ScreenGui

--========================================================
-- ПАНЕЛЬ НАСТРОЕК
--========================================================

local SettingsPanel =
	Instance.new("Frame")

SettingsPanel.Name =
	"PerformanceSettings"

SettingsPanel.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

SettingsPanel.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

SettingsPanel.Size =
	UDim2.new(
		0,
		340,
		0,
		395
	)

SettingsPanel.BackgroundColor3 =
	Color3.fromRGB(
		45,
		45,
		45
	)

SettingsPanel.BorderSizePixel = 0
SettingsPanel.ZIndex = 201
SettingsPanel.Parent = SettingsOverlay

local SettingsCorner =
	Instance.new("UICorner")

SettingsCorner.CornerRadius =
	UDim.new(
		0,
		14
	)

SettingsCorner.Parent =
	SettingsPanel

--========================================================
-- ЗАГОЛОВОК
--========================================================

local SettingsTitle =
	Instance.new("TextLabel")

SettingsTitle.Size =
	UDim2.new(
		1,
		-65,
		0,
		45
	)

SettingsTitle.Position =
	UDim2.new(
		0,
		15,
		0,
		5
	)

SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text =
	"НАСТРОЙКИ FPS / PING"

SettingsTitle.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

SettingsTitle.TextSize = 16
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextXAlignment =
	Enum.TextXAlignment.Left

SettingsTitle.ZIndex = 202
SettingsTitle.Parent = SettingsPanel

--========================================================
-- КРУГЛЫЙ КРЕСТИК
--========================================================

local SettingsCloseButton =
	Instance.new("TextButton")

SettingsCloseButton.Name =
	"SettingsCloseButton"

SettingsCloseButton.AnchorPoint =
	Vector2.new(
		1,
		0
	)

SettingsCloseButton.Position =
	UDim2.new(
		1,
		-10,
		0,
		10
	)

SettingsCloseButton.Size =
	UDim2.new(
		0,
		34,
		0,
		34
	)

SettingsCloseButton.BackgroundColor3 =
	Color3.fromRGB(
		65,
		65,
		65
	)

SettingsCloseButton.BorderSizePixel = 0
SettingsCloseButton.Text = "×"

SettingsCloseButton.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

SettingsCloseButton.TextSize = 22
SettingsCloseButton.Font = Enum.Font.GothamBold
SettingsCloseButton.ZIndex = 203
SettingsCloseButton.Parent = SettingsPanel

local SettingsCloseCorner =
	Instance.new("UICorner")

SettingsCloseCorner.CornerRadius =
	UDim.new(
		1,
		0
	)

SettingsCloseCorner.Parent =
	SettingsCloseButton

--========================================================
-- КОНТЕНТ НАСТРОЕК
--========================================================

local SettingsContent =
	Instance.new("ScrollingFrame")

SettingsContent.Name =
	"SettingsContent"

SettingsContent.Position =
	UDim2.new(
		0,
		15,
		0,
		55
	)

SettingsContent.Size =
	UDim2.new(
		1,
		-30,
		1,
		-70
	)

SettingsContent.BackgroundTransparency = 1
SettingsContent.BorderSizePixel = 0
SettingsContent.ScrollBarThickness = 4
SettingsContent.AutomaticCanvasSize =
	Enum.AutomaticSize.Y

SettingsContent.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		0
	)

SettingsContent.ZIndex = 202
SettingsContent.Parent = SettingsPanel

local SettingsLayout =
	Instance.new("UIListLayout")

SettingsLayout.Padding =
	UDim.new(
		0,
		6
	)

SettingsLayout.HorizontalAlignment =
	Enum.HorizontalAlignment.Center

SettingsLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

SettingsLayout.Parent =
	SettingsContent

--========================================================
-- КНОПКИ НАСТРОЕК
--========================================================

local function createSettingsButton(
	text,
	order
)

	local button =
		Instance.new("TextButton")

	button.Size =
		UDim2.new(
			1,
			-10,
			0,
			34
		)

	button.BackgroundColor3 =
		Color3.fromRGB(
			60,
			60,
			60
		)

	button.BorderSizePixel = 0
	button.Text = text

	button.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	button.TextSize = 12
	button.Font = Enum.Font.GothamMedium
	button.AutoButtonColor = true
	button.LayoutOrder = order
	button.ZIndex = 203
	button.Parent = SettingsContent

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(
			0,
			8
		)

	corner.Parent = button

	return button

end

--========================================================
-- РЕЖИМЫ FPS / PING
--========================================================

local OnlyBothButton =
	createSettingsButton(
		"FPS + Ping",
		1
	)

local OnlyFPSButton =
	createSettingsButton(
		"Только FPS",
		2
	)

local OnlyPingButton =
	createSettingsButton(
		"Только Ping",
		3
	)

--========================================================
-- ЗАГОЛОВОК ПОЛОЖЕНИЯ
--========================================================

local PositionTitle =
	Instance.new("TextLabel")

PositionTitle.Size =
	UDim2.new(
		1,
		-10,
		0,
		28
	)

PositionTitle.BackgroundTransparency = 1
PositionTitle.Text =
	"ПОЛОЖЕНИЕ FPS / PING:"

PositionTitle.TextColor3 =
	Color3.fromRGB(
		190,
		190,
		190
	)

PositionTitle.TextSize = 11
PositionTitle.Font = Enum.Font.GothamBold

PositionTitle.TextXAlignment =
	Enum.TextXAlignment.Left

PositionTitle.LayoutOrder = 4
PositionTitle.ZIndex = 203
PositionTitle.Parent = SettingsContent

--========================================================
-- ВСЕ ПОЛОЖЕНИЯ
--========================================================

local DefaultPositionButton =
	createSettingsButton(
		"По умолчанию",
		5
	)

local TopCenterButton =
	createSettingsButton(
		"Вверху по центру",
		6
	)

local TopLeftButton =
	createSettingsButton(
		"В левом верхнем углу",
		7
	)

local TopRightButton =
	createSettingsButton(
		"В правом верхнем углу",
		8
	)

local BottomLeftButton =
	createSettingsButton(
		"В левом нижнем углу",
		9
	)

local BottomRightButton =
	createSettingsButton(
		"В правом нижнем углу",
		10
	)

--========================================================
-- АДАПТАЦИЯ ОКНА ПОД ТЕЛЕФОН
--========================================================

local function updateSettingsDevice()

	local camera =
		workspace.CurrentCamera

	if not camera then
		return
	end

	local viewport =
		camera.ViewportSize

	if viewport.X < 500 then

		SettingsPanel.Size =
			UDim2.new(
				0.90,
				0,
				0,
				395
			)

	else

		SettingsPanel.Size =
			UDim2.new(
				0,
				340,
				0,
				395
			)

	end

end

--========================================================
-- ВВОД СКОРОСТИ ПОЛЕТА
--========================================================

FlySpeedInput.FocusLost:Connect(
	function()

		local value =
			tonumber(
				FlySpeedInput.Text
			)

		if value and value > 0 then

			flySpeed = value

		else

			FlySpeedInput.Text =
				tostring(flySpeed)

		end

	end
)

--========================================================
-- ВВОД СКОРОСТИ ХОДЬБЫ
--========================================================

WalkSpeedInput.FocusLost:Connect(
	function()

		local value =
			tonumber(
				WalkSpeedInput.Text
			)

		if value and value > 0 then

			customWalkSpeed = value

			if humanoid
				and isSpeedHackActive
			then

				humanoid.WalkSpeed =
					customWalkSpeed

			end

		else

			WalkSpeedInput.Text =
				tostring(
					customWalkSpeed
				)

		end

	end
)

--========================================================
-- ВВОД ПРЫЖКА
--========================================================

JumpPowerInput.FocusLost:Connect(
	function()

		local value =
			tonumber(
				JumpPowerInput.Text
			)

		if value and value > 0 then

			customJumpPower = value

			if humanoid
				and isJumpHackActive
			then

				if humanoid.UseJumpPower then

					humanoid.JumpPower =
						customJumpPower

				else

					humanoid.JumpHeight =
						customJumpPower / 2

				end

			end

		else

			JumpPowerInput.Text =
				tostring(
					customJumpPower
				)

		end

	end
)

--========================================================
-- ПОЛЕТ
--========================================================

local function toggleFly()

	updateCharacter()

	if not humanoid
		or not rootPart
	then
		return
	end

	isFlying = not isFlying

	if isFlying then

		FlyBtn.Text =
			"ВЫКЛЮЧИТЬ ПОЛЕТ"

		FlyBtn.BackgroundColor3 =
			Color3.fromRGB(
				139,
				0,
				0
			)

		humanoid.PlatformStand = true

		rootPart.AssemblyLinearVelocity =
			Vector3.zero

		rootPart.AssemblyAngularVelocity =
			Vector3.zero

	else

		FlyBtn.Text =
			"ВКЛЮЧИТЬ ПОЛЕТ"

		FlyBtn.BackgroundColor3 =
			Color3.fromRGB(
				46,
				139,
				87
			)

		humanoid.PlatformStand = false

	end

end

--========================================================
-- SPEED
--========================================================

local function toggleSpeedHack()

	updateCharacter()

	if not humanoid then
		return
	end

	isSpeedHackActive =
		not isSpeedHackActive

	if isSpeedHackActive then

		SpeedHackBtn.Text =
			"ВЫКЛЮЧИТЬ СКОРОСТЬ ХОДЬБЫ"

		SpeedHackBtn.BackgroundColor3 =
			Color3.fromRGB(
				139,
				0,
				0
			)

		humanoid.WalkSpeed =
			customWalkSpeed

	else

		SpeedHackBtn.Text =
			"ВКЛЮЧИТЬ СКОРОСТЬ ХОДЬБЫ"

		SpeedHackBtn.BackgroundColor3 =
			Color3.fromRGB(
				30,
				144,
				255
			)

		humanoid.WalkSpeed =
			defaultWalkSpeed

	end

end

--========================================================
-- JUMP
--========================================================

local function toggleJumpHack()

	updateCharacter()

	if not humanoid then
		return
	end

	isJumpHackActive =
		not isJumpHackActive

	if isJumpHackActive then

		JumpHackBtn.Text =
			"ВЫКЛЮЧИТЬ СУПЕР ПРЫЖОК"

		JumpHackBtn.BackgroundColor3 =
			Color3.fromRGB(
				139,
				0,
				0
			)

		if humanoid.UseJumpPower then

			humanoid.JumpPower =
				customJumpPower

		else

			humanoid.JumpHeight =
				customJumpPower / 2

		end

	else

		JumpHackBtn.Text =
			"ВКЛЮЧИТЬ СУПЕР ПРЫЖОК"

		JumpHackBtn.BackgroundColor3 =
			Color3.fromRGB(
				138,
				43,
				226
			)

		if humanoid.UseJumpPower then

			humanoid.JumpPower =
				defaultJumpPower

		else

			humanoid.JumpHeight =
				defaultJumpHeight

		end

	end

end

--========================================================
-- NOCLIP
--========================================================

local function toggleNoclip()

	isNoclipActive =
		not isNoclipActive

	if isNoclipActive then

		NoclipBtn.Text =
			"ВЫКЛЮЧИТЬ NOCLIP"

		NoclipBtn.BackgroundColor3 =
			Color3.fromRGB(
				139,
				0,
				0
			)

	else

		NoclipBtn.Text =
			"ВКЛЮЧИТЬ NOCLIP"

		NoclipBtn.BackgroundColor3 =
			Color3.fromRGB(
				218,
				165,
				32
			)

	end

end

--========================================================
-- INFINITE JUMP
--========================================================

local function toggleInfJump()

	isInfJumpActive =
		not isInfJumpActive

	if isInfJumpActive then

		InfJumpBtn.Text =
			"ВЫКЛЮЧИТЬ БЕСКОНЕЧНЫЕ ПРЫЖКИ"

		InfJumpBtn.BackgroundColor3 =
			Color3.fromRGB(
				139,
				0,
				0
			)

	else

		InfJumpBtn.Text =
			"ВКЛЮЧИТЬ БЕСКОНЕЧНЫЕ ПРЫЖКИ"

		InfJumpBtn.BackgroundColor3 =
			Color3.fromRGB(
				72,
				61,
				139
			)

	end

end

--========================================================
-- FPS / PING ТЕКСТ
--========================================================

local function updatePerformanceText()

	if not showPerformanceInfo then

		PerformanceLabel.Visible = false
		return

	end

	PerformanceLabel.Visible = true

	local text = ""

	if showFPS then

		text =
			text
			.. "FPS: "
			.. tostring(
				math.floor(
					currentFPS + 0.5
				)
			)

	end

	if showPing then

		if text ~= "" then
			text = text .. "\n"
		end

		text =
			text
			.. "Ping: "
			.. tostring(
				math.floor(
					currentPing + 0.5
				)
			)
			.. " ms"

	end

	if text == "" then

		text =
			"Информация выключена"

	end

	PerformanceLabel.Text =
		text

end

--========================================================
-- PING
--========================================================

local function updatePing()

	local success, ping =
		pcall(
			function()

				return player:GetNetworkPing() * 1000

			end
		)

	if success
		and typeof(ping) == "number"
	then

		currentPing = ping

	else

		currentPing = 0

	end

end

--========================================================
-- ПОЗИЦИЯ FPS / PING
--========================================================

local function updatePerformancePosition()

	if not workspace.CurrentCamera then
		return
	end

	if performancePosition == "default" then

		PerformanceLabel.AnchorPoint =
			Vector2.new(
				0,
				0
			)

		PerformanceLabel.Position =
			UDim2.new(
				0,
				12,
				0,
				12
			)

	elseif performancePosition == "topCenter" then

		PerformanceLabel.AnchorPoint =
			Vector2.new(
				0.5,
				0
			)

		PerformanceLabel.Position =
			UDim2.new(
				0.5,
				0,
				0,
				12
			)

	elseif performancePosition == "topLeft" then

		PerformanceLabel.AnchorPoint =
			Vector2.new(
				0,
				0
			)

		PerformanceLabel.Position =
			UDim2.new(
				0,
				12,
				0,
				12
			)

	elseif performancePosition == "topRight" then

		PerformanceLabel.AnchorPoint =
			Vector2.new(
				1,
				0
			)

		PerformanceLabel.Position =
			UDim2.new(
				1,
				-12,
				0,
				12
			)

	elseif performancePosition == "bottomLeft" then

		PerformanceLabel.AnchorPoint =
			Vector2.new(
				0,
				1
			)

		PerformanceLabel.Position =
			UDim2.new(
				0,
				12,
				1,
				-12
			)

	elseif performancePosition == "bottomRight" then

		PerformanceLabel.AnchorPoint =
			Vector2.new(
				1,
				1
			)

		PerformanceLabel.Position =
			UDim2.new(
				1,
				-12,
				1,
				-12
			)

	end

end

--========================================================
-- АДАПТАЦИЯ FPS / PING
--========================================================

local function updatePerformanceDevice()

	local camera =
		workspace.CurrentCamera

	if not camera then
		return
	end

	local viewport =
		camera.ViewportSize

	if viewport.X < 700 then

		PerformanceLabel.Size =
			UDim2.new(
				0,
				165,
				0,
				52
			)

		PerformanceLabel.TextSize = 14

	else

		PerformanceLabel.Size =
			UDim2.new(
				0,
				190,
				0,
				58
			)

		PerformanceLabel.TextSize = 16

	end

end

--========================================================
-- FPS / PING ЦИКЛ
--========================================================

RunService.RenderStepped:Connect(
	function(deltaTime)

		frameCounter += 1
		fpsElapsed += deltaTime

		if fpsElapsed >= 0.5 then

			currentFPS =
				frameCounter /
				fpsElapsed

			frameCounter = 0
			fpsElapsed = 0

			updatePing()
			updatePerformanceText()

		end

	end
)

--========================================================
-- FPS / PING ВКЛ / ВЫКЛ
--========================================================

PerformanceButton.MouseButton1Click:Connect(
	function()

		showPerformanceInfo =
			not showPerformanceInfo

		if showPerformanceInfo then

			PerformanceButton.Text =
				"FPS / PING: ВКЛ"

			PerformanceButton.BackgroundColor3 =
				Color3.fromRGB(
					46,
					139,
					87
				)

		else

			PerformanceButton.Text =
				"FPS / PING: ВЫКЛ"

			PerformanceButton.BackgroundColor3 =
				Color3.fromRGB(
					139,
					0,
					0
				)

		end

		updatePerformanceText()

	end
)

--========================================================
-- ОТКРЫТИЕ / ЗАКРЫТИЕ ЦЕНТРАЛЬНЫХ НАСТРОЕК
--========================================================

PerformanceSettingsButton.MouseButton1Click:Connect(
	function()

		settingsOpen =
			not settingsOpen

		if settingsOpen then

			PerformanceSettingsButton.Text =
				"НАСТРОЙКИ FPS / PING ▲"

			SettingsOverlay.Visible = true

			updateSettingsDevice()

		else

			PerformanceSettingsButton.Text =
				"НАСТРОЙКИ FPS / PING ▼"

			SettingsOverlay.Visible = false

		end

	end
)

--========================================================
-- ЗАКРЫТЬ КРЕСТИКОМ
--========================================================

SettingsCloseButton.MouseButton1Click:Connect(
	function()

		settingsOpen = false

		SettingsOverlay.Visible = false

		PerformanceSettingsButton.Text =
			"НАСТРОЙКИ FPS / PING ▼"

	end
)

--========================================================
-- FPS + PING
--========================================================

OnlyBothButton.MouseButton1Click:Connect(
	function()

		showFPS = true
		showPing = true

		updatePerformanceText()

	end
)

--========================================================
-- ТОЛЬКО FPS
--========================================================

OnlyFPSButton.MouseButton1Click:Connect(
	function()

		showFPS = true
		showPing = false

		updatePerformanceText()

	end
)

--========================================================
-- ТОЛЬКО PING
--========================================================

OnlyPingButton.MouseButton1Click:Connect(
	function()

		showFPS = false
		showPing = true

		updatePerformanceText()

	end
)

--========================================================
-- ПО УМОЛЧАНИЮ
--========================================================

DefaultPositionButton.MouseButton1Click:Connect(
	function()

		performancePosition =
			"default"

		updatePerformancePosition()

	end
)

--========================================================
-- ВВЕРХУ ПО ЦЕНТРУ
--========================================================

TopCenterButton.MouseButton1Click:Connect(
	function()

		performancePosition =
			"topCenter"

		updatePerformancePosition()

	end
)

--========================================================
-- В ЛЕВОМ ВЕРХНЕМ
--========================================================

TopLeftButton.MouseButton1Click:Connect(
	function()

		performancePosition =
			"topLeft"

		updatePerformancePosition()

	end
)

--========================================================
-- В ПРАВОМ ВЕРХНЕМ
--========================================================

TopRightButton.MouseButton1Click:Connect(
	function()

		performancePosition =
			"topRight"

		updatePerformancePosition()

	end
)

--========================================================
-- В ЛЕВОМ НИЖНЕМ
--========================================================

BottomLeftButton.MouseButton1Click:Connect(
	function()

		performancePosition =
			"bottomLeft"

		updatePerformancePosition()

	end
)

--========================================================
-- В ПРАВОМ НИЖНЕМ
--========================================================

BottomRightButton.MouseButton1Click:Connect(
	function()

		performancePosition =
			"bottomRight"

		updatePerformancePosition()

	end
)

--========================================================
-- СБРОС
--========================================================

local function resetEverything()

	isFlying = false
	isSpeedHackActive = false
	isJumpHackActive = false
	isNoclipActive = false
	isInfJumpActive = false

	updateCharacter()

	if character then

		for _, object in ipairs(
			character:GetDescendants()
		) do

			if object:IsA("BasePart") then

				if object.Name ==
					"HumanoidRootPart"
				then

					object.CanCollide = false

				else

					object.CanCollide = true

				end

			end

		end

	end

	if humanoid then

		humanoid.PlatformStand = false
		humanoid.WalkSpeed =
			defaultWalkSpeed

		if humanoid.UseJumpPower then

			humanoid.JumpPower =
				defaultJumpPower

		else

			humanoid.JumpHeight =
				defaultJumpHeight

		end

	end

	FlyBtn.Text =
		"ВКЛЮЧИТЬ ПОЛЕТ"

	FlyBtn.BackgroundColor3 =
		Color3.fromRGB(
			46,
			139,
			87
		)

	SpeedHackBtn.Text =
		"ВКЛЮЧИТЬ СКОРОСТЬ ХОДЬБЫ"

	SpeedHackBtn.BackgroundColor3 =
		Color3.fromRGB(
			30,
			144,
			255
		)

	JumpHackBtn.Text =
		"ВКЛЮЧИТЬ СУПЕР ПРЫЖОК"

	JumpHackBtn.BackgroundColor3 =
		Color3.fromRGB(
			138,
			43,
			226
		)

	NoclipBtn.Text =
		"ВКЛЮЧИТЬ NOCLIP"

	NoclipBtn.BackgroundColor3 =
		Color3.fromRGB(
			218,
			165,
			32
		)

	InfJumpBtn.Text =
		"ВКЛЮЧИТЬ БЕСКОНЕЧНЫЕ ПРЫЖКИ"

	InfJumpBtn.BackgroundColor3 =
		Color3.fromRGB(
			72,
			61,
			139
		)

end

--========================================================
-- ЗАКРЫТИЕ
--========================================================

local function closeMenu()

	resetEverything()

	if ScreenGui then

		ScreenGui:Destroy()

	end

end

--========================================================
-- КНОПКИ
--========================================================

FlyBtn.MouseButton1Click:Connect(
	toggleFly
)

SpeedHackBtn.MouseButton1Click:Connect(
	toggleSpeedHack
)

JumpHackBtn.MouseButton1Click:Connect(
	toggleJumpHack
)

NoclipBtn.MouseButton1Click:Connect(
	toggleNoclip
)

InfJumpBtn.MouseButton1Click:Connect(
	toggleInfJump
)

CloseBtn.MouseButton1Click:Connect(
	closeMenu
)

--========================================================
-- СВОРАЧИВАНИЕ
--========================================================

MinimizeBtn.MouseButton1Click:Connect(
	function()

		isMinimized =
			not isMinimized

		if isMinimized then

			ScrollFrame.Visible = false

			MainFrame.Size =
				UDim2.new(
					0,
					340,
					0,
					50
				)

			MinimizeBtn.Text = "+"

		else

			ScrollFrame.Visible = true

			MainFrame.Size =
				UDim2.new(
					0,
					340,
					0,
					500
				)

			MinimizeBtn.Text = "−"

		end

	end
)

--========================================================
-- ПЕРЕТАСКИВАНИЕ
--========================================================

local dragging = false
local dragStart = nil
local startPosition = nil
local dragInput = nil

Header.Active = true

Header.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch
		then

			dragging = true

			dragStart =
				input.Position

			startPosition =
				MainFrame.Position

			input.Changed:Connect(
				function()

					if input.UserInputState ==
						Enum.UserInputState.End
					then

						dragging = false

					end

				end
			)

		end

	end
)

Header.InputChanged:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseMovement
			or input.UserInputType ==
			Enum.UserInputType.Touch
		then

			dragInput = input

		end

	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if not dragging then
			return
		end

		if input == dragInput then

			local delta =
				input.Position -
				dragStart

			MainFrame.Position =
				UDim2.new(
					startPosition.X.Scale,
					startPosition.X.Offset +
						delta.X,
					startPosition.Y.Scale,
					startPosition.Y.Offset +
						delta.Y
				)

		end

	end
)

--========================================================
-- БЕСКОНЕЧНЫЙ ПРЫЖОК
--========================================================

UserInputService.JumpRequest:Connect(
	function()

		if not isInfJumpActive then
			return
		end

		updateCharacter()

		if humanoid then

			humanoid:ChangeState(
				Enum.HumanoidStateType.Jumping
			)

		end

	end
)

--========================================================
-- НАПРАВЛЕНИЕ ПОЛЕТА
--========================================================

local function getFlyDirection()

	local camera =
		workspace.CurrentCamera

	if not camera then
		return Vector3.zero
	end

	local direction =
		Vector3.zero

	if UserInputService:IsKeyDown(
		Enum.KeyCode.W
	) then

		direction +=
			camera.CFrame.LookVector

	end

	if UserInputService:IsKeyDown(
		Enum.KeyCode.S
	) then

		direction -=
			camera.CFrame.LookVector

	end

	if UserInputService:IsKeyDown(
		Enum.KeyCode.D
	) then

		direction +=
			camera.CFrame.RightVector

	end

	if UserInputService:IsKeyDown(
		Enum.KeyCode.A
	) then

		direction -=
			camera.CFrame.RightVector

	end

	if UserInputService:IsKeyDown(
		Enum.KeyCode.Space
	) then

		direction +=
			Vector3.yAxis

	end

	if UserInputService:IsKeyDown(
		Enum.KeyCode.LeftControl
	) then

		direction -=
			Vector3.yAxis

	end

	if direction.Magnitude > 0 then

		direction =
			direction.Unit

	end

	return direction

end

--========================================================
-- АВТОМАТИЧЕСКОЕ ОБНОВЛЕНИЕ
--========================================================

if workspace.CurrentCamera then

	workspace.CurrentCamera
		:GetPropertyChangedSignal(
			"ViewportSize"
		)
		:Connect(
			function()

				updatePerformancePosition()
				updatePerformanceDevice()
				updateSettingsDevice()

			end
		)

end

updatePerformancePosition()
updatePerformanceDevice()
updateSettingsDevice()

--========================================================
-- ГЛАВНЫЙ ЦИКЛ
--========================================================

RunService.RenderStepped:Connect(
	function()

		updateCharacter()

		if not character
			or not humanoid
			or not rootPart
		then

			return
		end

		--==================================================
		-- SPEED
		--==================================================

		if not isFlying then

			if isSpeedHackActive then

				humanoid.WalkSpeed =
					customWalkSpeed

			else

				humanoid.WalkSpeed =
					defaultWalkSpeed

			end

		end

		--==================================================
		-- JUMP
		--==================================================

		if isJumpHackActive then

			if humanoid.UseJumpPower then

				humanoid.JumpPower =
					customJumpPower

			else

				humanoid.JumpHeight =
					customJumpPower / 2

			end

		end

		--==================================================
		-- NOCLIP
		--==================================================

		if isNoclipActive
			or isFlying
		then

			for _, object in ipairs(
				character:GetDescendants()
			) do

				if object:IsA("BasePart") then

					object.CanCollide =
						false

				end

			end

		else

			for _, object in ipairs(
				character:GetDescendants()
			) do

				if object:IsA("BasePart") then

					if object.Name ==
						"HumanoidRootPart"
					then

						object.CanCollide =
							false

					else

						object.CanCollide =
							true

					end

				end

			end

		end

		--==================================================
		-- FLY
		--==================================================

		if isFlying then

			humanoid.PlatformStand = true

			local direction =
				getFlyDirection()

			rootPart.AssemblyLinearVelocity =
				direction * flySpeed

			rootPart.AssemblyAngularVelocity =
				Vector3.zero

			local camera =
				workspace.CurrentCamera

			if camera then

				local lookDirection =
					camera.CFrame.LookVector

				if lookDirection.Magnitude > 0 then

					rootPart.CFrame =
						CFrame.lookAt(
							rootPart.Position,
							rootPart.Position +
								lookDirection
						)

				end

			end

		else

			if humanoid.PlatformStand then

				humanoid.PlatformStand =
					false

			end

		end

	end
)

--========================================================
-- ГОТОВО
--========================================================