class NetScoreInfo extends ReplicationInfo
	config(SwatGame)
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var int Ranking;
var private int numEnemyKills;
var private int numFriendlyKills;
var private int numTimesDied;
var private int numKilledVIPValid;
var private int numKilledVIPInvalid;
var private int numArrests;
var private int numTimesArrested;
var private int numVIPPlayerEscaped;
var private int numArrestedVIP;
var private int numUnarrestedVIP;
var private int numBombsDiffused;
var private int numRDCrybaby;
var private int numRoundsWon;
var private config int pointsPerEnemyKill;
var private config int pointsPerFriendlyKill;
var private config int pointsPerTimeDied;
var private config int pointsPerArrest;
var private config int pointsPerTimeArrested;
var private config int pointsPerVIPPlayerEscaped;
var private config int pointsPerArrestedVIP;
var private config int pointsPerUnarrestedVIP;
var private config int pointsPerBombDiffused;
var private config int pointsPerRDCrybaby;
var private config int pointsPerKilledVIPInvalid;
var private config int pointsPerKilledVIPValid;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		numArrestedVIP, numArrests,
		numBombsDiffused, numEnemyKills,
		numFriendlyKills, numKilledVIPInvalid,
		numKilledVIPValid, numRDCrybaby,
		numRoundsWon, numTimesArrested,
		numTimesDied, numUnarrestedVIP,
		numVIPPlayerEscaped, pointsPerArrest,
		pointsPerArrestedVIP, pointsPerBombDiffused,
		pointsPerEnemyKill, pointsPerFriendlyKill,
		pointsPerKilledVIPInvalid, pointsPerKilledVIPValid,
		pointsPerRDCrybaby, pointsPerTimeArrested,
		pointsPerTimeDied, pointsPerUnarrestedVIP,
		pointsPerVIPPlayerEscaped;
}

simulated function int GetScore()
{
	if(Level.IsPlayingCOOP)
	{
		return 0;
	}
	return Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Multiply_IntInt(numEnemyKills, pointsPerEnemyKill), Multiply_IntInt(numFriendlyKills, pointsPerFriendlyKill)), Multiply_IntInt(numTimesDied, pointsPerTimeDied)), Multiply_IntInt(numArrests, pointsPerArrest)), Multiply_IntInt(numTimesArrested, pointsPerTimeArrested)), Multiply_IntInt(numVIPPlayerEscaped, pointsPerVIPPlayerEscaped)), Multiply_IntInt(numKilledVIPValid, pointsPerKilledVIPValid)), Multiply_IntInt(numKilledVIPInvalid, pointsPerKilledVIPInvalid)), Multiply_IntInt(numArrestedVIP, pointsPerArrestedVIP)), Multiply_IntInt(numUnarrestedVIP, pointsPerUnarrestedVIP)), Multiply_IntInt(numBombsDiffused, pointsPerBombDiffused)), Multiply_IntInt(numRDCrybaby, pointsPerRDCrybaby));
	return;
}

simulated function int GetEnemyKills()
{
	return numEnemyKills;
	return;
}

simulated function int GetFriendlyKills()
{
	return numFriendlyKills;
	return;
}

simulated function int GetTimesDied()
{
	return numTimesDied;
	return;
}

simulated function int GetArrests()
{
	return numArrests;
	return;
}

simulated function int GetTimesArrested()
{
	return numTimesArrested;
	return;
}

simulated function int GetVIPPlayerEscaped()
{
	return numVIPPlayerEscaped;
	return;
}

simulated function int GetKilledVIPValid()
{
	return numKilledVIPValid;
	return;
}

simulated function int GetKilledVIPInvalid()
{
	return numKilledVIPInvalid;
	return;
}

simulated function int GetArrestedVIP()
{
	return numArrestedVIP;
	return;
}

simulated function int GetUnarrestedVIP()
{
	return numUnarrestedVIP;
	return;
}

simulated function int GetBombsDiffused()
{
	return numBombsDiffused;
	return;
}

simulated function int GetRDCrybaby()
{
	return numRDCrybaby;
	return;
}

simulated function int GetRoundsWon()
{
	return numRoundsWon;
	return;
}

function IncrementEnemyKills()
{
	AddAdd_Int(numEnemyKills);
	return;
}

function IncrementFriendlyKills()
{
	AddAdd_Int(numFriendlyKills);
	return;
}

function IncrementTimesDied()
{
	AddAdd_Int(numTimesDied);
	return;
}

function IncrementArrests()
{
	AddAdd_Int(numArrests);
	return;
}

function IncrementTimesArrested()
{
	AddAdd_Int(numTimesArrested);
	return;
}

function IncrementVIPPlayerEscaped()
{
	AddAdd_Int(numVIPPlayerEscaped);
	return;
}

function IncrementKilledVIPValid()
{
	AddAdd_Int(numKilledVIPValid);
	return;
}

function IncrementKilledVIPInvalid()
{
	AddAdd_Int(numKilledVIPInvalid);
	return;
}

function IncrementArrestedVIP()
{
	AddAdd_Int(numArrestedVIP);
	return;
}

function IncrementUnarrestedVIP()
{
	AddAdd_Int(numUnarrestedVIP);
	return;
}

function IncrementBombsDiffused()
{
	AddAdd_Int(numBombsDiffused);
	return;
}

function IncrementRDCrybaby()
{
	AddAdd_Int(numRDCrybaby);
	return;
}

function SetRoundsWon(int val)
{
	numRoundsWon = val;
	return;
}

function ResetForMPQuickRestart()
{
	numEnemyKills = 0;
	numFriendlyKills = 0;
	numTimesDied = 0;
	numArrests = 0;
	numTimesArrested = 0;
	numVIPPlayerEscaped = 0;
	numKilledVIPValid = 0;
	numKilledVIPInvalid = 0;
	numArrestedVIP = 0;
	numUnarrestedVIP = 0;
	numBombsDiffused = 0;
	numRDCrybaby = 0;
	return;
}

defaultproperties
{
	pointsPerEnemyKill=1
	pointsPerFriendlyKill=-3
	pointsPerArrest=5
	pointsPerVIPPlayerEscaped=10
	pointsPerArrestedVIP=10
	pointsPerUnarrestedVIP=10
	pointsPerBombDiffused=10
	pointsPerRDCrybaby=10
	pointsPerKilledVIPInvalid=-51
	pointsPerKilledVIPValid=10
}