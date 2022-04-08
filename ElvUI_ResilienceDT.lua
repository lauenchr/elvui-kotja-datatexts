local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local strjoin = strjoin
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus

local displayString, lastPanel = ''
local STAT_RESILIENCE = STAT_RESILIENCE
local RESILIENCE_TOOLTIP = RESILIENCE_TOOLTIP
local CR_RESILIENCE_CRIT_TAKEN  = CR_RESILIENCE_CRIT_TAKEN
local CR_RESILIENCE_PLAYER_DAMAGE_TAKEN = CR_RESILIENCE_PLAYER_DAMAGE_TAKEN 
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES

local resValue, resCritValue, resCritDmgValue, resCapHit
local resCapValue = 492.5

local function OnEvent(self)
	resValue = GetCombatRating(CR_RESILIENCE_CRIT_TAKEN)
	
	-- Resilience Cap
	resCapHit = resValue > resCapValue
	
	resCritValue = GetCombatRatingBonus(CR_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	resCritDmgValue = GetCombatRatingBonus(CR_RESILIENCE_CRIT_TAKEN)
	
	self.text:SetFormattedText(displayString, STAT_RESILIENCE, resValue)
	lastPanel = self
end

local function OnEnter()
	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(STAT_RESILIENCE, format('%d', resValue), 1, 1, 1)
	
	if resCapHit then
		DT.tooltip:AddLine(format("YOU HIT THE RES CAP OF %d!", resCapValue), nil, nil, nil, true)
	end
	
	DT.tooltip:AddLine(format(RESILIENCE_TOOLTIP, resCritValue, resCritDmgValue), nil, nil, nil, true)
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s: ", hex, "%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext(STAT_RESILIENCE, STAT_CATEGORY_ATTRIBUTES, {"COMBAT_RATING_UPDATE"}, OnEvent, nil, nil, OnEnter, nil, nil, nil, ValueColorUpdate)
