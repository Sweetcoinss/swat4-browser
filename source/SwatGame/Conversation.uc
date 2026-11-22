class Conversation extends Object implements IEffectObserver
	native
	config(Conversations)
	perobjectconfig;

struct native DialogLine
{
	var config name Speaker;
	var config name Speech;
	var bool Skippable;
	var config float DelayAfter;
};

var config array<DialogLine> Line;
var private int CurrentLineIndex;
var private float CurrentDelay;
var private Actor CurrentSpeaker;
var private bool bShouldCurrentSpeakerMoveMouth;
var private SoundEffectsSubsystem SoundEffectsSubsystem;
var private ConversationManager Manager;
//var delegate<OnConversationEnded> __OnConversationEnded__Delegate;

function Start(ConversationManager inManager)
{
	Log(Concat_StrStr("[CONVERSATION] Starting Conversation ", string(Name)));
	Manager = inManager;
	SoundEffectsSubsystem = SoundEffectsSubsystem(EffectsSystem(Manager.Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem'));
	AssertWithDescription(NotEqual_ObjectObject(SoundEffectsSubsystem, none), "[tcohen] Conversation::Start() couldn't locate the SoundEffectsSubsystem.");
	StartLine();
	return;
}

function StartLine()
{
	local float SpeakerDistance;
	local Pawn PlayerPawn;
	local SoundEffectSpecification SoundEffectSpec;

	CurrentDelay = Manager.DefaultInterLineDelay;
	if(Greater_FloatFloat(Line[CurrentLineIndex].DelayAfter, float(0)))
	{
		CurrentDelay = Line[CurrentLineIndex].DelayAfter;
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CONVERSATION] Conversation ", string(Name)), " starting Line #"), string(CurrentLineIndex)), " (base zero)"));
	bShouldCurrentSpeakerMoveMouth = true;
	CurrentSpeaker = LocateAvailableSpeaker(Line[CurrentLineIndex].Speaker);
	if(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentSpeaker, none), CurrentSpeaker.bDeleteMe))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CONVERSATION] Conversation ", string(Name)), " Line #"), string(CurrentLineIndex)), ": "), string(Line[CurrentLineIndex].Speaker)), " could not be located."));
		HandleUnavailableSpeaker();
		return;
	}
	if(NotEqual_ObjectObject(Manager.Level.GetLocalPlayerController(), none))
	{
		PlayerPawn = Manager.Level.GetLocalPlayerController().Pawn;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(PlayerPawn, none), Not_PreBool(Class'Engine.Pawn'.static.checkConscious(PlayerPawn))))
	{
		return;
	}
	SpeakerDistance = GetSoundPropagationDistance(PlayerPawn, CurrentSpeaker.Location);
	SoundEffectSpec = SoundEffectSpecification(SoundEffectsSubsystem.FindEffectSpecification(Line[CurrentLineIndex].Speech));
	AssertWithDescription(NotEqual_ObjectObject(SoundEffectSpec, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] Conversation::StartLine() The Conversation named ", string(Name)), " tried to find the Speech named "), string(Line[CurrentLineIndex].Speech)), " specified in Line #"), string(CurrentLineIndex)), " (base zero), but that SoundEffectSpecification was not found."));
	if(AndAnd_BoolBool(Not_PreBool(SoundEffectSpec.IsLocal()), Less_FloatFloat(SoundEffectSpec.GetOuterRadius(), SpeakerDistance)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CONVERSATION] Conversation ", string(Name)), " Line #"), string(CurrentLineIndex)), ": "), string(Line[CurrentLineIndex].Speaker)), " is too far away to speak his/her Line (SpeakerDistance="), string(SpeakerDistance)), ", "), string(SoundEffectSpec.Name)), ".OuterRadius="), string(SoundEffectSpec.GetOuterRadius())), "."));
		HandleUnavailableSpeaker();
		return;
	}
	SoundEffectsSubsystem.PlayEffectSpecification(SoundEffectSpec, CurrentSpeaker,,,,, self);
	return;
}

function Actor LocateAvailableSpeaker(name SpeakerLabel)
{
	local Actor Speaker;

	SubstituteSpeakerAliases(SpeakerLabel);
	Speaker = Manager.findStaticByLabel(Class'Engine.Actor', SpeakerLabel);
	if(EqualEqual_ObjectObject(Speaker, none))
	{
		return none;
	}
	if(AndAnd_BoolBool(Speaker.IsA('Pawn'), Not_PreBool(Pawn(Speaker).IsConscious())))
	{
		return none;
	}
	return Speaker;
	return;
}

function SubstituteSpeakerAliases(out name SpeakerLabel)
{
	switch(SpeakerLabel)
	{
		case 'TOC':
			SpeakerLabel = 'Player';
			bShouldCurrentSpeakerMoveMouth = false;
			break;
		default:
			break;
	}
	return;
}

function HandleUnavailableSpeaker()
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CONVERSATION] Conversation ", string(Name)), " Line #"), string(CurrentLineIndex)), ": "), string(Line[CurrentLineIndex].Speaker)), " is unavailable to speak his/her Line."));
	if(Line[CurrentLineIndex].Skippable)
	{
		GotoState('DelayingUntilNextLine');
	}
	else
	{
		OnConversationEnded(self, false);
	}
	return;
}

function HandleInterruptedSpeaker()
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CONVERSATION] Conversation ", string(Name)), " Line #"), string(CurrentLineIndex)), ": "), string(Line[CurrentLineIndex].Speaker)), " was interrupted."));
	HandleUnavailableSpeaker();
	return;
}

delegate OnConversationEnded(Conversation Conversation, bool Completed)
{
	return;
}

// Export UConversation::execGetSoundPropagationDistance(FFrame&, void* const)
native function float GetSoundPropagationDistance(Actor Listener, Vector SoundLocation);

function OnEffectStarted(Actor inStartedEffect)
{
	local SwatPawn CurrentSwatPawnSpeaker;

	if(bShouldCurrentSpeakerMoveMouth)
	{
		CurrentSwatPawnSpeaker = SwatPawn(CurrentSpeaker);
		if(NotEqual_ObjectObject(CurrentSwatPawnSpeaker, none))
		{
			CurrentSwatPawnSpeaker.StartMouthMovement();
		}
	}
	return;
}

function OnEffectStopped(Actor inStoppedEffect, bool Completed)
{
	local SwatPawn CurrentSwatPawnSpeaker;

	if(bShouldCurrentSpeakerMoveMouth)
	{
		CurrentSwatPawnSpeaker = SwatPawn(CurrentSpeaker);
		if(NotEqual_ObjectObject(CurrentSwatPawnSpeaker, none))
		{
			CurrentSwatPawnSpeaker.StopMouthMovement();
		}
	}
	if(Completed)
	{
		GotoState('DelayingUntilNextLine');
	}
	else
	{
		HandleInterruptedSpeaker();
	}
	return;
}

function OnEffectInitialized(Actor inInitializedEffect)
{
	return;
}

function CleanupActorRefs()
{
	Manager = none;
	CurrentSpeaker = none;
	return;
}

state DelayingUntilNextLine
{Begin:

	Sleep(CurrentDelay);
	AddAdd_Int(CurrentLineIndex);
	if(Less_IntInt(CurrentLineIndex, Line.Length))
	{
		StartLine();
	}
	else
	{
		OnConversationEnded(self, true);
	}
	stop;
}
