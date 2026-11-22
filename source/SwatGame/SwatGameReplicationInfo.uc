class SwatGameReplicationInfo extends GameReplicationInfo
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

const MAX_PLAYERS = 16;
const MAX_OBJECTIVES = 30;
const MAX_PROCEDURES = 20;

var SwatPlayerReplicationInfo PRIStaticArray[16];
var float ServerCountdownTime;
var int ShowTeammateNames;
var int ShowEnemyNames;
var int TotalNumberOfBombs;
var int DiffusedBombs;
var int RoundTime;
var int SpecialTime;
var int TimedObjectiveIndex;
var bool bWaitingForPlayers;
var Objective.ObjectiveStatus ObjectiveStatus[30];
var string ProcedureCalculations[20];
var int ProcedureValue[20];

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DiffusedBombs, ObjectiveStatus,
		ProcedureCalculations, ProcedureValue,
		RoundTime, ServerCountdownTime,
		ShowEnemyNames, ShowTeammateNames,
		SpecialTime, TimedObjectiveIndex,
		TotalNumberOfBombs, bWaitingForPlayers;
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	SwatRepo(Level.GetRepo()).SetSGRI(self);
	ClearScoring();
	return;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SwatRepo(Level.GetRepo()).SetSGRI(self);
	ClearScoring();
	return;
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
	local int i;

	super.AddPRI(PRI);
	i = 0;
	J0x12:

	if(Less_IntInt(i, 16))
	{
		if(EqualEqual_ObjectObject(PRIStaticArray[i], none))
		{
			PRIStaticArray[i] = SwatPlayerReplicationInfo(PRI);
			// [Explicit Break]
			goto J0x52;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x52:

	return;
}

simulated function RemovePRI(PlayerReplicationInfo PRI)
{
	local int i;

	super.RemovePRI(PRI);
	i = 0;
	J0x12:

	if(Less_IntInt(i, 16))
	{
		if(EqualEqual_ObjectObject(PRIStaticArray[i], PRI))
		{
			PRIStaticArray[i] = none;
			// [Explicit Break]
			goto J0x4D;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x4D:

	return;
}

simulated function int NumPlayers()
{
	local int i, total;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 16))
	{
		if(NotEqual_ObjectObject(PRIStaticArray[i], none))
		{
			AddAdd_Int(total);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return total;
	return;
}

function SetWaitingForPlayers(bool WaitingForReconnects)
{
	bWaitingForPlayers = AndAnd_BoolBool(WaitingForReconnects, AllPlayersAreReady());
	return;
}

function bool AllPlayersAreReady()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 16))
	{
		if(NotEqual_ObjectObject(PRIStaticArray[i], none))
		{
			if(Not_PreBool(PRIStaticArray[i].GetPlayerIsReady()))
			{
				return false;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

function bool ResetPlayerReadyValues()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 16))
	{
		if(NotEqual_ObjectObject(PRIStaticArray[i], none))
		{
			PRIStaticArray[i].ResetPlayerIsReady();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

function ResetPlayerScoresForMPQuickRestart()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 16))
	{
		if(NotEqual_ObjectObject(PRIStaticArray[i], none))
		{
			PRIStaticArray[i].NetScoreInfo.ResetForMPQuickRestart();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated function LogScoring(SwatRepo Repo)
{
	local int i;

	Log("SCORING: >>> Objectives");
	i = 0;
	J0x22:

	if(AndAnd_BoolBool(Less_IntInt(i, 30), Less_IntInt(i, Repo.MissionObjectives.Objectives.Length)))
	{
		if(NotEqual_ObjectObject(Repo.MissionObjectives.Objectives[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("SCORING: ... ", Repo.MissionObjectives.Objectives[i].Description), ", Status = "), string(ObjectiveStatus[i])));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x22;
	}
	Log("\nSCORING: >>> Procedures");
	i = 0;
	J0xF9:

	if(AndAnd_BoolBool(Less_IntInt(i, 20), Less_IntInt(i, Repo.Procedures.Procedures.Length)))
	{
		if(NotEqual_ObjectObject(Repo.Procedures.Procedures[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SCORING: ... ", Repo.Procedures.Procedures[i].Description), ", Calculations = "), ProcedureCalculations[i]), ", Value = "), string(ProcedureValue[i])));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xF9;
	}
	return;
}

function ClearScoring()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 30))
	{
		ObjectiveStatus[i] = 0;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0x32:

	if(Less_IntInt(i, 20))
	{
		ProcedureCalculations[i] = "";
		ProcedureValue[i] = 0;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x32;
	}
	return;
}

function NotifyClientsToInterruptAndGotoState(Pawn thePlayer, name Reason, name NewControllerState, name NewPawnState)
{
	local SwatGamePlayerController SGPC;
	local Controller Current;

	MPLog(Concat_StrStr(string(self), "---SGPC::NotifyClientsToInterruptAndGotoState()."));
	MPLog(Concat_StrStr("...Pawn=", string(thePlayer)));
	MPLog(Concat_StrStr("...Reason=", string(Reason)));
	MPLog(Concat_StrStr("...NewControllerState=", string(NewControllerState)));
	MPLog(Concat_StrStr("...NewPawnState=", string(NewPawnState)));
	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))));
	Current = Level.ControllerList;
	J0x101:

	if(NotEqual_ObjectObject(Current, none))
	{
		SGPC = SwatGamePlayerController(Current);
		if(NotEqual_ObjectObject(SGPC, none))
		{
			SGPC.ClientInterruptAndGotoState(thePlayer, Reason, NewControllerState, NewPawnState);
		}
		Current = Current.nextController;
		// [Loop Continue]
		goto J0x101;
	}
	return;
}

function NotifyClientsToInterruptState(Pawn thePlayer, name Reason)
{
	local SwatGamePlayerController SGPC;
	local Controller Current;

	MPLog(Concat_StrStr(string(self), "---SGPC::NotifyClientsToInterruptState()."));
	MPLog(Concat_StrStr("...Pawn=", string(thePlayer)));
	MPLog(Concat_StrStr("...Reason=", string(Reason)));
	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))));
	Current = Level.ControllerList;
	J0xB2:

	if(NotEqual_ObjectObject(Current, none))
	{
		SGPC = SwatGamePlayerController(Current);
		if(NotEqual_ObjectObject(SGPC, none))
		{
			SGPC.ClientInterruptState(thePlayer, Reason);
		}
		Current = Current.nextController;
		// [Loop Continue]
		goto J0xB2;
	}
	return;
}

function ServerTriggerDynamicMusic()
{
	local Controller Itr;

	Itr = Level.ControllerList;
	Itr = Level.ControllerList;
	J0x28:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(Itr.IsA('SwatGamePlayerController'))
		{
			SwatGamePlayerController(Itr).ClientTriggerDynamicMusic();
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x28;
	}
	return;
}

function SetObjectiveVisibility(name ObjectiveName, bool Visible)
{
	local Controller Itr;
	local PlayerController LPC;

	SwatRepo(Level.GetRepo()).SetObjectiveVisibility(ObjectiveName, Visible);
	LPC = Level.GetLocalPlayerController();
	Itr = Level.ControllerList;
	Itr = Level.ControllerList;
	J0x66:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(AndAnd_BoolBool(Itr.IsA('SwatGamePlayerController'), NotEqual_ObjectObject(Itr, LPC)))
		{
			SwatGamePlayerController(Itr).ClientSetObjectiveVisibility(string(ObjectiveName), Visible);
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x66;
	}
	return;
}

function OnMissionEnded()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 16))
	{
		if(NotEqual_ObjectObject(PRIStaticArray[i], none))
		{
			PRIStaticArray[i].OnMissionEnded();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	RoundTime = 0;
	SpecialTime = 0;
	return;
}

function int ServerChooseSoundEffectToPlay(name EffectSpecification, Actor Source, Actor Target, Material TargetMaterial)
{
	local SoundEffectsSubsystem SoundSys;
	local SoundEffectSpecification SoundSpec;
	local SoundRef SoundRef;

	SoundSys = SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem'));
	SoundSpec = SoundEffectSpecification(SoundSys.FindEffectSpecification(EffectSpecification));
	SoundRef = SoundSpec.PickSoundToPlay(SoundSys.GetSoundMaterialFlags(TargetMaterial));
	return SoundRef.SoundSetIndex;
	return;
}
