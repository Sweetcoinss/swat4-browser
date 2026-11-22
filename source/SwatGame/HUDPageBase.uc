class HUDPageBase extends GUIPage implements IEffectObserver
	abstract
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(HUD) export editinline GUIFeedback Feedback "Test that displays feedback to the user if they can 'Use' or 'Fire' at something under the Reticle.";
var(HUD) export editinline GUIFireMode FireMode "An image that indicates the current fired weapon's fire mode, eg. 3-round burst.";
var(HUD) export editinline GUIDamageIndicator DamageIndicator "An image that indicates the current damage state of the player.";
var(HUD) export editinline GUIAmmoStatusBase AmmoStatus "Displays the current ammunition situation for the current weapon.";
var(HUD) export editinline GUIOverlay Overlay "An image that should be the size of the screen, and obstructs the view for sniper scope, gas mask, etc.";
var(HUD) export editinline GUIProgressBar Progress "A multi-purpose progress bar.";
var(HUD) export editinline GUIReticle Reticle "The reticle.";
var(HUD) export editinline GUIDefaultCommandIndicator DefaultCommand "Text that displays the Command that will be given if the player presses the button to give the Default Command (right-mouse by default).";
var(HUD) export editinline GUIClassicCommandInterfaceContainer ClassicCommandInterface "A GUI component which contains the Classic Command Interface.";
var(HUD) export editinline GUIGraphicCommandInterface GraphicCommandInterface "A GUI component which contains the Graphic Command Interface.";
var(HUD) export editinline GUIExternalViewport ExternalViewport "The gui component which contains the external viewport for team/sniper management.";
var(HUD) export editinline GUIScrollText TrainingText "A Text Box that displays the current information during Training.";
var(HUD) export editinline GUIBattleRoom BattleRoom "The gui component which contains the battle room hud";
var(HUD) export editinline GUILabel PlayerTag "The text that pops up on top of players in multiplayer games.";
var(HUD) export editinline GUILabel CommandInterfaceMenuPage "Text that displays the currently selected CommandInterface menu page.";
var(SwatGui) editinline config array<export editinline GUIComponent> SequenceComponents;
var(PREGAME) private config name PreGamePlacementName;
var(PREGAME) private config name MidGamePlacementName;
var(PREGAME) private config name PostGamePlacementName;
var(PREGAME) private config name MissionEndSequenceAName;
var(PREGAME) private config name MissionEndSequenceBName;
var(PREGAME) private config name MissionStartSequenceAName;
var(PREGAME) private config name MissionStartSequenceBName;
var(PREGAME) private bool bInCinematic;
var int NumTicks;

function OnConstruct(GUIController MyController)
{
	super(GUIMultiComponent).OnConstruct(MyController);
	Feedback = GUIFeedback(AddComponent("SwatGame.GUIFeedback", "HUDPage_feedback"));
	AmmoStatus = GUIAmmoStatusBase(AddComponent("SwatGUI.GUIAmmoStatus", "HUDPage_ammostatus"));
	FireMode = GUIFireMode(AddComponent("SwatGame.GUIFireMode", "HUDPage_FireMode"));
	DamageIndicator = GUIDamageIndicator(AddComponent("SwatGame.GUIDamageIndicator", "HUD_page_DamageIndicator"));
	Overlay = GUIOverlay(AddComponent("SwatGame.GUIOverlay", "HUDPage_overlay"));
	Progress = GUIProgressBar(AddComponent("GUI.GUIProgressBar", "HUDPage_Progress"));
	Reticle = GUIReticle(AddComponent("SwatGame.GUIReticle", "HudReticle"));
	ClassicCommandInterface = GUIClassicCommandInterfaceContainer(AddComponent("SwatGame.GUIClassicCommandInterfaceContainer", "HUDPage_ClassicCommandInterface"));
	GraphicCommandInterface = GUIGraphicCommandInterface(AddComponent("SwatGame.GUIGraphicCommandInterface", "HUDPage_GraphicCommandInterface"));
	DefaultCommand = GUIDefaultCommandIndicator(AddComponent("SwatGame.GUIDefaultCommandIndicator", "HUDPage_defaultcommand"));
	CommandInterfaceMenuPage = GUILabel(AddComponent("GUI.GUILabel", "HUDPage_CommandInterfaceMenuPage"));
	ExternalViewport = GUIExternalViewport(AddComponent("SwatGame.GUIExternalViewport", "HUDPAGE_ExternalViewport"));
	BattleRoom = GUIBattleRoom(AddComponent("SwatGame.GUIBattleRoom", "HUDPage_BattleRoom"));
	PlayerTag = GUILabel(AddComponent("GUI.GUILabel", "HUDPage_playertag"));
	TrainingText = GUIScrollText(AddComponent("GUI.GUIScrollText", "HUDPage_TrainingText"));
	TrainingText.CharDelay = 0.0010000;
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, SequenceComponents.Length))
	{
		SequenceComponents[i].bRepeatCycling = false;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	return;
}

event Activate()
{
	super(GUIComponent).Activate();
	return;
}

event DeActivate()
{
	super(GUIComponent).DeActivate();
	return;
}

event Show()
{
	UpdateCIVisibility();
	super.Show();
	return;
}

event Hide()
{
	super.Hide();
	return;
}

function PreLevelChangeCleanup()
{
	GraphicCommandInterface.SetLogic(none);
	return;
}

function OnGameInit()
{
	RepositionComponents(PreGamePlacementName, true);
	return;
}

function OnGameStarted()
{
	RepositionComponents(MidGamePlacementName);
	CloseComponents();
	OpenCinematicComponents();
	bInCinematic = true;
	NumTicks = 0;
	Timer();
	return;
}

event Timer()
{
	AddAdd_Int(NumTicks);
	if(Less_IntInt(NumTicks, 3))
	{
		SetTimer(0.0000100);
		return;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(SwatGUIControllerBase(Controller).GuiConfig.CurrentMission, none), NotEqual_ObjectObject(SwatGUIControllerBase(Controller).GuiConfig.CurrentMission.CustomScenario, none)))
	{
		FinishStartRoundSequence();
	}
	else
	{
		if(Not_PreBool(PlayerOwner().TriggerEffectEvent('UIMissionDispatcher',,,,,,, self)))
		{
			FinishStartRoundSequence();
		}
		else
		{
			StartStartRoundSequence();
		}
	}
	return;
}

function OnGameOver()
{
	CloseComponents();
	RepositionComponents(PostGamePlacementName);
	return;
}

function OnPlayerRespawned()
{
	OpenComponents();
	return;
}

function OnPlayerDied()
{
	CloseComponents();
	return;
}

function StartStartRoundSequence()
{
	bInCinematic = true;
	RepositionComponents(MissionStartSequenceAName);
	return;
}

function FinishStartRoundSequence()
{
	OpenComponents();
	bInCinematic = false;
	RepositionComponents(MissionStartSequenceBName);
	SwatGamePlayerController(PlayerOwner()).PostGameStarted();
	return;
}

function StartEndRoundSequence()
{
	bInCinematic = true;
	CloseComponents();
	RepositionComponents(MissionEndSequenceAName);
	return;
}

function FinishEndRoundSequence()
{
	bInCinematic = false;
	RepositionComponents(MissionEndSequenceBName);
	return;
}

function OnEffectInitialized(Actor inInitializedEffect)
{
	return;
}

function OnEffectStarted(Actor inStartedEffect)
{
	return;
}

function OnEffectStopped(Actor inStoppedEffect, bool Completed)
{
	FinishStartRoundSequence();
	return;
}

protected function OpenComponents()
{
	switch(SwatGUIControllerBase(Controller).GuiConfig.SwatGameRole)
	{
		case 0:
		case 1:
		case 2:
		case 3:
			OpenSPComponents();
			break;
		case 4:
		case 5:
			OpenMPComponents();
			break;
		default:
			assert(false);
			break;
			break;
	}
	OpenGenericComponents();
	return;
}

protected function CloseComponents()
{
	switch(SwatGUIControllerBase(Controller).GuiConfig.SwatGameRole)
	{
		case 0:
		case 1:
		case 2:
		case 3:
			CloseSPComponents();
			break;
		case 4:
		case 5:
			CloseMPComponents();
			break;
		default:
			assert(false);
			break;
			break;
	}
	CloseGenericComponents();
	return;
}

function OpenCinematicComponents()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SequenceComponents.Length))
	{
		SequenceComponents[i].Show();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function CloseCinematicComponents()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SequenceComponents.Length))
	{
		SequenceComponents[i].Hide();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function CloseGenericComponents()
{
	assert(NotEqual_ObjectObject(ClassicCommandInterface, none));
	ClassicCommandInterface.Hide();
	assert(NotEqual_ObjectObject(GraphicCommandInterface, none));
	GraphicCommandInterface.Hide();
	assert(NotEqual_ObjectObject(DefaultCommand, none));
	DefaultCommand.Hide();
	assert(NotEqual_ObjectObject(CommandInterfaceMenuPage, none));
	CommandInterfaceMenuPage.Hide();
	assert(NotEqual_ObjectObject(ExternalViewport, none));
	ExternalViewport.Hide();
	assert(NotEqual_ObjectObject(Feedback, none));
	Feedback.Hide();
	Feedback.RePosition('Down', true);
	assert(NotEqual_ObjectObject(FireMode, none));
	FireMode.Hide();
	assert(NotEqual_ObjectObject(DamageIndicator, none));
	DamageIndicator.Hide();
	assert(NotEqual_ObjectObject(AmmoStatus, none));
	AmmoStatus.Hide();
	assert(NotEqual_ObjectObject(Overlay, none));
	Overlay.Hide();
	assert(NotEqual_ObjectObject(Progress, none));
	Progress.Hide();
	Progress.Value = 0.0000000;
	Progress.RePosition('Down');
	assert(NotEqual_ObjectObject(Reticle, none));
	Reticle.Hide();
	return;
}

function CloseSPComponents()
{
	assert(NotEqual_ObjectObject(TrainingText, none));
	TrainingText.Hide();
	assert(NotEqual_ObjectObject(BattleRoom, none));
	BattleRoom.Hide();
	return;
}

function CloseMPComponents()
{
	assert(NotEqual_ObjectObject(PlayerTag, none));
	PlayerTag.Hide();
	return;
}

function OpenGenericComponents()
{
	assert(NotEqual_ObjectObject(ExternalViewport, none));
	ExternalViewport.Hide();
	UpdateCIVisibility();
	assert(NotEqual_ObjectObject(Feedback, none));
	Feedback.Show();
	Feedback.RePosition('Down', true);
	assert(NotEqual_ObjectObject(AmmoStatus, none));
	assert(NotEqual_ObjectObject(FireMode, none));
	UpdateFireMode();
	assert(NotEqual_ObjectObject(DamageIndicator, none));
	DamageIndicator.Reset();
	DamageIndicator.Show();
	assert(NotEqual_ObjectObject(Overlay, none));
	Overlay.Show();
	assert(NotEqual_ObjectObject(Progress, none));
	Progress.Show();
	assert(NotEqual_ObjectObject(Reticle, none));
	Reticle.Show();
	return;
}

function OpenSPComponents()
{
	assert(NotEqual_ObjectObject(TrainingText, none));
	TrainingText.Hide();
	assert(NotEqual_ObjectObject(BattleRoom, none));
	BattleRoom.Hide();
	return;
}

function OpenMPComponents()
{
	assert(NotEqual_ObjectObject(PlayerTag, none));
	PlayerTag.Hide();
	return;
}

function UpdateCIVisibility()
{
	local bool CurrentInterfaceIsEnabled, CCIShown;
	local CommandInterface CurrentCommandInterface;

	CurrentCommandInterface = SwatGamePlayerController(PlayerOwner()).GetCommandInterface();
	CurrentInterfaceIsEnabled = AndAnd_BoolBool(NotEqual_ObjectObject(CurrentCommandInterface, none), CurrentCommandInterface.Enabled);
	CCIShown = EqualEqual_IntInt(int(SwatGUIControllerBase(Controller).GuiConfig.CurrentCommandInterfaceStyle), int(1));
	AssertWithDescription(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentCommandInterface, none), EqualEqual_BoolBool(CurrentCommandInterface.IsA('ClassicCommandInterface'), CCIShown)), "[tcohen] HUDPageBase::UpdateCIVisibility() the GUIConfig and the GamePlayerController disagree about which CommandInterface is current.");
	assert(NotEqual_ObjectObject(ClassicCommandInterface, none));
	ClassicCommandInterface.SetVisibility(AndAnd_BoolBool(CCIShown, CurrentInterfaceIsEnabled));
	assert(NotEqual_ObjectObject(GraphicCommandInterface, none));
	GraphicCommandInterface.SetVisibility(AndAnd_BoolBool(Not_PreBool(CCIShown), CurrentInterfaceIsEnabled));
	GraphicCommandInterface.bUseExitPad = SwatGUIControllerBase(Controller).GuiConfig.bUseExitMenu;
	assert(NotEqual_ObjectObject(DefaultCommand, none));
	DefaultCommand.SetVisibility(CurrentInterfaceIsEnabled);
	assert(NotEqual_ObjectObject(CommandInterfaceMenuPage, none));
	CommandInterfaceMenuPage.SetVisibility(AndAnd_BoolBool(AndAnd_BoolBool(CurrentInterfaceIsEnabled, Not_PreBool(CCIShown)), OrOr_BoolBool(EqualEqual_IntInt(int(SwatGUIControllerBase(Controller).GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(SwatGUIControllerBase(Controller).GuiConfig.SwatGameRole), int(5)))));
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	return bInCinematic;
	return;
}

function GUIScrollText GetTrainingTextControl()
{
	assert(NotEqual_ObjectObject(TrainingText, none));
	TrainingText.Show();
	return TrainingText;
	return;
}

simulated function UpdateProtectiveEquipmentOverlay()
{
	Overlay.UpdateImage();
	return;
}

simulated function UpdateFireMode()
{
	local FiredWeapon FiredWeapon;
	local FiredWeapon.FireMode CurrentFireMode;

	if(NotEqual_ObjectObject(PlayerOwner().Pawn, none))
	{
		FiredWeapon = FiredWeapon(PlayerOwner().Pawn.GetActiveItem());
	}
	if(EqualEqual_ObjectObject(FiredWeapon, none))
	{
		if(AmmoStatus.bVisible)
		{
			AmmoStatus.Hide();
		}
		if(FireMode.bVisible)
		{
			FireMode.Hide();
		}
	}
	else
	{
		if(Not_PreBool(AmmoStatus.bVisible))
		{
			AmmoStatus.Show();
		}
		if(Not_PreBool(FireMode.bVisible))
		{
			FireMode.Show();
		}
		if(Less_IntInt(FiredWeapon.AvailableFireMode.Length, 2))
		{
			FireMode.Hide();
		}
		CurrentFireMode = FiredWeapon.CurrentFireMode;
		FireMode.SelectFireMode(CurrentFireMode);
	}
	return;
}

function SkeletalRegionHit(Actor.ESkeletalRegion RegionHit, int Damage)
{
	DamageIndicator.SkeletalRegionHit(RegionHit, Damage);
	return;
}

function SetCrouched(bool bCrouching)
{
	if(bCrouching)
	{
		DamageIndicator.Crouch();
	}
	else
	{
		DamageIndicator.Stand();
	}
	return;
}

function ResetDamageIndicator()
{
	DamageIndicator.Reset();
	return;
}

protected function RepositionComponents(name ToPos, optional bool Immediate)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		Controls[i].RePosition(ToPos, Immediate);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

defaultproperties
{
	bIsHUD=true
	PropagateVisibility=false
	PropagateActivity=false
	bNeverFocus=true
}