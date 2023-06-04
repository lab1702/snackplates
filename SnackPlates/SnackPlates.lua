--The most simple way I can think of to get threat plates.
--Minimal changes, just changing color on blizz bars.

local playerIsTank = function()
	return GetSpecializationRole(GetSpecialization()) == "TANK"
end

local isTank = function(t)
	return UnitGroupRolesAssigned(t) == "TANK"
end

local isOfftanked = function(frame)
	local t2 = frame.displayedUnit.."target"

	if UnitPlayerOrPetInRaid(t2) or UnitPlayerOrPetInParty(t2) then
		if not UnitIsUnit("player", t2) and isTank(t2) and playerIsTank() then
			return true
		end
	end

	return false
end

local threatColor = function(s)
	if playerIsTank() then
		if s == 0 then
			return 1.0, 0.0, 0.0
		elseif s == 1 then
			return 1.0, 0.5, 0.0
		elseif s == 2 then
			return 1.0, 1.0, 0.0
		else
			return 0.0, 1.0, 0.0
		end
	else
		if s == 0 then
			return 0.0, 1.0, 0.0
		elseif s == 1 then
			return 1.0, 1.0, 0.0
		elseif s == 2 then
			return 1.0, 0.5, 0.0
		else
			return 1.0, 0.0, 0.0
		end
	end
end

hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
	local r, g, b

	if frame == nil then
		return
	elseif frame.displayedUnit == nil then
		return
	elseif C_NamePlate.GetNamePlateForUnit(frame.unit) == C_NamePlate.GetNamePlateForUnit("player") then
		return
	elseif UnitIsPlayer(frame.displayedUnit) or (not UnitIsConnected(frame.displayedUnit)) then
		return
	elseif CompactUnitFrame_IsTapDenied(frame) then
		r, g, b = 0.1, 0.1, 0.1
	elseif CompactUnitFrame_IsOnThreatListWithPlayer(frame.displayedUnit) then
		local s = UnitThreatSituation("player", frame.displayedUnit)

		if isOfftanked(frame) then
			if s > 0 then
				r, g, b = 1.0, 0.5, 1.0
			else
				r, g, b = 0.0, 0.5, 1.0
			end
		else
			r, g, b = threatColor(s)
		end
	elseif isOfftanked(frame) then
		r, g, b = 0.0, 0.5, 1.0
	else
		r, g, b = UnitSelectionColor(frame.displayedUnit)
	end

	frame.healthBar:SetStatusBarColor(r, g, b)
end)
