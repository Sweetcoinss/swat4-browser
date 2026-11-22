class DoorBufferVolume extends Volume
	native
	config
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var private SwatDoor AssociatedDoor;
var array<SwatPlayer> PlayersToRepulse;

simulated function EnableRepulsion()
{
	local SwatPlayer SwatPlayer;

	if(ShouldRepulse())
	{
		SetCollision(true, false, false);
		PlayersToRepulse.Remove(0, PlayersToRepulse.Length);
		assert(EqualEqual_IntInt(PlayersToRepulse.Length, 0));
		foreach TouchingActors(Class'SwatGame.SwatPlayer', SwatPlayer)
		{
			PlayersToRepulse.Insert(PlayersToRepulse.Length, 1);
			PlayersToRepulse[Subtract_IntInt(PlayersToRepulse.Length, 1)] = SwatPlayer;
		}
		if(ShouldBlock())
		{
			SetCollision(true, false, true);
			bBlockZeroExtentTraces = true;
		}
	}
	return;
}

simulated function DisableRepulsion()
{
	SetCollision(false, false, false);
	bBlockZeroExtentTraces = false;
	return;
}

simulated event Tick(float DeltaSeconds)
{
	local int i, j;
	local bool isPlayerInBothArrays;
	local SwatPlayer SwatPlayer;
	local array<SwatPlayer> TouchingPlayers;
	local Vector DoorDirection, DoorDirectionPerpendicular, PushDirection;

	super(Actor).Tick(DeltaSeconds);
	if(ShouldRepulse())
	{
		DoorDirection = Vector(AssociatedDoor.Rotation);
		DoorDirectionPerpendicular.X = DoorDirection.Y;
		DoorDirectionPerpendicular.Y = Subtract_PreFloat(DoorDirection.X);
		DoorDirectionPerpendicular.Z = 0.0000000;
		TouchingPlayers.Remove(0, TouchingPlayers.Length);
		assert(EqualEqual_IntInt(TouchingPlayers.Length, 0));
		foreach TouchingActors(Class'SwatGame.SwatPlayer', SwatPlayer)
		{
			TouchingPlayers.Insert(TouchingPlayers.Length, 1);
			TouchingPlayers[Subtract_IntInt(TouchingPlayers.Length, 1)] = SwatPlayer;
		}
		i = 0;
		J0xBA:

		if(Less_IntInt(i, PlayersToRepulse.Length))
		{
			SwatPlayer = PlayersToRepulse[i];
			isPlayerInBothArrays = false;
			j = 0;
			J0xEA:

			if(Less_IntInt(j, TouchingPlayers.Length))
			{
				if(EqualEqual_ObjectObject(SwatPlayer, TouchingPlayers[j]))
				{
					isPlayerInBothArrays = true;
					// [Explicit Break]
					goto J0x124;
				}
				AddAdd_PreInt(j);
				// [Loop Continue]
				goto J0xEA;
			}
			J0x124:

			if(Not_PreBool(isPlayerInBothArrays))
			{
				PlayersToRepulse.Remove(i, 1);
				// [Explicit Continue]
				goto J0x19C;
			}
			if(Greater_FloatFloat(Dot_VectorVector(DoorDirectionPerpendicular, Subtract_VectorVector(SwatPlayer.Location, AssociatedDoor.Location)), 0.0000000))
			{
				PushDirection = DoorDirectionPerpendicular;
			}
			else
			{
				PushDirection = Subtract_PreVector(DoorDirectionPerpendicular);
			}
			SwatPlayer.SetOneFrameNudgeDirection(PushDirection);
			J0x19C:

			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xBA;
		}
	}
	return;
}

private simulated function bool ShouldBlock()
{
	return AndAnd_BoolBool(ShouldRepulse(), NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	return;
}

private simulated function bool ShouldRepulse()
{
	return true;
	return;
}

defaultproperties
{
	BrushColor=(R=255,G=128,B=165,A=255)
	bStatic=false
	bCollideActors=false
	bBlockZeroExtentTraces=false
}