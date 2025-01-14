
modifier_huge_broodmother_accrue_children = class({})

--------------------------------------------------------------------------------

function modifier_huge_broodmother_accrue_children:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_accrue_children:OnCreated( kv )
	if IsServer() then
		self.babies_to_spawn = self:GetAbility():GetSpecialValueFor( "babies_to_spawn" )
	end
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_accrue_children:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_accrue_children:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		if hUnit == self:GetParent() then
			local hDummy = CreateUnitByName( "npc_dota_dummy_caster", self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
			if hDummy ~= nil then
				hDummy.nAmountToSpawn = self.babies_to_spawn
				hDummy.hInitialGoalEntity = self:GetParent():GetInitialGoalEntity()
				hDummy:AddAbility( "huge_broodmother_generate_children" ) -- the dummy is a creature and creatures auto-level their abilities

                 -- @UpdateModified Begin: fixed ability not being activate due to level 0
                 local ability = hDummy:FindAbilityByName("huge_broodmother_generate_children")
                 if (ability) then
                     ability:SetLevel(1)
                 end
                 -- @UpdateModified End
			end
		end
	end
end

--------------------------------------------------------------------------------
