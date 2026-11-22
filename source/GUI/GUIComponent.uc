class GUIComponent extends GUI
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object);

cpptext
{
        virtual void UpdateComponent(UCanvas* Canvas); //Performs an update, refreshing the component's dims, etc.; should be overridden in a subclass
		virtual void PreDraw(UCanvas *Canvas);	// Should be overridden in a subclass
		virtual void Draw(UCanvas* Canvas);		// Should be overridden in a subclass
		void ClientDraw(UCanvas* Canvas);		// Prepare the Canvas for a client to draw on the component, and then call delegateOnClientDraw

        virtual void Modify(); //callback from the object browser

		virtual UBOOL PerformHitTest(INT MouseX, INT MouseY);					// Check to see if a mouse press affects the control
		virtual void  UpdateBounds();											// Updates the Bounds for hit tests and such
		virtual FLOAT ActualWidth();											// Returns the actual width (including scaling) of a component
		virtual FLOAT ActualHeight();											// Returns the actual height (including scaling) of a component
		virtual FLOAT ActualLeft();												// Returns the actual left (including scaling) of a component
		virtual FLOAT ActualTop();												// Returns the actual top (including scaling) of a component
		virtual void  SaveCanvasState(UCanvas* Canvas);							// Save the current state of the canvas
		virtual void  RestoreCanvasState(UCanvas* Canvas);						// Restores the state of the canvas

		virtual UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);

#if IG_SHARED
		virtual UBOOL MouseMove(FLOAT XDelta, FLOAT YDelta);		// The Mouse has moved
#else
		virtual UBOOL MouseMove(INT XDelta, INT YDelta);			// The Mouse has moved
#endif
		virtual UBOOL MousePressed(UBOOL IsRepeat);					// The Mouse was pressed
		virtual UBOOL MouseReleased();								// The Mouse was released
		virtual UBOOL MouseHover();									// The Mouse is over a non-pressed thing

		virtual UBOOL NativeKeyType(BYTE& iKey, TCHAR Unicode );				// Handle key presses
		virtual UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta);	// Handle key events

		virtual void SetDims(FLOAT Width, FLOAT Height, FLOAT Left, FLOAT Top);	// Set the dims quickly
		virtual void  CloneDims(UGUIComponent* From);	// Clones the Width,Height, Top, Left settings

		virtual UBOOL SpecialHit();
        virtual UBOOL XControllerEvent(int Id, eXControllerCodes iCode);
        virtual UBOOL RawXController(int Id, BYTE& iKey, BYTE& State, FLOAT Axis);

}

enum EClickSound
{
	CS_None,                        // 0
	CS_Click,                       // 1
	CS_Edit,                        // 2
	CS_Up,                          // 3
	CS_Down                         // 4
};

struct native sDynamicPositionSpec
{
	var() config float Transparency "Transparency of this component";
	var() config float WinLeft "Left position of this spec";
	var() config float WinTop "Top position of this spec";
	var() config float WinWidth "Width of this spec";
	var() config float WinHeight "Height of this spec";
	var() config float TransitionTime "The amount of time that will be taken to transition to these coords on a RePosition() call";
	var() config name KeyName "Name used to reference this position spec";
};

struct native sTransitionSpec
{
	var() editconst sDynamicPositionSpec NewPos "New position spec";
	var() editconst float OldWinLeft "Left position of this spec";
	var() editconst float OldWinTop "Top position of this spec";
	var() editconst float OldWinWidth "Width of this spec";
	var() editconst float OldWinHeight "Height of this spec";
	var() editconst float OldTransparency "Transparency of this spec";
};

var() editinline config array<editinline sDynamicPositionSpec> MovePositions "The PositionSpecs used to handle dynamic RePosition()ing";
var(GUIState) editconst bool bRepositioning "If true, the timer for this component should be repositioning based on the current TransitionSpec";
var(GUIState) editconst editinline sTransitionSpec TransitionSpec "The current transitioning spec";
var() config int CyclePosition "If set to a MovePositions index, the component will begin cycling from that index when activated";
var() config bool bRepeatCycling "If set, this component will continue cycling after it processes to the end of the MovePositions array";
var(GUIState) editconst int MoveGroup "What move group this component belongs to, -1 by default is none";
var(GUIState) editconst export editinline GUIComponent MenuOwner "Callback to the Component that owns this one";
var(GUIState) editconst GUI.eMenuState MenuState "Used to determine the current state of this component";
var(GUIState) editconst editinline array<export editinline GUIComponent> UndoHistory "Layout history used for undo/redo operations";
var(GUIState) editconst int UndoLevel "Where in the undo history we currently are";
var(GUIState) editconst bool bSaved "Have any updates to this component been saved?";
var(GUIState) editconst bool bInited "has this component been initialized yet";
var() config string StyleName "Name of my Style";
var() config float WinTop;
var() config float WinLeft "Where does this component exist (in world space) - Grr.. damn Left()";
var() config float WinWidth;
var() config float WinHeight "Where does this component exist (in world space) - Grr.. damn Left()";
var() config bool bScaled "Is this component using scaling";
var() config bool bBoundToParent "Use the Parents Bounds for all positioning";
var() config bool bScaleToParent "Use the Parent for scaling";
var() config bool bCanBeShown "Should this control ever be drawn";
var() config bool bAcceptsInput "Does this control ever accept input";
var() config bool bCaptureTabs "This control wants tabs";
var() config bool bCaptureMouse "Set this if the control should capture the mouse when pressed";
var(GUIState) editconst bool bDontReleaseMouse "Set this if the control should hold the mouse (prevent other components from getting a crack while this is the focused control)";
var() config bool bSwallowAllKeyEvents "Set this if the control should swallow all native key events";
var() config bool bHitTestOnClientBounds "Set this if the control should perform hit tests using the client bounds instead of the bounds";
var() config bool bAllowHTMLTextFormatting "If true, this control will parse out HTML style formatting codes from text strings";
var() config bool bDrawStyle "If true, this control will draw its GUIStyle before any further drawing";
var() config bool bNeverFocus "This control should never fully receive focus";
var() config bool bRepeatClick "Have the system accept holding down of the mouse";
var() config bool bRequireReleaseClick "If True, this component wants the click on release even if it's not active";
var() config localized string Hint "The hint that gets displayed for this component";
var() config int MouseCursorIndex "The mouse cursor to use when over this control";
var() config bool bHideMouseCursor "If true, no mouse cursor will be displayed over this control (while the control is active)";
var() config bool bTabStop "Does a TAB/Shift-Tab stop here";
var() config int TabOrder "Used to figure out tabbing";
var() config bool bFocusOnWatch "If true, watching focuses";
var() config bool bMaintainFocus "If true, will not lose focus after a new control recieves focus";
var() config float RenderWeight "Used to determine sorting in the controls stack";
var() config bool bMouseOverSound "Should component bleep when mouse goes over it";
var() export editinline GUIComponent FocusInstead "Who should get the focus instead of this control if bNeverFocus";
var() config bool bPersistent "If set, component is saved across open/close/reopen, only instanciated once.";
var() config bool bFocusWhenReleaseHitTestFails "If set, component tries to receives focus when mouse is released, even if the hit test fails.";
var() config bool bNeverTriggerEffectEvents "If set, component never triggers effect events.";
var(GUIState) editconst bool bVisible "Is this component currently visible";
var(Menu) GUIComponent.EClickSound OnClickSound;
var(GUIState) editconst export editinline GUIStyles Style "My GUI Style";
var float Bounds[4];
var float ClientBounds[4];
var(GUIState) editconst bool bActiveInput "is active for input";
var(GUIState) private editconst bool bDirty "When true, will update the component on its next PreDraw";
var const int TimerIndex;
var(GUIState) editconst bool bTimerRepeat "Does the Timer Repeat?";
var(GUIState) editconst float TimerCountdown "Clock time";
var(GUIState) editconst float TimerInterval "Timer interval";
var() config float Transparency "Transparency of this component";
var float SaveX;
var float SaveY;
var Color SaveColor;
var Font SaveFont;
var byte SaveStyle;
var export editinline GUIComponent LinkOverrides[4];
var export editinline GUIComponent Links[4];
var() export editinline config GUIRadioButton RadioGroup "If not None, this component will be enabled/disabled as part of the specified radio group.";
var() config float ShowPositionDelay;
var(GUIState) editconst name NextPositionLabel;
//var delegate<OnUpdateComponent> __OnUpdateComponent__Delegate;
//var delegate<OnPreDraw> __OnPreDraw__Delegate;
//var delegate<OnDraw> __OnDraw__Delegate;
//var delegate<OnClientDraw> __OnClientDraw__Delegate;
//var delegate<OnMenuStateChanged> __OnMenuStateChanged__Delegate;
//var delegate<OnHide> __OnHide__Delegate;
//var delegate<OnShow> __OnShow__Delegate;
//var delegate<OnActivate> __OnActivate__Delegate;
//var delegate<OnDeActivate> __OnDeActivate__Delegate;
//var delegate<OnChange> __OnChange__Delegate;
//var delegate<OnRePositionCompleted> __OnRePositionCompleted__Delegate;
//var delegate<OnHitTest> __OnHitTest__Delegate;
//var delegate<OnRender> __OnRender__Delegate;
//var delegate<onMessage> __onMessage__Delegate;
//var delegate<OnClick> __OnClick__Delegate;
//var delegate<OnDblClick> __OnDblClick__Delegate;
//var delegate<OnRightClick> __OnRightClick__Delegate;
//var delegate<OnMousePressed> __OnMousePressed__Delegate;
//var delegate<OnMouseRelease> __OnMouseRelease__Delegate;
//var delegate<OnWatched> __OnWatched__Delegate;
//var delegate<OnFocused> __OnFocused__Delegate;
//var delegate<OnLostFocus> __OnLostFocus__Delegate;
//var delegate<OnCapturedMouseMove> __OnCapturedMouseMove__Delegate;
//var delegate<OnKeyType> __OnKeyType__Delegate;
//var delegate<OnKeyEvent> __OnKeyEvent__Delegate;
//var delegate<OnRawXController> __OnRawXController__Delegate;
//var delegate<OnXControllerEvent> __OnXControllerEvent__Delegate;

delegate bool OnUpdateComponent(Canvas Canvas)
{
	return false;
	return;
}

delegate bool OnPreDraw(Canvas Canvas)
{
	return false;
	return;
}

delegate bool OnDraw(Canvas Canvas)
{
	return false;
	return;
}

delegate OnClientDraw(Canvas Canvas)
{
	return;
}

delegate OnMenuStateChanged(GUIComponent Sender, GUI.eMenuState NewState)
{
	return;
}

delegate OnHide()
{
	return;
}

delegate OnShow()
{
	return;
}

delegate OnActivate()
{
	return;
}

delegate OnDeActivate()
{
	return;
}

delegate OnChange(GUIComponent Sender)
{
	return;
}

delegate OnRePositionCompleted(GUIComponent Sender, name NewPosLabel)
{
	return;
}

delegate OnHitTest(float MouseX, float MouseY)
{
	return;
}

delegate OnRender(Canvas Canvas)
{
	return;
}

delegate onMessage(coerce string msg, float MsgLife)
{
	return;
}

delegate OnClick(GUIComponent Sender)
{
	return;
}

delegate OnDblClick(GUIComponent Sender)
{
	return;
}

delegate OnRightClick(GUIComponent Sender)
{
	return;
}

delegate OnMousePressed(GUIComponent Sender)
{
	return;
}

delegate OnMouseRelease(GUIComponent Sender)
{
	return;
}

delegate OnWatched(GUIComponent Self)
{
	return;
}

delegate OnFocused(GUIComponent Self)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(FocusInstead, none), Not_PreBool(FocusInstead.bNeverFocus)))
	{
		FocusInstead.Focus();
	}
	else
	{
		Controller.ChangeFocus(self);
	}
	return;
}

delegate OnLostFocus(GUIComponent Self)
{
	return;
}

delegate bool OnCapturedMouseMove(float deltaX, float deltaY)
{
	return false;
	return;
}

delegate bool OnKeyType(out byte Key, optional string Unicode)
{
	return false;
	return;
}

delegate bool OnKeyEvent(out byte Key, out byte State, float Delta)
{
	return false;
	return;
}

delegate bool OnRawXController(byte Id, out byte Key, out byte State, out float Axis)
{
	return false;
	return;
}

delegate bool OnXControllerEvent(byte Id, GUI.eXControllerCodes iCode)
{
	return false;
	return;
}

event Timer()
{
	if(NotEqual_NameName(NextPositionLabel, 'None'))
	{
		RePosition(NextPositionLabel);
	}
	return;
}

// Export UGUIComponent::execSetTimer(FFrame&, void* const)
native final function SetTimer(float Interval, optional bool bRepeat);

// Export UGUIComponent::execKillTimer(FFrame&, void* const)
native final function KillTimer();

// Export UGUIComponent::execWrapStringToArray(FFrame&, void* const)
native final function WrapStringToArray(string InText, out array<string> WrappedArray, optional string EOL);

overloaded function Construct(GUIController MyController)
{
	OnConstruct(MyController);
	return;
}

function OnConstruct(GUIController MyController)
{
	Controller = MyController;
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	ResetConfig();
	MenuOwner = MyOwner;
	if(AndAnd_BoolBool(EqualEqual_StrStr(Hint, ""), NotEqual_ObjectObject(MenuOwner, none)))
	{
		Hint = MenuOwner.Hint;
	}
	Style = Controller.GetStyle(StyleName);
	SetDirty();
	if(Controller.bModAuthor)
	{
		SaveLayoutToHistory();
	}
	bInited = true;
	return;
}

function InitDelegates()
{
	return;
}

final event SetDirty()
{
	bDirty = true;
	if(NotEqual_ObjectObject(MenuOwner, none))
	{
		MenuOwner.super(GUIComponent).SetDirty();
	}
	return;
}

event MousePressed()
{
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().TriggerEffectEvent('UIMousePressed',,,,,,,, Style.EffectCategory);
	}
	Press();
	OnMousePressed(self);
	return;
}

event MouseReleased()
{
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().TriggerEffectEvent('UIMouseReleased',,,,,,,, Style.EffectCategory);
	}
	OnMouseRelease(self);
	return;
}

event Click()
{
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().TriggerEffectEvent('UIMouseClicked',,,,,,,, Style.EffectCategory);
	}
	OnClick(self);
	return;
}

event DblClick()
{
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().TriggerEffectEvent('UIMouseDoubleClicked',,,,,,,, Style.EffectCategory);
	}
	OnDblClick(self);
	return;
}

event Watched()
{
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().TriggerEffectEvent('UIMouseWatched',,,,,,,, Style.EffectCategory);
	}
	if(bFocusOnWatch)
	{
		MenuStateChange(2);
	}
	else
	{
		MenuStateChange(1);
	}
	OnWatched(self);
	return;
}

event Focus()
{
	if(bNeverFocus)
	{
		MenuStateChange(0);
	}
	else
	{
		MenuStateChange(2);
	}
	return;
}

event Press()
{
	MenuStateChange(3);
	return;
}

function SetEnabled(bool newEnabled)
{
	if(newEnabled)
	{
		EnableComponent();
	}
	else
	{
		DisableComponent();
	}
	return;
}

event DisableComponent()
{
	MenuStateChange(4);
	return;
}

event EnableComponent()
{
	MenuStateChange(0);
	return;
}

function bool IsInBounds()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(Controller.MouseX, Bounds[0]), LessEqual_FloatFloat(Controller.MouseX, Bounds[2])), AndAnd_BoolBool(GreaterEqual_FloatFloat(Controller.MouseY, Bounds[1]), LessEqual_FloatFloat(Controller.MouseY, Bounds[3])));
	return;
}

function bool IsInClientBounds()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(Controller.MouseX, ClientBounds[0]), LessEqual_FloatFloat(Controller.MouseX, ClientBounds[2])), AndAnd_BoolBool(GreaterEqual_FloatFloat(Controller.MouseY, ClientBounds[1]), LessEqual_FloatFloat(Controller.MouseY, ClientBounds[3])));
	return;
}

private function MenuStateChange(GUI.eMenuState NewState)
{
	if(EqualEqual_IntInt(int(NewState), int(2)))
	{
		OnFocused(self);
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(MenuState), int(2)), EqualEqual_IntInt(int(NewState), int(3))), bMaintainFocus))
		{
			return;
		}
		else
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(MenuState), int(2)), NotEqual_IntInt(int(NewState), int(3))))
			{
				OnLostFocus(self);
			}
		}
	}
	if(EqualEqual_IntInt(int(MenuState), int(NewState)))
	{
		return;
	}
	MenuState = NewState;
	OnMenuStateChanged(self, MenuState);
	return;
}

function SetFocusInstead(GUIComponent Other, optional bool bDontPropagate)
{
	FocusInstead = Other;
	if(AndAnd_BoolBool(Not_PreBool(bDontPropagate), NotEqual_ObjectObject(MenuOwner, none)))
	{
		MenuOwner.SetFocusInstead(self, bDontPropagate);
	}
	return;
}

function LoseFocus()
{
	if(AndAnd_BoolBool(Not_PreBool(bMaintainFocus), NotEqual_IntInt(int(MenuState), int(4))))
	{
		EnableComponent();
	}
	return;
}

event SetVisibility(bool newVisible)
{
	if(newVisible)
	{
		Show();
	}
	else
	{
		Hide();
	}
	return;
}

event Hide()
{
	bVisible = false;
	OnHide();
	return;
}

event Show()
{
	if(Not_PreBool(bCanBeShown))
	{
		return;
	}
	if(EqualEqual_IntInt(int(MenuState), int(1)))
	{
		MenuStateChange(0);
	}
	SetDirty();
	if(GreaterEqual_FloatFloat(ShowPositionDelay, 0.0000000))
	{
		RePosition('PreShow', true);
	}
	bVisible = true;
	OnShow();
	if(GreaterEqual_FloatFloat(ShowPositionDelay, 0.0000000))
	{
		RePosition('PostShow', false, ShowPositionDelay);
	}
	return;
}

event SetActive(bool bActive)
{
	if(bActive)
	{
		Activate();
	}
	else
	{
		DeActivate();
	}
	return;
}

event DeActivate()
{
	bActiveInput = false;
	OnDeActivate();
	if(AndAnd_BoolBool(GreaterEqual_IntInt(CyclePosition, 0), Less_IntInt(CyclePosition, MovePositions.Length)))
	{
		StopCycling();
	}
	return;
}

event Activate()
{
	if(Not_PreBool(bAcceptsInput))
	{
		return;
	}
	bActiveInput = true;
	OnActivate();
	if(AndAnd_BoolBool(GreaterEqual_IntInt(CyclePosition, 0), Less_IntInt(CyclePosition, MovePositions.Length)))
	{
		CyclePositions();
	}
	return;
}

function CyclePositions()
{
	AddAdd_Int(CyclePosition);
	if(GreaterEqual_IntInt(CyclePosition, MovePositions.Length))
	{
		if(bRepeatCycling)
		{
			CyclePosition = 0;
		}
		else
		{
			StopCycling();
			return;
		}
	}
	RePositionTo(MovePositions[CyclePosition]);
	return;
}

function StopCycling()
{
	CyclePosition = -1;
	KillTimer();
	return;
}

event RePositionCompleted()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)), NotEqual_ObjectObject(PlayerOwner(), none)))
	{
		PlayerOwner().AddContextForNextEffectEvent(TransitionSpec.NewPos.KeyName);
		PlayerOwner().TriggerEffectEvent('UIRepositionCompleted',,,,,,,, Style.EffectCategory);
	}
	OnRePositionCompleted(self, TransitionSpec.NewPos.KeyName);
	if(AndAnd_BoolBool(GreaterEqual_IntInt(CyclePosition, 0), Less_IntInt(CyclePosition, MovePositions.Length)))
	{
		CyclePositions();
	}
	return;
}

function RePosition(name PositionLabel, optional bool bInstantly, optional float DelayBeforeRepositioning)
{
	local int i;

	if(Greater_FloatFloat(DelayBeforeRepositioning, 0.0000000))
	{
		NextPositionLabel = PositionLabel;
		SetTimer(DelayBeforeRepositioning);
		return;
	}
	NextPositionLabel = 'None';
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().AddContextForNextEffectEvent(PositionLabel);
		PlayerOwner().TriggerEffectEvent('UIRepositionStarted',,,,,,,, Style.EffectCategory);
	}
	i = 0;
	J0x90:

	if(Less_IntInt(i, MovePositions.Length))
	{
		if(EqualEqual_NameName(PositionLabel, MovePositions[i].KeyName))
		{
			if(bInstantly)
			{
				bRepositioning = false;
				Transparency = MovePositions[i].Transparency;
				WinLeft = MovePositions[i].WinLeft;
				WinTop = MovePositions[i].WinTop;
				WinWidth = MovePositions[i].WinWidth;
				WinHeight = MovePositions[i].WinHeight;
				TransitionSpec.NewPos = MovePositions[i];
				RePositionCompleted();
			}
			else
			{
				RePositionTo(MovePositions[i]);
			}
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x90;
	}
	return;
}

protected function RePositionTo(sDynamicPositionSpec NewPosition)
{
	TransitionSpec.OldTransparency = Transparency;
	TransitionSpec.OldWinLeft = WinLeft;
	TransitionSpec.OldWinTop = WinTop;
	TransitionSpec.OldWinHeight = WinHeight;
	TransitionSpec.OldWinWidth = WinWidth;
	TransitionSpec.NewPos = NewPosition;
	bRepositioning = true;
	if(Greater_FloatFloat(TransitionSpec.NewPos.TransitionTime, float(0)))
	{
		SetTimer(TransitionSpec.NewPos.TransitionTime);
	}
	else
	{
		bRepositioning = false;
		Transparency = NewPosition.Transparency;
		WinLeft = NewPosition.WinLeft;
		WinTop = NewPosition.WinTop;
		WinWidth = NewPosition.WinWidth;
		WinHeight = NewPosition.WinHeight;
		SetDirty();
		RePositionCompleted();
	}
	return;
}

function bool IsAtPosition(name PositionLabel)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MovePositions.Length))
	{
		if(EqualEqual_NameName(PositionLabel, MovePositions[i].KeyName))
		{
			return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_FloatFloat(WinLeft, MovePositions[i].WinLeft), EqualEqual_FloatFloat(WinTop, MovePositions[i].WinTop)), EqualEqual_FloatFloat(WinWidth, MovePositions[i].WinWidth)), EqualEqual_FloatFloat(WinHeight, MovePositions[i].WinHeight));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function RegisterNotifyResolutionChanged()
{
	Controller.RegisterNotifyResolutionChanged(self);
	return;
}

function OnResolutionChanged(int OldResolutionX, int OldResolutionY, int ResolutionX, int ResolutionY)
{
	return;
}

event Free(optional bool bForce)
{
	local int i;

	if(AndAnd_BoolBool(bPersistent, Not_PreBool(bForce)))
	{
		return;
	}
	bActiveInput = false;
	bVisible = false;
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.RemovePersistentComponent(self);
	}
	MenuOwner = none;
	Controller = none;
	FocusInstead = none;
	Style = none;
	i = 0;
	J0x66:

	if(Less_IntInt(i, UndoHistory.Length))
	{
		UndoHistory[i].Free(bForce);
		UndoHistory[i] = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x66;
	}
	UndoHistory.Remove(0, UndoHistory.Length);
	RadioGroup = none;
	return;
}

function PlayerController PlayerOwner()
{
	return Controller.ViewportOwner.Actor;
	return;
}

function FillOwner()
{
	WinLeft = 0.0000000;
	WinTop = 0.0000000;
	WinWidth = 1.0000000;
	WinHeight = 1.0000000;
	bScaleToParent = true;
	bBoundToParent = true;
	SetDirty();
	return;
}

function SetLinks(GUIComponent cUp, GUIComponent cDown, GUIComponent cLeft, GUIComponent cRight)
{
	Links[0] = cUp;
	Links[1] = cDown;
	Links[2] = cLeft;
	Links[3] = cRight;
	SetDirty();
	return;
}

function SetLinkOverrides(GUIComponent cUp, GUIComponent cDown, GUIComponent cLeft, GUIComponent cRight)
{
	LinkOverrides[0] = cUp;
	LinkOverrides[1] = cDown;
	LinkOverrides[2] = cLeft;
	LinkOverrides[3] = cRight;
	SetDirty();
	return;
}

// Export UGUIComponent::execActualWidth(FFrame&, void* const)
native function float ActualWidth();

// Export UGUIComponent::execActualHeight(FFrame&, void* const)
native function float ActualHeight();

// Export UGUIComponent::execActualLeft(FFrame&, void* const)
native function float ActualLeft();

// Export UGUIComponent::execActualTop(FFrame&, void* const)
native function float ActualTop();

function SetRadioGroup(GUIRadioButton Group)
{
	if(NotEqual_ObjectObject(RadioGroup, none))
	{
		SetEnabled(EqualEqual_ObjectObject(RadioGroup, Group));
	}
	return;
}

function SaveLayout(bool FlushToDisk)
{
	SaveConfig("", "", FlushToDisk, true);
	bSaved = true;
	return;
}

function SaveLayoutToHistory()
{
	local int i;

	if(Less_IntInt(Add_IntInt(UndoLevel, 1), UndoHistory.Length))
	{
		UndoHistory.Remove(Add_IntInt(UndoLevel, 1), Subtract_IntInt(UndoHistory.Length, Add_IntInt(UndoLevel, 1)));
	}
	i = UndoHistory.Length;
	UndoHistory[i] = self.Class.static.Allocate(self, none).;
	Construct_Void();
	self.CopyConfig(UndoHistory[i]);
	return;
}

function LoadLayoutFromHistory()
{
	UndoHistory[UndoLevel].CopyConfig(self);
	Style = Controller.GetStyle(StyleName);
	return;
}

function UndoLayout()
{
	AssertWithDescription(Greater_IntInt(UndoLevel, 0), "Cannot perform Undo on this component!");
	if(Greater_IntInt(UndoLevel, 0))
	{
		SubtractEqual_IntInt(UndoLevel, 1);
		LoadLayoutFromHistory();
	}
	return;
}

function RedoLayout()
{
	AssertWithDescription(Less_IntInt(UndoLevel, Subtract_IntInt(UndoHistory.Length, 1)), "Cannot perform Redo on this component!");
	if(Less_IntInt(UndoLevel, Subtract_IntInt(UndoHistory.Length, 1)))
	{
		AddEqual_IntInt(UndoLevel, 1);
		LoadLayoutFromHistory();
	}
	return;
}

event ChangeStyle(string NewStyle)
{
	StyleName = NewStyle;
	Style = Controller.GetStyle(StyleName);
	OnChangeLayout();
	return;
}

event OnChangeLayout()
{
	SetDirty();
	SaveLayoutToHistory();
	UndoLevel = Subtract_IntInt(UndoHistory.Length, 1);
	bSaved = false;
	return;
}

final function bool KeyMatchesBinding(byte Key, string Binding)
{
	local string InKey, SelectKey;

	InKey = PlayerOwner().ConsoleCommand(At_StrStr("KEYNAME", string(Key)));
	SelectKey = PlayerOwner().ConsoleCommand(At_StrStr("GETKEYFORBINDING", Binding));
	J0x57:

	if(NotEqual_StrStr(SelectKey, ""))
	{
		if(EqualEqual_StrStr(InKey, GetFirstField(SelectKey, ", ")))
		{
			return true;
		}
		// [Loop Continue]
		goto J0x57;
	}
	return false;
	return;
}

final function string ReplaceKeybindingCodes(string in, string OpenKeybindingCode, string CloseKeybindingCode)
{
	local string FunctionString, IntroString, KeyString, FirstKeyString;

	IntroString = GetFirstField(in, OpenKeybindingCode);
	if(EqualEqual_StrStr(in, ""))
	{
		return IntroString;
	}
	FunctionString = GetFirstField(in, CloseKeybindingCode);
	if(EqualEqual_StrStr(in, ""))
	{
		return Concat_StrStr(Concat_StrStr(IntroString, OpenKeybindingCode), FunctionString);
	}
	KeyString = PlayerOwner().ConsoleCommand(At_StrStr("GETLOCALIZEDKEYFORBINDING", FunctionString));
	FirstKeyString = GetFirstField(KeyString, ",");
	return super(GUIComponent).ReplaceKeybindingCodes(Concat_StrStr(Concat_StrStr(IntroString, FirstKeyString), in), OpenKeybindingCode, CloseKeybindingCode);
	return;
}

defaultproperties
{
	CyclePosition=-1
	MoveGroup=-1
	bSaved=true
	WinTop=0.4000000
	WinLeft=0.4000000
	WinWidth=0.2000000
	WinHeight=0.2000000
	bScaled=true
	bBoundToParent=true
	bScaleToParent=true
	bCanBeShown=true
	bAcceptsInput=true
	RenderWeight=0.5000000
	TimerIndex=-1
	Transparency=1.0000000
	ShowPositionDelay=-1.0000000
}