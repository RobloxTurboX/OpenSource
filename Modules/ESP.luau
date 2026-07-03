EModule = {}
EModule.__index = EModule
EModule.WS = game:GetService("Workspace")

EModule.Config = {
    RenderSettings = {
        Type = "Regular" -- Regular/RunService
    },
    Text = {
        TextFont = Drawing.Fonts.SystemBold,
        DefColor = Color3.new(1,1,1),
        DefText = "SmthShit",
        ZIndex = -9e9
    }
}

EModule.Act = false
EModule.CActive = {}

function EModule:CreateESP(obj,text,color,type)
    if not self.Act then 
        self.Act = true
        local function Render()
            for adress, typee in pairs(self.CActive) do
                if not typee or not typee.Instance or not typee.Instance:IsDescendantOf(self.WS) then
                    self:DeleteESP("M",adress)
                    continue
                end
                local PosOnScreen = typee.Instance.Position
                if not PosOnScreen then 
                    self:DeleteESP("M",adress)
                    continue
                end
                local Vis, St = WorldToScreen(PosOnScreen)
                if St then
                    typee.ESP.Visible = true
                    typee.ESP.Position = Vis
                else
                    typee.ESP.Visible = false
                end
            end
        end
        if self.Config.RenderSettings.Type:lower() == "regular" then
            task.spawn(function()
                while self.Act do
                    Render()
                    task.wait()
                end
            end)
        elseif self.Config.RenderSettings.Type:lower() == "runservice" then
            task.spawn(function()
                self.RS = game:GetService("RunService").RenderStepped:Connect(function()
                    Render()
                end)
            end)
        end
    end
    if self.CActive[obj.Address] then return end
    local NotText = Drawing.new("Text")
    NotText.Outline = true
    NotText.Center = true
    NotText.Visible = true
    NotText.Color = color or self.Config.Text.DefColor
    NotText.Text = text or self.Config.Text.DefText
    NotText.Font = self.Config.Text.TextFont
    NotText.ZIndex = self.Config.Text.ZIndex
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
        for addrniha, Type in pairs(self.CActive) do
            if Type.Type == link then
                Type.ESP:Remove()
                Type.Instance = nil
                Type.Type = nil
                self.CActive[addrniha] = nil
            end
        end
        return
    end
end

function EModule:CreateRenderFlow()
    task.wait() -- I added ts to prevent scripts from getting error nil
end

function EModule:End()
    self.Act = false
    if self.RS then self.RS:Disconnect() end
    for addrniha, Type in pairs(self.CActive) do
        if Type.ESP then Type.ESP:Remove() end
        if Type.Instance then Type.Instance = nil end
        if Type.Type then Type.Type = nil end
        self.CActive[addrniha] = nil
    end
    self.CActive = {}
    EModule = nil
    _G.EModule = nil
end

_G.EModule = EModule
return EModule


--[[
    ESP Module Documentation(Docs Made with AI 😭🥀)
    ------------------------

    Quick start:

        loadstring(game:HttpGet("https://raw.githubusercontent.com/IceOfDeath/OpenSource/refs/heads/main/Modules/ESP.luau"))()
        local ESP = _G.EModule

        ESP:CreateRenderFlow()
        ESP:CreateESP(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            "Local Player",
            Color3.new(1, 1, 1),
            "Players"
        )


    Configuration:

        ESP.Config.RenderSettings.Type = "Regular"

            "Regular"    - updates ESP in a task loop with task.wait().
            "RunService" - updates ESP through RunService.RenderStepped.

        ESP.Config.Text.TextFont = Drawing.Fonts.SystemBold
        ESP.Config.Text.DefColor = Color3.new(1, 1, 1)
        ESP.Config.Text.DefText = "ESP"
        ESP.Config.Text.ZIndex = -9e9

            TextFont - default Drawing text font.
            DefColor - default text color when CreateESP color is not provided.
            DefText  - default label text when CreateESP text is not provided.
            ZIndex   - Drawing text render priority.


    Methods:

        ESP:CreateESP(object, text, color, espType)

            Creates a Drawing text label attached to a world object.
            The label follows object.Position while the object exists in Workspace.

            object  | Instance - target instance with a Position property.
            text    | string   - optional label text.
            color   | Color3   - optional label color.
            espType | string   - optional group name used for filtering/deleting.

            Example:

                ESP:CreateESP(workspace.Part, "Target", Color3.fromRGB(255, 80, 80), "Targets")


        ESP:UpdateESP(linked, text, color)

            Updates an existing ESP label.

            linked | Instance - the same instance used in CreateESP.
            text   | string   - optional new label text.
            color  | Color3   - optional new label color.

            Example:

                ESP:UpdateESP(workspace.Part, "Updated Target", Color3.fromRGB(80, 255, 80))


        ESP:DeleteESP(mode, link)

            Removes ESP labels.

            mode | string:
                "m" - manual delete by instance or instance address.
                "t" - delete every ESP label with the matching espType.

            link | Instance/string:
                When mode is "m", pass the target instance or its Address.
                When mode is "t", pass the espType string.

            Examples:

                ESP:DeleteESP("m", workspace.Part)
                ESP:DeleteESP("t", "Targets")


        ESP:End()

            Stops the renderer, removes every active ESP label, disconnects RenderStepped
            if it was used, clears the active ESP table, and removes _G.EModule.

            Example:

                ESP:End()


    Notes:

        - CreateESP ignores duplicate objects that are already registered.
        - Invalid or removed objects are cleaned up automatically during rendering.
        - The target object must have a Position property, such as BasePart.
]]--
