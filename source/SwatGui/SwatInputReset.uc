class SwatInputReset extends Object
	config(DefUser);

var config string LeftMouse;
var config string RightMouse;
var config string MiddleMouse;
var config string tab;
var config string Enter;
var config string Shift;
var config string Ctrl;
var config string Alt;
var config string Pause;
var config string CapsLock;
var config string Escape;
var config string Space;
var config string PageDown;
var config string End;
var config string Left;
var config string Up;
var config string Right;
var config string Down;
var config string Insert;
var config string Delete;
var config string C;
var config string Q;
var config string E;
var config string G;
var config string H;
var config string L;
var config string M;
var config string O;
var config string P;
var config string S;
var config string t;
var config string X;
var config string Z;
var config string F1;
var config string F2;
var config string F3;
var config string F4;
var config string F5;
var config string F6;
var config string F7;
var config string F8;
var config string F9;
var config string F10;
var config string F11;
var config string F12;
var config string Equals;
var config string Comma;
var config string Minus;
var config string Period;
var config string Slash;
var config string LeftBracket;
var config string Backslash;
var config string RightBracket;
var config string MouseX;
var config string MouseY;
var config string MouseW;
var config string Cancel;
var config string Backspace;
var config string PageUp;
var config string home;
var config string Select;
var config string Print;
var config string execute;
var config string PrintScrn;
var config string Help;
var config string Key1;
var config string Key2;
var config string Key3;
var config string Key4;
var config string Key5;
var config string Key6;
var config string Key7;
var config string Key8;
var config string Key9;
var config string Key0;
var config string A;
var config string B;
var config string n;
var config string D;
var config string F;
var config string i;
var config string j;
var config string k;
var config string R;
var config string U;
var config string V;
var config string W;
var config string Y;
var config string NumPad0;
var config string NumPad1;
var config string NumPad2;
var config string NumPad3;
var config string NumPad4;
var config string NumPad5;
var config string NumPad6;
var config string NumPad7;
var config string NumPad8;
var config string NumPad9;
var config string GreyStar;
var config string Separator;
var config string NumPadPeriod;
var config string GreySlash;
var config string F13;
var config string F14;
var config string F15;
var config string F16;
var config string F17;
var config string F18;
var config string F19;
var config string F20;
var config string F21;
var config string F22;
var config string F23;
var config string F24;
var config string NumLock;
var config string ScrollLock;
var config string LShift;
var config string RShift;
var config string LControl;
var config string RControl;
var config string Semicolon;
var config string Tilde;
var config string SingleQuote;
var config string Attn;
var config string CrSel;
var config string ExSel;
var config string ErEof;
var config string Play;
var config string Zoom;
var config string NoName;
var config string PA1;
var config string OemClear;
var config string MouseZ;
var config string MouseWheelDown;
var config string MouseWheelUp;
var config string Joy1;
var config string Joy2;
var config string Joy3;
var config string Joy4;
var config string Joy5;
var config string Joy6;
var config string Joy7;
var config string Joy8;
var config string Joy9;
var config string Joy10;
var config string Joy11;
var config string Joy12;
var config string Joy13;
var config string Joy14;
var config string Joy15;
var config string Joy16;
var config string JoyX;
var config string JoyY;
var config string JoyZ;
var config string JoyR;
var config string JoyU;
var config string JoyV;
var config string JoySlider1;
var config string JoySlider2;

overloaded function Construct(GUIController Controller)
{
	Controller.StaticExec(At_StrStr("SET Input LeftMouse", LeftMouse));
	Controller.StaticExec(At_StrStr("SET Input RightMouse", RightMouse));
	Controller.StaticExec(At_StrStr("SET Input MiddleMouse", MiddleMouse));
	Controller.StaticExec(At_StrStr("SET Input Tab", tab));
	Controller.StaticExec(At_StrStr("SET Input Enter", Enter));
	Controller.StaticExec(At_StrStr("SET Input Shift", Shift));
	Controller.StaticExec(At_StrStr("SET Input Ctrl", Ctrl));
	Controller.StaticExec(At_StrStr("SET Input Alt", Alt));
	Controller.StaticExec(At_StrStr("SET Input Pause", Pause));
	Controller.StaticExec(At_StrStr("SET Input CapsLock", CapsLock));
	Controller.StaticExec(At_StrStr("SET Input Escape", Escape));
	Controller.StaticExec(At_StrStr("SET Input Space", Space));
	Controller.StaticExec(At_StrStr("SET Input PageDown", PageDown));
	Controller.StaticExec(At_StrStr("SET Input End", End));
	Controller.StaticExec(At_StrStr("SET Input Left", Left));
	Controller.StaticExec(At_StrStr("SET Input Up", Up));
	Controller.StaticExec(At_StrStr("SET Input Right", Right));
	Controller.StaticExec(At_StrStr("SET Input Down", Down));
	Controller.StaticExec(At_StrStr("SET Input Insert", Insert));
	Controller.StaticExec(At_StrStr("SET Input Delete", Delete));
	Controller.StaticExec(At_StrStr("SET Input C", C));
	Controller.StaticExec(At_StrStr("SET Input Q", Q));
	Controller.StaticExec(At_StrStr("SET Input E", E));
	Controller.StaticExec(At_StrStr("SET Input G", G));
	Controller.StaticExec(At_StrStr("SET Input H", H));
	Controller.StaticExec(At_StrStr("SET Input L", L));
	Controller.StaticExec(At_StrStr("SET Input M", M));
	Controller.StaticExec(At_StrStr("SET Input O", O));
	Controller.StaticExec(At_StrStr("SET Input P", P));
	Controller.StaticExec(At_StrStr("SET Input S", S));
	Controller.StaticExec(At_StrStr("SET Input T", t));
	Controller.StaticExec(At_StrStr("SET Input X", X));
	Controller.StaticExec(At_StrStr("SET Input Z", Z));
	Controller.StaticExec(At_StrStr("SET Input F1", F1));
	Controller.StaticExec(At_StrStr("SET Input F2", F2));
	Controller.StaticExec(At_StrStr("SET Input F3", F3));
	Controller.StaticExec(At_StrStr("SET Input F4", F4));
	Controller.StaticExec(At_StrStr("SET Input F5", F5));
	Controller.StaticExec(At_StrStr("SET Input F6", F6));
	Controller.StaticExec(At_StrStr("SET Input F7", F7));
	Controller.StaticExec(At_StrStr("SET Input F8", F8));
	Controller.StaticExec(At_StrStr("SET Input F9", F9));
	Controller.StaticExec(At_StrStr("SET Input F10", F10));
	Controller.StaticExec(At_StrStr("SET Input F11", F11));
	Controller.StaticExec(At_StrStr("SET Input F12", F12));
	Controller.StaticExec(At_StrStr("SET Input Equals", Equals));
	Controller.StaticExec(At_StrStr("SET Input Comma", Comma));
	Controller.StaticExec(At_StrStr("SET Input Minus", Minus));
	Controller.StaticExec(At_StrStr("SET Input Period", Period));
	Controller.StaticExec(At_StrStr("SET Input Slash", Slash));
	Controller.StaticExec(At_StrStr("SET Input LeftBracket", LeftBracket));
	Controller.StaticExec(At_StrStr("SET Input Backslash", Backslash));
	Controller.StaticExec(At_StrStr("SET Input RightBracket", RightBracket));
	Controller.StaticExec(At_StrStr("SET Input MouseX", MouseX));
	Controller.StaticExec(At_StrStr("SET Input MouseY", MouseY));
	Controller.StaticExec(At_StrStr("SET Input MouseW", MouseW));
	Controller.StaticExec(At_StrStr("SET Input Cancel", Cancel));
	Controller.StaticExec(At_StrStr("SET Input Backspace", Backspace));
	Controller.StaticExec(At_StrStr("SET Input PageUp", PageUp));
	Controller.StaticExec(At_StrStr("SET Input home", home));
	Controller.StaticExec(At_StrStr("SET Input Select", Select));
	Controller.StaticExec(At_StrStr("SET Input Print", Print));
	Controller.StaticExec(At_StrStr("SET Input Execute", execute));
	Controller.StaticExec(At_StrStr("SET Input PrintScrn", PrintScrn));
	Controller.StaticExec(At_StrStr("SET Input Help", Help));
	Controller.StaticExec(At_StrStr("SET Input 1", Key1));
	Controller.StaticExec(At_StrStr("SET Input 2", Key2));
	Controller.StaticExec(At_StrStr("SET Input 3", Key3));
	Controller.StaticExec(At_StrStr("SET Input 4", Key4));
	Controller.StaticExec(At_StrStr("SET Input 5", Key5));
	Controller.StaticExec(At_StrStr("SET Input 6", Key6));
	Controller.StaticExec(At_StrStr("SET Input 7", Key7));
	Controller.StaticExec(At_StrStr("SET Input 8", Key8));
	Controller.StaticExec(At_StrStr("SET Input 9", Key9));
	Controller.StaticExec(At_StrStr("SET Input 0", Key0));
	Controller.StaticExec(At_StrStr("SET Input A", A));
	Controller.StaticExec(At_StrStr("SET Input B", B));
	Controller.StaticExec(At_StrStr("SET Input N", n));
	Controller.StaticExec(At_StrStr("SET Input D", D));
	Controller.StaticExec(At_StrStr("SET Input F", F));
	Controller.StaticExec(At_StrStr("SET Input i", i));
	Controller.StaticExec(At_StrStr("SET Input j", j));
	Controller.StaticExec(At_StrStr("SET Input K", k));
	Controller.StaticExec(At_StrStr("SET Input R", R));
	Controller.StaticExec(At_StrStr("SET Input U", U));
	Controller.StaticExec(At_StrStr("SET Input V", V));
	Controller.StaticExec(At_StrStr("SET Input W", W));
	Controller.StaticExec(At_StrStr("SET Input Y", Y));
	Controller.StaticExec(At_StrStr("SET Input NumPad0", NumPad0));
	Controller.StaticExec(At_StrStr("SET Input NumPad1", NumPad1));
	Controller.StaticExec(At_StrStr("SET Input NumPad2", NumPad2));
	Controller.StaticExec(At_StrStr("SET Input NumPad3", NumPad3));
	Controller.StaticExec(At_StrStr("SET Input NumPad4", NumPad4));
	Controller.StaticExec(At_StrStr("SET Input NumPad5", NumPad5));
	Controller.StaticExec(At_StrStr("SET Input NumPad6", NumPad6));
	Controller.StaticExec(At_StrStr("SET Input NumPad7", NumPad7));
	Controller.StaticExec(At_StrStr("SET Input NumPad8", NumPad8));
	Controller.StaticExec(At_StrStr("SET Input NumPad9", NumPad9));
	Controller.StaticExec(At_StrStr("SET Input GreyStar", GreyStar));
	Controller.StaticExec(At_StrStr("SET Input Separator", Separator));
	Controller.StaticExec(At_StrStr("SET Input NumPadPeriod", NumPadPeriod));
	Controller.StaticExec(At_StrStr("SET Input GreySlash", GreySlash));
	Controller.StaticExec(At_StrStr("SET Input F13", F13));
	Controller.StaticExec(At_StrStr("SET Input F14", F14));
	Controller.StaticExec(At_StrStr("SET Input F15", F15));
	Controller.StaticExec(At_StrStr("SET Input F16", F16));
	Controller.StaticExec(At_StrStr("SET Input F17", F17));
	Controller.StaticExec(At_StrStr("SET Input F18", F18));
	Controller.StaticExec(At_StrStr("SET Input F19", F19));
	Controller.StaticExec(At_StrStr("SET Input F20", F20));
	Controller.StaticExec(At_StrStr("SET Input F21", F21));
	Controller.StaticExec(At_StrStr("SET Input F22", F22));
	Controller.StaticExec(At_StrStr("SET Input F23", F23));
	Controller.StaticExec(At_StrStr("SET Input F24", F24));
	Controller.StaticExec(At_StrStr("SET Input NumLock", NumLock));
	Controller.StaticExec(At_StrStr("SET Input ScrollLock", ScrollLock));
	Controller.StaticExec(At_StrStr("SET Input LShift", LShift));
	Controller.StaticExec(At_StrStr("SET Input RShift", RShift));
	Controller.StaticExec(At_StrStr("SET Input LControl", LControl));
	Controller.StaticExec(At_StrStr("SET Input RControl", RControl));
	Controller.StaticExec(At_StrStr("SET Input Semicolon", Semicolon));
	Controller.StaticExec(At_StrStr("SET Input Tilde", Tilde));
	Controller.StaticExec(At_StrStr("SET Input SingleQuote", SingleQuote));
	Controller.StaticExec(At_StrStr("SET Input Attn", Attn));
	Controller.StaticExec(At_StrStr("SET Input CrSel", CrSel));
	Controller.StaticExec(At_StrStr("SET Input ExSel", ExSel));
	Controller.StaticExec(At_StrStr("SET Input ErEof", ErEof));
	Controller.StaticExec(At_StrStr("SET Input Play", Play));
	Controller.StaticExec(At_StrStr("SET Input Zoom", Zoom));
	Controller.StaticExec(At_StrStr("SET Input NoName", NoName));
	Controller.StaticExec(At_StrStr("SET Input PA1", PA1));
	Controller.StaticExec(At_StrStr("SET Input OemClear", OemClear));
	Controller.StaticExec(At_StrStr("SET Input MouseZ", MouseZ));
	Controller.StaticExec(At_StrStr("SET Input MouseWheelDown", MouseWheelDown));
	Controller.StaticExec(At_StrStr("SET Input MouseWheelUp", MouseWheelUp));
	Controller.StaticExec(At_StrStr("SET Input Joy1", Joy1));
	Controller.StaticExec(At_StrStr("SET Input Joy2", Joy2));
	Controller.StaticExec(At_StrStr("SET Input Joy3", Joy3));
	Controller.StaticExec(At_StrStr("SET Input Joy4", Joy4));
	Controller.StaticExec(At_StrStr("SET Input Joy5", Joy5));
	Controller.StaticExec(At_StrStr("SET Input Joy6", Joy6));
	Controller.StaticExec(At_StrStr("SET Input Joy7", Joy7));
	Controller.StaticExec(At_StrStr("SET Input Joy8", Joy8));
	Controller.StaticExec(At_StrStr("SET Input Joy9", Joy9));
	Controller.StaticExec(At_StrStr("SET Input Joy10", Joy10));
	Controller.StaticExec(At_StrStr("SET Input Joy11", Joy11));
	Controller.StaticExec(At_StrStr("SET Input Joy12", Joy12));
	Controller.StaticExec(At_StrStr("SET Input Joy13", Joy13));
	Controller.StaticExec(At_StrStr("SET Input Joy14", Joy14));
	Controller.StaticExec(At_StrStr("SET Input Joy15", Joy15));
	Controller.StaticExec(At_StrStr("SET Input Joy16", Joy16));
	Controller.StaticExec(At_StrStr("SET Input JoyX", JoyX));
	Controller.StaticExec(At_StrStr("SET Input JoyY", JoyY));
	Controller.StaticExec(At_StrStr("SET Input JoyZ", JoyZ));
	Controller.StaticExec(At_StrStr("SET Input JoyR", JoyR));
	Controller.StaticExec(At_StrStr("SET Input JoyU", JoyU));
	Controller.StaticExec(At_StrStr("SET Input JoyV", JoyV));
	Controller.StaticExec(At_StrStr("SET Input JoySlider1", JoySlider1));
	Controller.StaticExec(At_StrStr("SET Input JoySlider2", JoySlider2));
	return;
}

defaultproperties
{
	LeftMouse="Fire"
	RightMouse="OpenGraphicCommandInterface | RightMouseAlias"
	MiddleMouse="IssueComplianceOrInteract"
	tab="CommandInterfaceNextGroup"
	Shift="ToggleRunning 0"
	Pause="GUICloseMenu"
	CapsLock="ControlViewportAlias"
	Escape="GUICloseMenu"
	Space="GiveDefaultCommand"
	End="HideViewport"
	Up="ScrollChatUp"
	Down="ScrollChatDown"
	Insert="ShowViewport Red"
	Delete="CycleOfficer"
	C="Duck"
	Q="LeanLeft"
	E="LeanRight"
	G="Grab"
	H="EquipSlot 11"
	M="ShowInGamePopup"
	O="ShowInGamePopup"
	S="MoveBackward"
	t="OpenHudChat 1"
	X="NextFireMode"
	Z="ToggleZoom"
	F1="CommandOrEquip Row_FunctionKeys 1"
	F2="CommandOrEquip Row_FunctionKeys 2"
	F3="CommandOrEquip Row_FunctionKeys 3"
	F4="CommandOrEquip Row_FunctionKeys 4"
	F5="CommandOrEquip Row_FunctionKeys 5"
	F6="CommandOrEquip Row_FunctionKeys 6"
	F7="CommandOrEquip Row_FunctionKeys 7"
	F8="CommandOrEquip Row_FunctionKeys 8"
	F9="CommandOrEquip Row_FunctionKeys 9"
	F10="CommandOrEquip Row_FunctionKeys 10"
	Equals="GrowHUD"
	Comma="StrafeLeft"
	Minus="Dash"
	Period="StrafeRight"
	Slash="NextWeapon"
	LeftBracket="InventoryPrevious"
	Backslash="ChangeHud"
	RightBracket="InventoryNext"
	MouseX="Count bXAxis | Axis aMouseX Speed=6.0 "
	MouseY="Count bYAxis | Axis aMouseY Speed=6.0"
	Backspace="PlayerCommandInterfaceBack"
	PageUp="ShowViewport Sniper"
	home="ShowViewport Blue"
	Key1="CommandOrEquip Row_NumberKeys 1"
	Key2="CommandOrEquip Row_NumberKeys 2"
	Key3="CommandOrEquip Row_NumberKeys 3"
	Key4="CommandOrEquip Row_NumberKeys 4"
	Key5="CommandOrEquip Row_NumberKeys 5"
	Key6="CommandOrEquip Row_NumberKeys 6"
	Key7="CommandOrEquip Row_NumberKeys 7"
	Key8="CommandOrEquip Row_NumberKeys 8"
	Key9="CommandOrEquip Row_NumberKeys 9"
	Key0="CommandOrEquip Row_NumberKeys 10"
	A="StrafeLeft"
	B="ShowInGamePopup"
	D="StrafeRight"
	F="IssueComplianceOrInteract"
	R="Reload"
	V="ToggleFlashlight"
	W="MoveForward"
	Y="OpenHudChat 0"
	NumPad0="HideViewport"
	NumPad1="ShowViewport Red"
	NumPad2="ShowViewport Blue"
	NumPad3="ShowViewport Sniper"
	NumPadPeriod="Duck"
	GreySlash="shot"
	SingleQuote="Strafe"
	MouseWheelDown="ScrollCommand Down"
	MouseWheelUp="ScrollCommand Up"
}