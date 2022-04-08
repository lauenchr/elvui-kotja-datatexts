local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local strjoin = strjoin
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local UnitLevel = UnitLevel
local UnitClass = UnitClass
local UnitAttackSpeed = UnitAttackSpeed
local GetTalentInfo = GetTalentInfo

local displayString, lastPanel = ""
local ITEM_MOD_HIT_MELEE_RATING_SHORT = ITEM_MOD_HIT_MELEE_RATING_SHORT
local CR_HIT_MELEE_TOOLTIP = CR_HIT_MELEE_TOOLTIP
local CR_HIT_MELEE = CR_HIT_MELEE
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES

local hitValue, hitPct, hitPctTalents, playerLevel, armPenValue

function GetHitTalentBonus()
	local _, class, _ = UnitClass("player")
    local mod = 0

    if class == "WARRIOR" then
        local _, _, _, _, points, _, _, _ = GetTalentInfo(2, 17)
        mod = points * 1 -- 0-3% Precision
    end

    if class == "HUNTER" then
        local _, _, _, _, points, _, _, _ = GetTalentInfo(3, 12)
        mod = points * 1 -- 0-3% Surefooted
    end

    if class == "SHAMAN" then
        local _, _, _, _, naturesGuidance, _, _, _ = GetTalentInfo(3, 6)
        mod = naturesGuidance * 1 -- 0-3% Nature"s Guidance

		local _, offHand = UnitAttackSpeed("player")
        if offhand ~= nil and offHand > 0 then
            local _, _, _, _, dualWielding, _, _, _ = GetTalentInfo(2, 17)
            mod = mod + dualWielding * 2 -- 0-6% Dual Wielding Specialization
        end
    end

    if class == "PALADIN" then
        local _, _, _, _, points, _, _, _ = GetTalentInfo(2, 3)
        mod = points * 1 -- 0-3% Precision
    end

    if class == "ROGUE" then
        local _, _, _, _, points, _, _, _ = GetTalentInfo(2, 6)
        mod = points * 1 -- 0-5% Precision
    end

    return mod
end


local function OnEvent(self)
	hitValue = GetCombatRating(CR_HIT_MELEE)
	hitPct = GetCombatRatingBonus(CR_HIT_MELEE)
	hitPctTalents = GetHitTalentBonus()
	playerLevel = UnitLevel("player")
	armorPenValue = GetArmorPenetration()
	self.text:SetFormattedText(displayString, ITEM_MOD_HIT_MELEE_RATING_SHORT, hitPct + hitPctTalents)
	lastPanel = self
end

local function OnEnter()
	local extendedTooltip = CR_HIT_MELEE_TOOLTIP

	if hitPctTalents > 0 then
		extendedTooltip = CR_HIT_MELEE_TOOLTIP:sub(1, 65) .. ", and an additional %d%% by talents." .. CR_HIT_MELEE_TOOLTIP:sub(66)
	end

	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(ITEM_MOD_HIT_MELEE_RATING_SHORT , format("%d", hitValue), 1, 1, 1)
	DT.tooltip:AddLine(format(extendedTooltip, playerLevel, hitPct, hitPctTalents, armorPenValue), nil, nil, nil, true)
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s: ", hex, "%.2f%%|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext(ITEM_MOD_HIT_MELEE_RATING_SHORT, STAT_CATEGORY_ATTRIBUTES, {"COMBAT_RATING_UPDATE"}, OnEvent, nil, nil, OnEnter, nil, nil, nil, ValueColorUpdate)
