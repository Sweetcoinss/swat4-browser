class Procedures extends Object
	config(Leadership);

var config array< Class<Procedure> > ProcedureClass;
var array<Procedure> Procedures;
var private transient SwatGameInfo Game;

overloaded function Construct()
{
	local Procedure CurrentProcedure;
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ProcedureClass.Length))
	{
		AssertWithDescription(NotEqual_ObjectObject(ProcedureClass[i], none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ProcedureClass index ", string(i)), " in the "), string(Class.Name)), " configuration file is not a valid Procedure class."));
		CurrentProcedure = ProcedureClass[i].static.Allocate(self, none, string(ProcedureClass[i].Name), 0).;
		Construct_Void();
		assert(NotEqual_ObjectObject(CurrentProcedure, none));
		assert(CurrentProcedure.IsA(ProcedureClass[i].Name));
		Procedures[Procedures.Length] = CurrentProcedure;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

final function Init(SwatGameInfo GameInfo)
{
	local int i;

	assert(NotEqual_ObjectObject(GameInfo, none));
	Game = GameInfo;
	i = 0;
	J0x1D:

	if(Less_IntInt(i, Procedures.Length))
	{
		Procedures[i].super(Procedures).Init(Game);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

function bool ProceduresMaxed()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Procedures.Length))
	{
		if(Not_PreBool(Procedures[i].IsMaxed()))
		{
			return false;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

defaultproperties
{
	ProcedureClass[0]=Class'SwatProcedures.Procedure_CompleteMission'
	ProcedureClass[1]=Class'SwatProcedures.Procedure_ArrestUnIncapacitatedSuspects'
	ProcedureClass[2]=Class'SwatProcedures.Procedure_ArrestIncapacitatedSuspects'
	ProcedureClass[3]=Class'SwatProcedures.Procedure_KillSuspects'
	ProcedureClass[4]=Class'SwatProcedures.Procedure_NoSuspectsNeutralized'
	ProcedureClass[5]=Class'SwatProcedures.Procedure_NoCiviliansInjured'
	ProcedureClass[6]=Class'SwatProcedures.Procedure_NoOfficersDown'
	ProcedureClass[7]=Class'SwatProcedures.Procedure_PlayerUninjured'
	ProcedureClass[8]=Class'SwatProcedures.Procedure_ReportCharactersToTOC'
	ProcedureClass[9]=Class'SwatProcedures.Procedure_SecureAllWeapons'
	ProcedureClass[10]=Class'SwatProcedures.Procedure_EvacuateDownedOfficers'
	ProcedureClass[11]=Class'SwatProcedures.Procedure_NoHostageIncapacitated'
	ProcedureClass[12]=Class'SwatProcedures.Procedure_NoHostageKilled'
	ProcedureClass[13]=Class'SwatProcedures.Procedure_NoOfficerIncapacitated'
	ProcedureClass[14]=Class'SwatProcedures.Procedure_NoOfficerInjured'
	ProcedureClass[15]=Class'SwatProcedures.Procedure_NoUnauthorizedUseOfDeadlyForce'
	ProcedureClass[16]=Class'SwatProcedures.Procedure_NoUnauthorizedUseOfForce'
}