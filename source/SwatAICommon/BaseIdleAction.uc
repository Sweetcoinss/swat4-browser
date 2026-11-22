class BaseIdleAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private IdleDefinition OurIdleDefinition;
var private bool bIsCurrentIdle;

overloaded function Construct(IdleDefinition IdleDefinition)
{
	assert(NotEqual_ObjectObject(IdleDefinition, none));
	OurIdleDefinition = IdleDefinition;
	return;
}

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 2);
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(2);
	return;
}

private function bool CanUseIdleBasedOnWeapon()
{
	if(NotEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(0)))
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(9)), EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none)))
		{
			return false;
		}
		else
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(1)), OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('MachineGun'))), m_pawn.GetActiveItem().IsA('G36kMG'))))
			{
				return false;
			}
			else
			{
				if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(2)), OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('G36kMG')))))
				{
					return false;
				}
				else
				{
					if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(3)), OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('SubMachineGun'))), m_pawn.GetActiveItem().IsA('UMP45SMG'))))
					{
						return false;
					}
					else
					{
						if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(4)), OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('UMP45SMG')))))
						{
							return false;
						}
						else
						{
							if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(5)), OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('Handgun')))))
							{
								return false;
							}
							else
							{
								if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(6)), OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('Shotgun')))))
								{
									return false;
								}
								else
								{
									if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(7)), OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('CSBallLauncher')))))
									{
										return false;
									}
									else
									{
										if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(8)), OrOr_BoolBool(EqualEqual_ObjectObject(m_pawn.GetActiveItem(), none), Not_PreBool(m_pawn.GetActiveItem().IsA('ThrownWeapon')))))
										{
											return false;
										}
										else
										{
											if(AndAnd_BoolBool(EqualEqual_IntInt(int(OurIdleDefinition.IdleWeaponStatus), int(10)), NotEqual_ObjectObject(m_pawn.GetActiveItem(), none)))
											{
												return false;
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return true;
	return;
}

private function bool CanUseIdleBasedOnState()
{
	if(EqualEqual_IntInt(int(OurIdleDefinition.IdleTime), int(2)))
	{
		return true;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatAI(m_pawn).GetUpperBodyAnimBehavior()), int(2)))
		{
			return EqualEqual_IntInt(int(OurIdleDefinition.IdleTime), int(1));
		}
		else
		{
			return EqualEqual_IntInt(int(OurIdleDefinition.IdleTime), int(0));
		}
	}
	return;
}

function bool CanUseIdleBasedOnAggression()
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	if(AndAnd_BoolBool(m_pawn.IsA('SwatAICharacter'), NotEqual_IntInt(int(OurIdleDefinition.IdleCharacterAggression), int(0))))
	{
		if(ISwatAI(m_pawn).IsAggressive())
		{
			return EqualEqual_IntInt(int(OurIdleDefinition.IdleCharacterAggression), int(2));
		}
		else
		{
			return EqualEqual_IntInt(int(OurIdleDefinition.IdleCharacterAggression), int(1));
		}
	}
	return true;
	return;
}

function bool CanUseIdleBasedOnPosition()
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	if(EqualEqual_IntInt(int(OurIdleDefinition.CharacterIdlePosition), int(0)))
	{
		return true;
	}
	else
	{
		if(m_pawn.bIsCrouched)
		{
			return EqualEqual_IntInt(int(OurIdleDefinition.CharacterIdlePosition), int(2));
		}
		else
		{
			return EqualEqual_IntInt(int(OurIdleDefinition.CharacterIdlePosition), int(1));
		}
	}
	return;
}

function bool CanUseIdleBasedOnCategory()
{
	local name CurrentIdleCategory;

	CurrentIdleCategory = ISwatAI(m_pawn).GetIdleCategory();
	if(NotEqual_NameName(OurIdleDefinition.IdleCategory, CurrentIdleCategory))
	{
		return false;
	}
	return true;
	return;
}

function bool AreResourcesAvailableToIdle(AI_Goal Goal)
{
	assert(false);
	return false;
	return;
}

function bool CanUseIdleAction()
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	if(Not_PreBool(CanUseIdleBasedOnWeapon()))
	{
		return false;
	}
	else
	{
		if(Not_PreBool(CanUseIdleBasedOnState()))
		{
			return false;
		}
		else
		{
			if(Not_PreBool(CanUseIdleBasedOnAggression()))
			{
				return false;
			}
			else
			{
				if(Not_PreBool(CanUseIdleBasedOnPosition()))
				{
					return false;
				}
				else
				{
					if(Not_PreBool(CanUseIdleBasedOnCategory()))
					{
						return false;
					}
				}
			}
		}
	}
	return Greater_FloatFloat(OurIdleDefinition.Weight, 0.0000000);
	return;
}

function float GetIdleWeight()
{
	return OurIdleDefinition.Weight;
	return;
}

function SetCurrentIdle(bool inIsCurrentIdle)
{
	bIsCurrentIdle = inIsCurrentIdle;
	return;
}

function float selectionHeuristic(AI_Goal Goal)
{
	local float Heuristic;

	assert(Goal.IsA('IdleGoal'));
	if(EqualEqual_ObjectObject(m_pawn, none))
	{
		m_pawn = AI_CharacterResource(Goal.resource).m_pawn;
		assert(NotEqual_ObjectObject(m_pawn, none));
	}
	if(AreResourcesAvailableToIdle(Goal))
	{
		if(Not_PreBool(ISwatAI(m_pawn).IsIdleCurrent()))
		{
			ISwatAI(m_pawn).ChooseIdle();
		}
		if(bIsCurrentIdle)
		{
			Heuristic = 1.0000000;
		}
	}
	return Heuristic;
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.IdleGoal'
}