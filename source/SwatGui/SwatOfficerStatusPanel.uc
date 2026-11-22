class SwatOfficerStatusPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUILabel ReynoldsStatusLabel;
var(SwatGui) private export editinline config GUILabel GirardStatusLabel;
var(SwatGui) private export editinline config GUILabel FieldsStatusLabel;
var(SwatGui) private export editinline config GUILabel JacksonStatusLabel;
var private config localized string IncapacitatedString;
var private config localized string InjuredString;
var private config localized string HealthyString;
var private config localized string NotAvailable;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function InternalOnShow()
{
	local Pawn OfficerIter;
	local string Status;

	ReynoldsStatusLabel.SetCaption(NotAvailable);
	GirardStatusLabel.SetCaption(NotAvailable);
	FieldsStatusLabel.SetCaption(NotAvailable);
	JacksonStatusLabel.SetCaption(NotAvailable);
	OfficerIter = PlayerOwner().Level.PawnList;
	J0x6E:

	if(NotEqual_ObjectObject(OfficerIter, none))
	{
		if(OfficerIter.IsA('SwatOfficer'))
		{
			Status = GetStatusString(OfficerIter);
			if(OfficerIter.IsA('OfficerRedOne'))
			{
				ReynoldsStatusLabel.SetCaption(Status);
			}
			else
			{
				if(OfficerIter.IsA('OfficerRedTwo'))
				{
					GirardStatusLabel.SetCaption(Status);
				}
				else
				{
					if(OfficerIter.IsA('OfficerBlueOne'))
					{
						FieldsStatusLabel.SetCaption(Status);
					}
					else
					{
						if(OfficerIter.IsA('OfficerBlueTwo'))
						{
							JacksonStatusLabel.SetCaption(Status);
						}
						else
						{
							assert(false);
						}
					}
				}
			}
		}
		OfficerIter = OfficerIter.nextPawn;
		// [Loop Continue]
		goto J0x6E;
	}
	return;
}

private function string GetStatusString(Pawn Officer)
{
	if(Not_PreBool(Officer.IsConscious()))
	{
		return IncapacitatedString;
	}
	if(Officer.IsInjured())
	{
		return InjuredString;
	}
	return HealthyString;
	return;
}

defaultproperties
{
	IncapacitatedString="[c=ff0000][b]Incapacitated"
	InjuredString="[c=ff0000]Injured"
	HealthyString="Healthy"
	NotAvailable="[c=ffffff][b]Not Available"
	OnShow=SwatOfficerStatusPanel.InternalOnShow
}