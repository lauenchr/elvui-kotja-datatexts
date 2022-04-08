local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local strjoin = strjoin
local GetArmorPenetration = GetArmorPenetration

local displayString, lastPanel = ''
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES
local ITEM_MOD_ARMOR_PENETRATION_RATING = ITEM_MOD_ARMOR_PENETRATION_RATING
local ARMORPEN = 'Armor Pen'

local armorPenValue

local function OnEvent(self)
	armorPenValue = GetArmorPenetration()
	self.text:SetFormattedText(displayString, ARMORPEN, armorPenValue)
	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s: ", hex, "%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext(ARMORPEN, STAT_CATEGORY_ATTRIBUTES, {"COMBAT_RATING_UPDATE"}, OnEvent, nil, nil, nil, nil, nil, nil, ValueColorUpdate)
