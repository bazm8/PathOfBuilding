-- Path of Building
--
-- Class: Control Host
-- Host for UI controls
--

local ControlHostClass = common.NewClass("ControlHost", function(self)
	self.controls = { }
end)

function ControlHostClass:SelectControl(newSelControl)
	if self.selControl == newSelControl then
		return
	end
	if self.selControl then
		self.selControl:SetFocus(false)
	end
	self.selControl = newSelControl
	if self.selControl then
		self.selControl:SetFocus(true)
	end
end

function ControlHostClass:GetMouseOverControl()
	for _, control in pairs(self.controls) do
		if control.IsMouseOver and control:IsMouseOver() then
			return control
		end
	end
end

function ControlHostClass:ProcessControlsInput(inputEvents)
	for id, event in ipairs(inputEvents) do
		if event.type == "KeyDown" then
			if self.selControl then
				self:SelectControl(self.selControl:OnKeyDown(event.key, event.doubleClick))
				inputEvents[id] = nil
			end
			if not self.selControl and event.key:match("BUTTON") then
				self:SelectControl()
				local mOverControl = self:GetMouseOverControl()
				if mOverControl and mOverControl.OnKeyDown then
					self:SelectControl(mOverControl:OnKeyDown(event.key, event.doubleClick))
					inputEvents[id] = nil
				end
			end
		elseif event.type == "KeyUp" then
			if self.selControl then
				if self.selControl.OnKeyUp then
					self:SelectControl(self.selControl:OnKeyUp(event.key))
				end
				inputEvents[id] = nil
			else
				local mOverControl = self:GetMouseOverControl()
				if mOverControl and mOverControl.OnKeyUp then
					mOverControl:OnKeyUp(event.key)
					inputEvents[id] = nil
				end
			end
		elseif event.type == "Char" then
			if self.selControl then
				if self.selControl.OnChar then
					self:SelectControl(self.selControl:OnChar(event.key))
				end
				inputEvents[id] = nil
			end
		end
	end	
end

function ControlHostClass:DrawControls(...)
	for _, control in pairs(self.controls) do
		if control:IsShown() then
			control:Draw(...)
		end
	end
end
