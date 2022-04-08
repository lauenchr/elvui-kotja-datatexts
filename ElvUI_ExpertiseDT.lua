local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local strjoin = strjoin
local GetExpertise = GetExpertise
local GetExpertisePercent = GetExpertisePercent
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus

local displayString, lastPanel = ''
local STAT_EXPERTISE = STAT_EXPERTISE
local CR_EXPERTISE_TOOLTIP = CR_EXPERTISE_TOOLTIP
local CR_EXPERTISE = CR_EXPERTISE
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES

local mhExp, ohExp, mhExpPer, ohExpPer, expRating, expValue

local function OnEvent(self)
	mhExp, ohExp = GetExpertise()
	mhExpPer, ohExpPer = GetExpertisePercent()
	expRating = GetCombatRating(CR_EXPERTISE)
	expValue = GetCombatRatingBonus(CR_EXPERTISE)
	self.text:SetFormattedText(displayString, STAT_EXPERTISE, mhExp, ohExp)
	lastPanel = self
end

local function OnEnter()
	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(STAT_EXPERTISE, format('%d / %d', mhExp, ohExp), 1, 1, 1)
	DT.tooltip:AddLine(format(CR_EXPERTISE_TOOLTIP, format('%.2f / %.2f', mhExpPer, ohExpPer), expRating, expValue), nil, nil, nil, true)
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s: ", hex, "%d / %d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext(STAT_EXPERTISE, STAT_CATEGORY_ATTRIBUTES, {"COMBAT_RATING_UPDATE"}, OnEvent, nil, nil, OnEnter, nil, nil, nil, ValueColorUpdate)
