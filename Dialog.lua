local xpcall = xpcall

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(func, ...)
	-- we check to see if the func is passed is actually a function here and don't error when it isn't
	-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
	-- present execution should continue without hinderance
	if type(func) == "function" then return xpcall(func, errorhandler, ...) end
end

local layoutrecursionblock = nil
local function safelayoutcall(object, func, ...)
	layoutrecursionblock = true
	object[func](object, ...)
	layoutrecursionblock = nil
end

function GuildJoinerator:DestroyMainWindow(widget)
	self.main_window_exists = false
	self.AceGUI:Release(widget)
end

function GuildJoinerator:MainWindow()
	-- This pattern used because GuildJoinerator:DestroyMainWindow() above
	-- doesn't *hide* the window, it *destroys* it.
	-- this hard-check prevents reconstructing what's already showing
	if self.main_window_exists == true then return end
	self.main_window_exists = true

	local window = self.AceGUI:Create("Window")
	window:SetTitle("Zdeyn's Guild Joinerator")
	window:SetCallback("OnClose", function(widget)
		self:DestroyMainWindow(widget)
	end)
	-- window:SetLayout("Flow")
	window:SetWidth(700)

	-- Add the frame as a global variable under the name `GuildJoineratorMainWindow`
	_G["GuildJoineratorMainWindow"] = window.frame
	-- Register the global variable `GuildJoineratorMainWindow` as a "special frame"
	-- so that it is closed when the escape key is pressed.
	tinsert(UISpecialFrames, "GuildJoineratorMainWindow")

	local frame = window.frame

	local heading = self.AceGUI:Create("Heading")
	heading:SetText("A big thankyou to " .. self.COLORS.HEIRLOOM .. "Knicks" .. self.COLORS.NORMAL ..
			                " for allowing this to happen!")
	heading:SetFullWidth(1)

	local label = self.AceGUI:Create("Label")
	label:SetFontObject(GameFontNormalLarge)
	label:SetJustifyH("CENTER")
	label:SetText("Choose your destination:")
	label:SetFullWidth(1)
	label:SetHeight(100)

	local editbox = self.AceGUI:Create("MultiLineEditBox")
	editbox:SetLabel("Log:")
	local log_string = "Empty!"
	editbox:SetText(log_string)
	editbox:SetFullWidth(1)
	editbox:SetNumLines(24)
	editbox:DisableButton(true)
	editbox:SetFocus()
	editbox:SetDisabled(true)
	-- editbox:SetCallback("OnTextChanged", function(widget, event, text)
	--	widget:SetText(log_string)
	-- end)

	local dropdown = self.AceGUI:Create("Dropdown")
	dropdown:SetList({[0] = "Assign me, please!", [1] = "Alpha", [2] = "Bravo", [3] = "Charlie"})
	dropdown:SetValue(0)
	--dropdown:SetText("Choose your destination")
	dropdown:SetCallback("OnValueChanged", function(self, event, key)
		print("Selected:", key)
		--[[ for k, v in pairs(key) do
			print(k, v)
		end ]]
	end)

	local button = self.AceGUI:Create("Button")
	button:SetText("Join")
	button:SetWidth(200)
	button:SetCallback("OnClick", function()
		print("Would be joining:", dropdown:GetValue())
	end)

	window:AddChild(heading)
	window:AddChild(label)
	window:AddChild(dropdown)
	window:AddChild(button)
	window:AddChild(editbox)

end