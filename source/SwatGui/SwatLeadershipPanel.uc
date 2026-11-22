class SwatLeadershipPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIMultiColumnListBox MyLeadershipBonusBox;
var(SwatGui) private export editinline config GUIMultiColumnListBox MyLeadershipPenaltyBox;
var(SwatGui) private export editinline config GUILabel MyLeadershipBonusTotal;
var(SwatGui) private export editinline config GUILabel MyLeadershipPenaltyTotal;
var(SwatGui) private export editinline config GUILabel MyLeadershipTotal;
var(SwatGui) private export editinline config GUILabel MyLeadershipRanking;
var(SwatGui) private export editinline config GUILabel MyDifficultyLabel;
var(SwatGui) private config bool bInGame "If true, this is an in-game implementation";
var private config localized string BonusFormatString;
var private config localized string PenaltyFormatStringx;
var private config localized string TotalString;
var private config string TotalFormatString;
var private config string NotMetDifficultyRequirementTotalFormatString;
var private config localized string RankingFormatString;
var private config localized string NoPenaltiesDeducted;
var private config localized string MissionFailedRanking;
var private config localized string DifficultyLabelString;
var config localized array<localized string> RankingStrings;
var config array<int> RankingLevels;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function InternalOnShow()
{
	UpdateProcedures();
	SetTimer(GC.MPPollingDelay, true);
	return;
}

event Timer()
{
	UpdateProcedures();
	return;
}

function UpdateProcedures()
{
	local Procedures theProcedures;
	local int i, Score, bonusScore, penaltyScore, curValue;

	local string Rank;
	local SwatGameReplicationInfo SGRI;

	SGRI = SwatGameReplicationInfo(PlayerOwner().GameReplicationInfo);
	theProcedures = SwatGUIController(Controller).Repo.Procedures;
	if(EqualEqual_ObjectObject(theProcedures, none))
	{
		return;
	}
	Score = 0;
	bonusScore = 0;
	penaltyScore = 0;
	MyLeadershipBonusBox.Clear();
	if(NotEqual_ObjectObject(MyLeadershipPenaltyBox, none))
	{
		MyLeadershipPenaltyBox.Clear();
	}
	if(EqualEqual_ObjectObject(SGRI, none))
	{
		return;
	}
	i = 0;
	J0x9B:

	if(Less_IntInt(i, theProcedures.Procedures.Length))
	{
		if(AndAnd_BoolBool(bInGame, Not_PreBool(theProcedures.Procedures[i].IsShownInObjectivesPanel)))
		{
			// [Explicit Continue]
			goto J0x2C6;
		}
		curValue = SGRI.ProcedureValue[i];
		AddEqual_IntInt(Score, curValue);
		if(theProcedures.Procedures[i].IsABonus)
		{
			MyLeadershipBonusBox.AddNewRowElement("Description",, theProcedures.Procedures[i].Description);
			MyLeadershipBonusBox.AddNewRowElement("Calculation",, SGRI.ProcedureCalculations[i]);
			if(Not_PreBool(bInGame))
			{
				MyLeadershipBonusBox.AddNewRowElement("Score",,, curValue);
			}
			MyLeadershipBonusBox.PopulateRow();
			AddEqual_IntInt(bonusScore, curValue);
			// [Explicit Continue]
			goto J0x2C6;
		}
		if(AndAnd_BoolBool(OrOr_BoolBool(NotEqual_IntInt(curValue, 0), theProcedures.Procedures[i].IsNeverHidden), NotEqual_ObjectObject(MyLeadershipPenaltyBox, none)))
		{
			MyLeadershipPenaltyBox.AddNewRowElement("Description",, theProcedures.Procedures[i].Description);
			MyLeadershipPenaltyBox.AddNewRowElement("Calculation",, SGRI.ProcedureCalculations[i]);
			if(Not_PreBool(bInGame))
			{
				MyLeadershipPenaltyBox.AddNewRowElement("Score",,, curValue);
			}
			MyLeadershipPenaltyBox.PopulateRow();
			AddEqual_IntInt(penaltyScore, curValue);
		}
		J0x2C6:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x9B;
	}
	if(bInGame)
	{
		if(NotEqual_ObjectObject(MyLeadershipPenaltyBox, none))
		{
			MyLeadershipPenaltyBox.Hide();
		}
		if(NotEqual_ObjectObject(MyLeadershipBonusTotal, none))
		{
			MyLeadershipBonusTotal.Hide();
		}
		if(NotEqual_ObjectObject(MyLeadershipPenaltyTotal, none))
		{
			MyLeadershipPenaltyTotal.Hide();
		}
		if(NotEqual_ObjectObject(MyLeadershipTotal, none))
		{
			MyLeadershipTotal.Hide();
		}
		if(NotEqual_ObjectObject(MyLeadershipRanking, none))
		{
			MyLeadershipRanking.Hide();
		}
	}
	else
	{
		if(EqualEqual_IntInt(MyLeadershipPenaltyBox.Num(), 0))
		{
			MyLeadershipPenaltyBox.AddNewRowElement("Description",, NoPenaltiesDeducted);
			MyLeadershipPenaltyBox.PopulateRow();
		}
		Score = Max(Score, 0);
		MyLeadershipBonusTotal.SetCaption(FormatTextString(BonusFormatString, string(bonusScore)));
		MyLeadershipPenaltyTotal.SetCaption(FormatTextString(PenaltyFormatStringx, string(penaltyScore)));
		if(GC.CurrentMission.HasMetDifficultyRequirement())
		{
			MyLeadershipTotal.SetCaption(FormatTextString(TotalFormatString, TotalString, string(Score)));
		}
		else
		{
			MyLeadershipTotal.SetCaption(FormatTextString(NotMetDifficultyRequirementTotalFormatString, TotalString, string(Score)));
		}
		if(GC.CurrentMission.IsMissionFailed())
		{
			Rank = MissionFailedRanking;
		}
		else
		{
			i = 0;
			J0x48E:

			if(Less_IntInt(i, RankingStrings.Length))
			{
				if(GreaterEqual_IntInt(Score, RankingLevels[i]))
				{
					Rank = RankingStrings[i];
					// [Explicit Break]
					goto J0x4D1;
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x48E;
			}
		}
		J0x4D1:

		MyLeadershipRanking.SetCaption(FormatTextString(RankingFormatString, Rank));
	}
	if(NotEqual_ObjectObject(MyDifficultyLabel, none))
	{
		MyDifficultyLabel.SetCaption(FormatTextString(DifficultyLabelString, string(GC.DifficultyScoreRequirement[int(GC.CurrentDifficulty)])));
	}
	return;
}

defaultproperties
{
	BonusFormatString="%1"
	PenaltyFormatStringx="%1"
	TotalString="Total"
	TotalFormatString="[c=ffffff]%1: [c=00ff00]%2[c=ffffff]/100"
	NotMetDifficultyRequirementTotalFormatString="[c=ffffff]%1: [c=ff0000]%2[c=ffffff]/100"
	RankingFormatString="Ranking: %1"
	NoPenaltiesDeducted="No Penalties Deducted!"
	MissionFailedRanking="Failure!"
	DifficultyLabelString="Required score: %1"
	OnShow=SwatLeadershipPanel.InternalOnShow
}