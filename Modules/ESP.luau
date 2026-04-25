EModule = {}
EModule.__index = EModule
EModule.WS = game:GetService("Workspace")

EModule.Config = {
    RenderSettings = {
        Type = "Regular" -- Regular/RunService
    },
    TextFont = Drawing.Fonts.SystemBold,
    DefColor = Color3.new(1,1,1),
    DefText = "SmthShit"

}

EModule.Act = false
EModule.CActive = {}

function EModule:CreateESP(obj,text,color,type)
    if self.CActive[obj.Address] then return end
    local NotText = Drawing.new("Text")
    NotText.Outline = true
    NotText.Center = true
    NotText.Visible = true
    NotText.Color = color or self.Config.DefColor
    NotText.Text = text or self.Config.DefText
    NotText.Font = self.Config.TextFont
    self.CActive[obj.Address] = {
        Instance = obj,
        Type = type or "Default",
        ESP = NotText
    }
end

function EModule:UpdateESP(linked,text,color)
    if not self.CActive[linked.Address] then return end
    if text then self.CActive[linked.Address].ESP.Text = text end
    if color then self.CActive[linked.Address].ESP.Color = color end
end

function EModule:DeleteESP(types, link)
    if types:lower() == "m" then
        local Tmp = (typeof(link) == "Instance") and link.Address or link
        if not Tmp then return end
        local Temp = self.CActive[Tmp]
        if not Temp then return end
        Temp.ESP:Remove()
        Temp.Instance = nil
        Temp.Type = nil
        self.CActive[Tmp] = nil
        return
    elseif types:lower() == "t" then
        for addr, Type in pairs(self.CActive) do
            if Type.Type == link then
                Type.ESP:Remove()
                Type.Instance = nil
                Type.Type = nil
                self.CActive[addr] = nil
            end
        end
        return
    end
end

function EModule:CreateRenderFlow()
    if self.Config.RenderSettings.Type:lower() == "regular" then
        task.spawn(function()
            if not EModule.Act then EModule.Act = true end
            EModule.Btr = os.clock()
            while self.Act do
                for addressniha, typee in pairs(self.CActive) do
                    if not typee or not typee.Instance or not typee.Instance:IsDescendantOf(self.WS) then
                        self:DeleteESP("M",addressniha)
                        continue
                    end
                    local Vis, St = WorldToScreen(typee.Instance.Position)
                    if St then
                        typee.ESP.Visible = true
                        typee.ESP.Position = Vis
                    else
                        typee.ESP.Visible = false
                    end
                end
                task.wait()
            end
        end)
    elseif self.Config.RenderSettings.Type:lower() == "runservice" then
        task.spawn(function()
            if not EModule.Act then EModule.Act = true end
            self.RS = game:GetService("RunService").RenderStepped:Connect(function()
                for addressniha, typee in pairs(self.CActive) do
                    if not typee or not typee.Instance or not typee.Instance:IsDescendantOf(self.WS) then
                        self:DeleteESP("M",addressniha)
                        continue
                    end
                    local Vis, St = WorldToScreen(typee.Instance.Position)
                    if St then
                        typee.ESP.Visible = true
                        typee.ESP.Position = Vis
                    else
                        typee.ESP.Visible = false
                    end
                end
            end)
        end)
    end
end

function EModule:End()
    self.Act = false
    if self.RS then self.RS:Disconnect() end
    for addr, Type in pairs(self.CActive) do
        if Type.ESP then Type.ESP:Remove() end
        if Type.Instance then Type.Instance = nil end
        if Type.Type then Type.Type = nil end
        self.CActive[addr] = nil
    end
    self.CActive = {}
end

_G.EModule = EModule
return EModule
