EModule = {}
EModule.__index = EModule
EModule.WS = game:GetService("Workspace")

EModule.Act = true
EModule.CActive = {}

function EModule:CESP(obj,text,color,type)
    if self.CActive[obj.Address] then return end
    local NotText = Drawing.new("Text")
    NotText.Outline = true
    NotText.Center = true
    NotText.Visible = true
    NotText.Color = color or Color3.new(1,1,1)
    NotText.Text = text or "SmthShit"
    self.CActive[obj.Address] = {
        Instance = obj,
        Type = type or "Default",
        ESP = NotText,
    }
end

function EModule:UESP(linked,text,color)
    if not self.CActive[linked.Address] then return end
    if text then self.CActive[linked.Address].ESP.Text = text end
    if color then self.CActive[linked.Address].ESP.Color = color end
end

function EModule:DESP(types, link)
    if types == "M" then
        local Tmp = (typeof(link) == "Instance") and link.Address or link
        if not Tmp then return end
        local Temp = self.CActive[Tmp]
        if not Temp then return end
        Temp.ESP:Remove()
        Temp.Instance = nil
        Temp.Type = nil
        self.CActive[Tmp] = nil
        return
    elseif types == "T" then
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

function EModule:RESP()
    task.spawn(function()
        while self.Act do
            for addressniha, typee in pairs(self.CActive) do
                if not typee or not typee.Instance or not typee.Instance:IsDescendantOf(self.WS) then
                    self:DESP("M",addressniha)
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
end

function EModule:Finish()
    self.Act = false
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
