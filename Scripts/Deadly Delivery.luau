loadstring(game:HttpGet("https://github.com/RobloxTurboX/OpenSource/raw/refs/heads/main/Modules/ESP.luau"))()
local SomeShiSource = {}
SomeShiSource.ESP = _G.EModule

SomeShiSource.Entities = {
    {
        name = "Turkey",
        check = function(Ent)
            local body, rl = Ent.Body, Ent.RightLeg
            return body and body.ClassName == "UnionOperation" and rl and rl.ClassName == "UnionOperation"
        end
    },
    {
        name = "Floor Worm",
        check = function(Ent) return Ent.Y0 and Ent.RW end
    },
    {
        name = "Mimic",
        check = function(Ent) 
            return Ent.Humanoid and Ent.HumanoidRootPart and Ent.Checker and Ent.PlayerName ~= nil 
        end
    },
    {
        name = "Fake Fridge",
        check = function(Ent) return Ent["1C1"] and Ent["4C3"] and Ent["1C2"] end
    },
    {
        name = "Santa",
        check = function(Ent) return Ent.Interactable and Ent.bag and Ent:GetAttribute("en") end
    },
    {
        name = "Santa (ACTIVATED)",
        check = function(Ent) return Ent.Interactable and Ent.bag and not Ent:GetAttribute("en") end
    },
    {
        name = "Marrionete",
        check = function(Ent) return Ent.Waist1 and Ent.Waist2 end
    },
    {
        name = "Angry Cat",
        check = function(Ent) return Ent.HYTS and Ent.HYTX and Ent.HZTX end
    },
    {
        name = "Cat",
        check = function(Ent)
            return Ent.Tail and not (Ent.Folder and Ent.Folder.hEAD)
        end
    },
    {
        name = "Crocodile",
        check = function(Ent) return Ent.Bubble and Ent.Mouth end
    },
    {
        name = "Item Runner",
        check = function(Ent) return Ent.LeLower_Leg end
    },
    {
        name = "Rat",
        check = function(Ent) return Ent.ZED end
    },
    {
        name = "Demogorgon",
        check = function(Ent) return Ent.Feets end
    },
    {
        name = "Umbra",
        check = function(Ent)
            return Ent.Folder and Ent.Folder.TOR
        end
    },
    {
        name = "Guest666",
        check = function(Ent)
            return Ent.Tail and Ent.Folder and Ent.Folder.hEAD
        end
    },
    {
        name = "Burden",
        check = function(Ent) return Ent.QZTX and Ent.QZTS and Ent.QYTX end
    }
}

SomeShiSource.PrHide = {
	["Flashlight"] = true,
	["Bandage"] = true,
    ["Box"] = true,
    ["Bloxy Cola"] = true,
    ["Hourglass"] = true,
    ["Revive Syringe"] = true,
    ["Baseball Bat"] = true,
    ["Teleporter"] = true,
    ["Stun Grenade"] = true,
    ["Bio-Scanner"] = true,
    ["Z-Ray Gun"] = true,
	["The Trap"] = true
}

function SomeShiSource:Wat(Mod, types)
    if types == "E" then
        for _, idkhowtonamethisone in ipairs(self.Entities) do
            if idkhowtonamethisone.check(Mod) then
                return idkhowtonamethisone.name
            end
        end
    elseif types == "In" then
        if Mod.ClassName ~= "Model" then return nil end

        local Name = Mod.Name:match("^(.-)_") or Mod.Name
        if Name == "FridgeVFX" then return nil end

        local papka, Fuga, Enabed, ListInt = Mod.Folder, Mod:GetAttribute("Open"), Mod:GetAttribute("en"), {["Fridge"] = true, ["OilBucket"] = true, ["Cabinet"] = true, ["Crate"] = true, ["WoodenCabinet"] = true, ["WoodenBucket"] = true, ["LabCrate"] = true, ["LabBucket"] = true, ["LabCabinet"] = true}
        
        if not ListInt[Name] then return nil end

        local Looted = false

        if Name == "Fridge" then
            Looted = not Fuga and papka and papka.ICE
        elseif Name == "Crate" then
            Looted = not Fuga and papka and papka.pCylinder1 and Mod.Door
        elseif Name == "WoodenCabinet" then
            Looted = not Fuga and papka and papka.pCylinder10 and Mod.Door2 and Mod.Door1 and Mod["z5"] and Mod["z5"].Vent3
        elseif Name == "WoodenBucket" then
            Looted = not Fuga and papka ~= nil
        elseif Name == "Cabinet" then
            Looted = Enabed or (not Fuga and papka and papka.pCylinder10 and Mod.Door2 and Mod.Door1)
        elseif Name == "OilBucket" or Name == "LabCrate" or Name == "LabBucket" or Name == "LabCabinet" then
            Looted = not Fuga
        end

        if not Looted then
            return Name
        else
            return Name .. " (Looted)"
        end
    else
        if not Mod:IsA("Tool") and not Mod:IsA("Model") then return nil, nil, nil end
        if Mod.Folder and Mod.Folder.Interactable and Mod.Folder.Interactable.LootUI and Mod.Folder.Interactable.LootUI.Frame and Mod.Folder.Interactable.LootUI.Frame.ItemName and Mod.Folder.Interactable.LootUI.Frame.Price and Mod.Folder.Interactable.LootUI.Frame.Affix then
            local NameNi, Price, Buff = Mod.Folder.Interactable.LootUI.Frame.ItemName.Text:gsub("%s*%b()", ""):gsub("%s+$", ""), Mod.Folder.Interactable.LootUI.Frame.Price.Text, Mod.Folder.Interactable.LootUI.Frame.Affix.Text
            if Price == "failed to fetch text" then
                Price = ""
            end
            if Buff == "failed to fetch text" then
                Buff = ""
            end
            if self.PrHide[NameNi] then return "NotSlave", Mod.Folder.Interactable, NameNi else return "Slave", Mod.Folder.Interactable, {NameNi, Price, Buff} end
        else
            return nil, nil, nil
        end
    end
    return nil
end

SomeShiSource.ESP:CreateRenderFlow()

task.spawn(function()
    while SomeShiSource.ESP.Act do
        for _, Itme in pairs(game:GetService("Workspace").GameSystem.Loots.World:GetChildren()) do
            local ToolType, InterPart, Data = SomeShiSource:Wat(Itme,"I")
            if ToolType == "NotSlave" and InterPart and Data and type(Data) == "string" then
                SomeShiSource.ESP:CreateESP(InterPart,Data,Color3.fromRGB(255, 170, 0), "Items")
                SomeShiSource.ESP:UpdateESP(InterPart,Data,Color3.fromRGB(255, 170, 0))
            elseif ToolType == "Slave" and InterPart and Data and type(Data) == "table" then
                SomeShiSource.ESP:CreateESP(InterPart,Data[1] .. "\n" .. Data[2] .. "\n" .. Data[3],Color3.fromRGB(85, 0, 171), "Items")
                SomeShiSource.ESP:UpdateESP(InterPart,Data[1] .. "\n" .. Data[2] .. "\n" .. Data[3],Color3.fromRGB(85, 0, 171))
            end
        end
        for _, Intec in pairs(game:GetService("Workspace").GameSystem.InteractiveItem:GetChildren()) do
            local IntName, PrPart = SomeShiSource:Wat(Intec,"In"), Intec.PrimaryPart
            if IntName and PrPart then
                SomeShiSource.ESP:CreateESP(PrPart,IntName,Color3.fromRGB(255, 255, 255),"Interactable")
                SomeShiSource.ESP:UpdateESP(PrPart,IntName,nil)
            end
        end
        for _, Entity in pairs(game:GetService("Workspace").GameSystem.Monsters:GetChildren()) do
            local Unk, PrPart = SomeShiSource:Wat(Entity,"E"), Entity.PrimaryPart
            if Unk and PrPart then
                SomeShiSource.ESP:CreateESP(PrPart,Unk,Color3.fromRGB(252, 36, 3),"Entity")
                SomeShiSource.ESP:UpdateESP(PrPart,Unk,nil)
            end
        end
        for _, NPC in pairs(game:GetService("Workspace").GameSystem.NPCModels:GetChildren()) do
            if NPC.HumanoidRootPart then
                SomeShiSource.ESP:CreateESP(NPC.HumanoidRootPart,"Hostage",Color3.fromRGB(255, 3, 116),"NPC")
            end
        end
        task.wait()
    end
end)
