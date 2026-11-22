class QualifiedUseEquipment extends HandheldEquipment implements IAmAQualifiedUseEquipment
	abstract
	config(SwatEquipment)
	hidecategories(Karma);

var private float UseBeginTime;
var private bool Interrupted;

function PostBeginPlay()
{
	super.PostBeginPlay();
	Disable('Tick');
	return;
}

simulated function float GetQualifyDuration()
{
	assert(false);
	return 0.0000000;
	return;
}

simulated function PreUse()
{
	super.PreUse();
	MPLog(Concat_StrStr(string(self), "...setting Interrupted to false."));
	Interrupted = false;
	return;
}

protected latent simulated function DoUsingHook()
{
	local export editinline GUIProgressBar Progress;
	local bool UseAlternate;
	local QualifiedUseEquipmentModel QualifiedUseFirstPersonModel, QualifiedUseThirdPersonModel;
	local bool OwnerIsLocalPlayer;

	MPLog(Concat_StrStr(string(self), "---QualifiedUseEquipment::DoUsingHook()."));
	OwnerIsLocalPlayer = EqualEqual_ObjectObject(Pawn(Owner), SwatGamePlayerController(Level.GetLocalPlayerController()).Pawn);
	Progress = SwatGamePlayerController(Level.GetLocalPlayerController()).GetHUDPage().Progress;
	UseAlternate = ShouldUseAlternate();
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel = QualifiedUseEquipmentModel(FirstPersonModel);
		AssertWithDescription(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The FirstPersonModel ", string(FirstPersonModel.Class.Name)), " specified for "), string(Class.Name)), " (in SwatEquipment.ini) is not a QualifiedUseEquipmentModel. "), " Models for QualifiedUseEquipment must be QualifiedUseEquipmentModels."));
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel = QualifiedUseEquipmentModel(ThirdPersonModel);
		AssertWithDescription(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ThirdPersonModel ", string(ThirdPersonModel.Class.Name)), " specified for "), string(Class.Name)), " (in SwatEquipment.ini) is not a QualifiedUseEquipmentModel. "), " Models for QualifiedUseEquipment must be QualifiedUseEquipmentModels."));
	}
	if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel.PlayBeginQualify(UseAlternate);
		QualifiedUseFirstPersonModel.TriggerEffectEvent('QualifyBegan');
	}
	if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel.PlayBeginQualify(UseAlternate);
		QualifiedUseThirdPersonModel.TriggerEffectEvent('QualifyBegan');
	}
	OnUsingBegan();
	if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel.FinishBeginQualify(UseAlternate);
	}
	if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel.FinishBeginQualify(UseAlternate);
	}
	UseBeginTime = Level.TimeSeconds;
	if(OwnerIsLocalPlayer)
	{
		Progress.RePosition('Up');
		Progress.Value = 0.0000000;
		Enable('Tick');
	}
	if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel.PlayQualifyLoop(UseAlternate);
		QualifiedUseFirstPersonModel.TriggerEffectEvent('Qualifying');
	}
	if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel.PlayQualifyLoop(UseAlternate);
		QualifiedUseThirdPersonModel.TriggerEffectEvent('Qualifying');
	}
	J0x429:

	if(AndAnd_BoolBool(Not_PreBool(Interrupted), Less_FloatFloat(Level.TimeSeconds, Add_FloatFloat(UseBeginTime, GetQualifyDuration()))))
	{
		Sleep(0.0000000);
		// [Loop Continue]
		goto J0x429;
	}
	if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel.UnTriggerEffectEvent('Qualifying');
	}
	if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel.UnTriggerEffectEvent('Qualifying');
	}
	if(OwnerIsLocalPlayer)
	{
		Disable('Tick');
		Progress.RePosition('Down');
	}
	if(Not_PreBool(Interrupted))
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			DoQualifyComplete();
		}
		if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
		{
			QualifiedUseFirstPersonModel.UnTriggerEffectEvent('Qualified');
		}
		if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
		{
			QualifiedUseThirdPersonModel.UnTriggerEffectEvent('Qualified');
		}
	}
	else
	{
		if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
		{
			QualifiedUseFirstPersonModel.UnTriggerEffectEvent('QualifyInterrupted');
		}
		if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
		{
			QualifiedUseThirdPersonModel.UnTriggerEffectEvent('QualifyInterrupted');
		}
	}
	if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel.PlayEndQualify(UseAlternate);
	}
	if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel.PlayEndQualify(UseAlternate);
	}
	if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel.FinishEndQualify(UseAlternate);
	}
	if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel.FinishEndQualify(UseAlternate);
	}
	return;
}

protected latent simulated function OnUsingBegan()
{
	Pawn(Owner).ChangeAnimation();
	return;
}

simulated function OnUsingFinishedHook()
{
	Pawn(Owner).ChangeAnimation();
	return;
}

simulated function DoQualifyComplete()
{
	if(Owner.IsA('ICanQualifyForUse'))
	{
		ICanQualifyForUse(Owner).OnQualifyCompleted();
	}
	OnUseKeyFrame();
	return;
}

simulated function bool ShouldUseAlternate()
{
	return false;
	return;
}

final simulated function Interrupt()
{
	local SwatGamePlayerController LPC;
	local QualifiedUseEquipmentModel QualifiedUseFirstPersonModel, QualifiedUseThirdPersonModel;

	MPLog(Concat_StrStr(string(self), "---QualifiedUseEquipment::Interrupt()."));
	if(Interrupted)
	{
		return;
	}
	Interrupted = true;
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		DoInterrupt();
	}
	else
	{
		LPC = SwatGamePlayerController(Level.GetLocalPlayerController());
		if(NotEqual_ObjectObject(LPC, none))
		{
			LPC.ServerRequestQualifyInterrupt();
		}
	}
	QualifiedUseFirstPersonModel = QualifiedUseEquipmentModel(FirstPersonModel);
	if(NotEqual_ObjectObject(QualifiedUseFirstPersonModel, none))
	{
		QualifiedUseFirstPersonModel.OnInterrupted();
	}
	QualifiedUseThirdPersonModel = QualifiedUseEquipmentModel(ThirdPersonModel);
	if(NotEqual_ObjectObject(QualifiedUseThirdPersonModel, none))
	{
		QualifiedUseThirdPersonModel.OnInterrupted();
	}
	return;
}

final function InstantInterrupt()
{
	Interrupt();
	OnUsingFinished();
	return;
}

simulated function OnInterrupted()
{
	return;
}

function DoInterrupt()
{
	MPLog(Concat_StrStr(string(self), "---QualifiedUseEquipment::DoInterrupt()."));
	Interrupted = true;
	ICanQualifyForUse(Owner).OnQualifyInterrupted();
	OnInterrupted();
	return;
}

function Tick(float dTime)
{
	local SwatGamePlayerController LPC;

	LPC = SwatGamePlayerController(Level.GetLocalPlayerController());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(LPC, none), EqualEqual_ObjectObject(Pawn(Owner), LPC.Pawn)))
	{
		LPC.GetHUDPage().Progress.Value = Divide_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, UseBeginTime), GetQualifyDuration());
	}
	return;
}

protected function AIInterrupt_Using()
{
	InstantInterrupt();
	return;
}
