class ReactiveAnimatedMesh extends ReactiveWorldObject
	native
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

enum WhenDone
{
	WhenDone_Idle,                  // 0
	WhenDone_LoopLastAnimationSet,  // 1
	WhenDone_RepeatFromStart,       // 2
	WhenDone_Freeze,                // 3
	WhenDone_Destroy                // 4
};

struct native AnimatedMeshAttachment
{
	var() StaticMesh Attachment;
	var() name Socket;
};

struct native PreCreatedAttachment
{
	var() name Label;
	var() name Socket;
};

var array<string> ExtraAnimationSets "If you want your ReactiveAnimatedMesh to play any animations that are not in the default (first) Animation Set for the selected Mesh, then you must add to this list any other Animation Sets that you will use.  Each entry should look like {AnimationPackageName}.{AnimationSetName}";
var export editinline ScriptedAnimationSet Idle "If an Idle AnimationSet is specified, then the ScriptedMesh will Idle until Triggered.";
var export editinline array<export editinline ScriptedAnimationSet> ScriptedSequence "This is a list of ExtraAnimationSets that will be played in order.";
var ReactiveAnimatedMesh.WhenDone WhenDoneDo "What should this ScriptedMesh do when its done playing all ScriptedSequences";
var editinline array<editinline AnimatedMeshAttachment> AnimatedMeshAttachments;
var array<AnimatedMeshAttachmentModel> AnimatedMeshAttachmentModels;
var editinline array<editinline PreCreatedAttachment> PreCreatedAttachments;

simulated function PreBeginPlay()
{
	local int i;
	local Actor PreCreatedAttachment;

	super(Actor).PreBeginPlay();
	LoadAnimationSets(ExtraAnimationSets);
	i = 0;
	J0x18:

	if(Less_IntInt(i, AnimatedMeshAttachments.Length))
	{
		AnimatedMeshAttachmentModels[i] = Spawn(Class'RWOSupport.AnimatedMeshAttachmentModel');
		assert(NotEqual_ObjectObject(AnimatedMeshAttachmentModels[i], none));
		AssertWithDescription(NotEqual_ObjectObject(AnimatedMeshAttachments[i].Attachment, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ReactiveAnimatedMesh::PreBeginPlay() when initializing ", string(Name)), ", the Attachment StaticMesh specified for AnimatedMeshAttachments index "), string(i)), " resolves to None."));
		AnimatedMeshAttachmentModels[i].SetStaticMesh(AnimatedMeshAttachments[i].Attachment);
		AttachToBone(AnimatedMeshAttachmentModels[i], AnimatedMeshAttachments[i].Socket);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18;
	}
	i = 0;
	J0x173:

	if(Less_IntInt(i, PreCreatedAttachments.Length))
	{
		PreCreatedAttachment = findByLabel(Class'Engine.Actor', PreCreatedAttachments[i].Label);
		AssertWithDescription(NotEqual_ObjectObject(PreCreatedAttachment, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ReactiveAnimatedMesh::PreBeginPlay() when initializing ", string(Name)), ", no actor with the Label "), string(PreCreatedAttachments[i].Label)), " was found for PreCreatedAttachment index "), string(i)), "."));
		AttachToBone(PreCreatedAttachment, PreCreatedAttachments[i].Socket);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x173;
	}
	return;
}

simulated event Trigger(Actor Other, Pawn EventInstigator)
{
	super.Trigger(Other, EventInstigator);
	GotoState('Running');
	return;
}

latent simulated function PlayAnimationFromSet(ScriptedAnimationSet Set)
{
	local float StartTime;
	local name Animation;

	StartTime = Level.TimeSeconds;
	Animation = Set.SelectAnimation();
	if(NotEqual_NameName(Animation, 'None'))
	{
		PlayAnim(Animation);
		FinishAnim();
		if(EqualEqual_FloatFloat(Level.TimeSeconds, StartTime))
		{
			AssertWithDescription(Greater_FloatFloat(Level.TimeSeconds, StartTime), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " tried to play the animation named "), string(Animation)), " from the ScriptedAnimationSet named "), string(Set.Name)), ", but it did not play.  Please check that the animation names are correct, and that you've added the Animation Set to the ExtraAnimationSets list."));
			Sleep(60.0000000);
		}
	}
	return;
}

latent simulated function PlayScriptedSequences()
{
	local int ScriptedSequenceIndex, ChosenLoopCount, LocalLoopCount;

	ScriptedSequenceIndex = 0;
	J0x07:

	if(Less_IntInt(ScriptedSequenceIndex, ScriptedSequence.Length))
	{
		ChosenLoopCount = int(RandRange(ScriptedSequence[ScriptedSequenceIndex].LoopCount.Min, ScriptedSequence[ScriptedSequenceIndex].LoopCount.Max));
		LocalLoopCount = 0;
		J0x5E:

		if(Less_IntInt(LocalLoopCount, ChosenLoopCount))
		{
			PlayAnimationFromSet(ScriptedSequence[ScriptedSequenceIndex]);
			AddAdd_PreInt(LocalLoopCount);
			// [Loop Continue]
			goto J0x5E;
		}
		AddAdd_PreInt(ScriptedSequenceIndex);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated event Destroyed()
{
	local int i;

	super.Destroyed();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, AnimatedMeshAttachmentModels.Length))
	{
		AnimatedMeshAttachmentModels[i].Destroy();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0D;
	}
	UnlinkScriptedAnimationSet(Idle);
	Idle = none;
	i = 0;
	J0x52:

	if(Less_IntInt(i, ScriptedSequence.Length))
	{
		UnlinkScriptedAnimationSet(ScriptedSequence[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x52;
	}
	ScriptedSequence.Remove(0, ScriptedSequence.Length);
	return;
}

// Export UReactiveAnimatedMesh::execUnlinkScriptedAnimationSet(FFrame&, void* const)
native function UnlinkScriptedAnimationSet(ScriptedAnimationSet SAS);

auto simulated state Idling
{Begin:

	if(OrOr_BoolBool(EqualEqual_ObjectObject(Idle, none), EqualEqual_IntInt(Idle.ScriptedAnimations.Length, 0)))
	{
		GotoState('None');
	}
	J0x29:

	if(true)
	{
		PlayAnimationFromSet(Idle);
		// [Loop Continue]
		goto J0x29;
	}
	stop;
}

simulated state Running
{Begin:

	PlayScriptedSequences();
	switch(WhenDoneDo)
	{
		case 0:
			GotoState('Idling');
			break;
		case 1:
			J0x21:

			if(true)
			{
				PlayAnimationFromSet(ScriptedSequence[Subtract_IntInt(ScriptedSequence.Length, 1)]);
				// [Loop Continue]
				goto J0x21;
			}
			break;
		case 2:
			goto 'Begin';
			break;
		case 3:
			break;
		case 4:
			Destroy();
			break;
		default:
			break;
	}
	stop;
}

defaultproperties
{
	DrawType=2
	bAlwaysProcessState=true
}