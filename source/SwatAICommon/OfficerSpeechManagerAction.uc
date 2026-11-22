class OfficerSpeechManagerAction extends CharacterSpeechManagerAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function TriggerOfficerDownSpeech()
{
	TriggerSpeech('ReportedOfficerDown', true);
	return;
}

function TriggerLeadDownSpeech()
{
	TriggerSpeech('ReportedLeadDown', true);
	return;
}

function TriggerReactedFirstShotSpeech()
{
	TriggerSpeech('ReactedFirstShot', true);
	return;
}

function TriggerReactedSecondShotSpeech()
{
	TriggerSpeech('ReactedSecondShot', true);
	return;
}

function TriggerReactedThirdShotSpeech()
{
	TriggerSpeech('ReactedThirdShot', true);
	return;
}

function TriggerSuspectSpottedSpeech()
{
	TriggerSpeech('ReportedSuspectSpotted', true);
	return;
}

function TriggerSuspectDownSpeech(Pawn Suspect)
{
	if(Suspect.IsIncapacitated())
	{
		TriggerSpeech('ReportedSuspectDown', true);
	}
	else
	{
		TriggerSpeech('ReportedSuspectNeutralized', true);
	}
	return;
}

function TriggerSuspectFleeingSpeech(Pawn Suspect)
{
	if(ISwatAICharacter(Suspect).IsFemale())
	{
		TriggerSpeech('ReportedFemSuspectFleeing', true);
	}
	else
	{
		TriggerSpeech('ReportedMaleSuspectFleeing', true);
	}
	return;
}

function TriggerSuspectWontComplySpeech(Pawn Suspect)
{
	if(ISwatAICharacter(Suspect).IsFemale())
	{
		TriggerSpeech('ReportedFemSuspectWillNotComply', true);
	}
	else
	{
		TriggerSpeech('ReportedMaleSuspectWillNotComply', true);
	}
	return;
}

function TriggerHostageSpottedSpeech(Pawn Hostage)
{
	assert(Hostage.IsA('SwatHostage'));
	if(ISwatHostage(Hostage).GetHostageCommanderAction().IsInDanger())
	{
		TriggerSpeech('ReportedHostageSpottedWithThreat', true);
	}
	else
	{
		TriggerSpeech('ReportedHostageSpottedNoThreat', true);
	}
	return;
}

function TriggerHostageDownSpeech(Pawn Hostage)
{
	TriggerSpeech('ReportedHostageIncapacitated', true);
	return;
}

function TriggerHostageWontComplySpeech(Pawn Hostage)
{
	if(ISwatAICharacter(Hostage).IsFemale())
	{
		TriggerSpeech('ReportedFemCivilianWillNotComply', true);
	}
	else
	{
		TriggerSpeech('ReportedMaleCivilianWillNotComply', true);
	}
	return;
}

function TriggerClearAnnouncement()
{
	TriggerSpeech('AnnouncedClear');
	return;
}

function TriggerComplySpeech()
{
	TriggerSpeech('AnnouncedComply', true);
	return;
}

function TriggerComplyWithGunSpeech()
{
	TriggerSpeech('AnnouncedComplyWithGun', true);
	return;
}

function TriggerWedgePlacedSpeech()
{
	TriggerSpeech('AnnouncedDoorIsWedged');
	return;
}

function TriggerWedgeRemovedSpeech()
{
	TriggerSpeech('AnnouncedRemovedWedged');
	return;
}

function TriggerWedgeNotFoundSpeech()
{
	TriggerSpeech('ReportedNotWedged');
	return;
}

function TriggerDeployingToolkitSpeech()
{
	TriggerSpeech('ReportedDeployingToolkit');
	return;
}

function TriggerDeployingTaserSpeech()
{
	TriggerSpeech('ReportedDeployingTaser');
	return;
}

function TriggerFinishedLockPickSpeech()
{
	TriggerSpeech('ReportedDoorUnlocked');
	return;
}

function TriggerReportDoorLockedSpeech()
{
	TriggerSpeech('ReportedDoorLocked');
	return;
}

function TriggerReportDoorWedgedSpeech()
{
	TriggerSpeech('AnnouncedDoorIsAlreadyWedged');
	return;
}

function TriggerReportDoorOpenSpeech()
{
	TriggerSpeech('ReportedDoorOpen');
	return;
}

function TriggerReachedStackUpSpeech()
{
	TriggerSpeech('ReachedStackUp');
	return;
}

function TriggerStartedClearingSpeech()
{
	TriggerSpeech('StartedClearing', true);
	return;
}

function TriggerReportedThresholdClearSpeech()
{
	TriggerSpeech('ReportedThresholdClear', true);
	return;
}

function TriggerReportedContinuingClear2Plus()
{
	TriggerSpeech('ReportedContinuingClear2Plus', true);
	return;
}

function TriggerReportedContinuingClear2Minus()
{
	TriggerSpeech('ReportedContinuingClear2Minus', true);
	return;
}

function TriggerReportedDeployingShotgunSpeech()
{
	TriggerSpeech('ReportedDeployingBreachSG');
	return;
}

function TriggerReportedDeployingC2Speech()
{
	TriggerSpeech('ReportedDeployingC2');
	return;
}

function TriggerDoorNotClosedSpeech()
{
	TriggerSpeech('AnnouncedDoorIsNotClosed');
	return;
}

function TriggerDoorIsAlreadyWedgedSpeech()
{
	TriggerSpeech('AnnouncedDoorIsAlreadyWedged');
	return;
}

function TriggerLessLethalShotgunUnavailableSpeech()
{
	TriggerSpeech('ReportedBeanBagUnavailable');
	return;
}

function TriggerDeployingPepperBallSpeech()
{
	TriggerSpeech('ReportedDeployingPepperGun');
	return;
}

function TriggerPepperBallUnavailableSpeech()
{
	TriggerSpeech('ReportedPepperGunUnavailable');
	return;
}

function TriggerWedgeUnavailableSpeech()
{
	TriggerSpeech('ReportedWedgesUnavailable');
	return;
}

function TriggerFlashbangUnavailableSpeech()
{
	TriggerSpeech('ReportedFlashbangUnavailable');
	return;
}

function TriggerGasUnavailableSpeech()
{
	TriggerSpeech('ReportedGasUnavailable');
	return;
}

function TriggerStingUnavailableSpeech()
{
	TriggerSpeech('ReportedStingUnavailable');
	return;
}

function TriggerTaserUnavailableSpeech()
{
	TriggerSpeech('ReportedTaserUnavailable');
	return;
}

function TriggerC2UnavailableSpeech()
{
	TriggerSpeech('CouldntBreachNoC2');
	return;
}

function TriggerDoorBreachingEquipmentUnavailableSpeech()
{
	TriggerSpeech('ReportedDoorBreachingEquipmentUnavailable');
	return;
}

function TriggerToolkitUnavailableSpeech()
{
	TriggerSpeech('ReportedToolkitUnavailable');
	return;
}

function TriggerShotgunUnavailableSpeech()
{
	TriggerSpeech('ReportedBreachSGUnavailable');
	return;
}

function TriggerPepperSprayUnavailableSpeech()
{
	TriggerSpeech('ReportedPepperUnavailable');
	return;
}

function TriggerMirrorUnavailableSpeech()
{
	TriggerSpeech('ReportedMirrorUnavailable');
	return;
}

function TriggerReportedSuspectSecuredSpeech()
{
	TriggerSpeech('ReportedSuspectSecured');
	return;
}

function TriggerReportedHostageSecuredSpeech()
{
	TriggerSpeech('ReportedHostageSecured');
	return;
}

function TriggerCompletedMoveToSpeech()
{
	TriggerSpeech('CompletedMoveTo');
	return;
}

function TriggerRepliedMoveToSpeech()
{
	TriggerSpeech('RepliedMoveTo');
	return;
}

function TriggerRepliedFallInSpeech()
{
	TriggerSpeech('RepliedFallIn');
	return;
}

function TriggerCompletedFallInSpeech()
{
	TriggerSpeech('CompletedFallIn');
	return;
}

function TriggerStillCoveringSpeech()
{
	TriggerSpeech('AnnouncedStillCovering');
	return;
}

function TriggerEvidenceSecuredSpeech()
{
	TriggerSpeech('ReportedEvidenceSecured');
	return;
}

function TriggerEvidenceNotFoundSpeech()
{
	TriggerSpeech('ReportedNoEvidence');
	return;
}

function TriggerWeaponSecuredSpeech()
{
	TriggerSpeech('ReportedWeaponSecured');
	return;
}

function TriggerWeaponNotFoundSpeech()
{
	TriggerSpeech('ReportedNoGun');
	return;
}

function TriggerReassureAggressiveHostageSpeech()
{
	TriggerSpeech('ReassuredAggressiveHostage');
	return;
}

function TriggerReassurePassiveHostageSpeech()
{
	TriggerSpeech('ReassuredPassiveHostage');
	return;
}

function TriggerArrestedSuspectSpeech()
{
	TriggerSpeech('ArrestedSuspect');
	return;
}

function TriggerArrestedReportSpeech(Pawn Target)
{
	if(Target.IsA('SwatEnemy'))
	{
		TriggerSpeech('ReportedSuspectRestrained');
	}
	else
	{
		TriggerSpeech('ReportedCivilianRestrained');
	}
	return;
}

function TriggerOptiwandReportSpeech(int NumEnemies, int NumHostages)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(NumEnemies, 0), EqualEqual_IntInt(NumHostages, 0)))
	{
		TriggerSpeech('ReportedMirrorNoTargets');
	}
	else
	{
		if(EqualEqual_IntInt(NumHostages, 0))
		{
			if(EqualEqual_IntInt(NumEnemies, 1))
			{
				TriggerSpeech('ReportedOneSuspectSeen');
			}
			else
			{
				if(EqualEqual_IntInt(NumEnemies, 2))
				{
					TriggerSpeech('ReportedTwoSuspectsSeen');
				}
				else
				{
					TriggerSpeech('ReportedManySuspectsSeen');
				}
			}
		}
		else
		{
			if(EqualEqual_IntInt(NumEnemies, 0))
			{
				if(EqualEqual_IntInt(NumHostages, 1))
				{
					TriggerSpeech('ReportedOneCivilianSeen');
				}
				else
				{
					if(EqualEqual_IntInt(NumHostages, 2))
					{
						TriggerSpeech('ReportedTwoCiviliansSeen');
					}
					else
					{
						TriggerSpeech('ReportedManyCiviliansSeen');
					}
				}
			}
			else
			{
				if(AndAnd_BoolBool(EqualEqual_IntInt(NumHostages, 1), EqualEqual_IntInt(NumEnemies, 1)))
				{
					TriggerSpeech('Reported1Suspect1Civilian');
				}
				else
				{
					TriggerSpeech('ReportedSuspectsAndCivsSeen');
				}
			}
		}
	}
	return;
}

function TriggerMoveUpBangsSpeech()
{
	TriggerSpeech('ReportedMoveUpBangs');
	return;
}

function TriggerMoveUpGasSpeech()
{
	TriggerSpeech('ReportedMoveUpGas');
	return;
}

function TriggerMoveUpStingSpeech()
{
	TriggerSpeech('ReportedMoveUpSting');
	return;
}

function TriggerMoveUpBreachSGSpeech()
{
	TriggerSpeech('ReportedMoveUpBreachSG');
	return;
}

function TriggerMoveUpC2Speech()
{
	TriggerSpeech('ReportedMoveUpC2');
	return;
}

function TriggerGenericMoveUpSpeech()
{
	TriggerSpeech('RepliedSwitchingPositions');
	return;
}

function TriggerRepliedDisablingSpeech()
{
	TriggerSpeech('RepliedDisabling');
	return;
}

function TriggerReportedBombDisabledSpeech()
{
	TriggerSpeech('ReportedBombDisabled');
	return;
}

function TriggerReportedTrapDisabledSpeech()
{
	TriggerSpeech('ReportedTrapDisabled');
	return;
}

function TriggerReportedGenericDisabledSpeech()
{
	TriggerSpeech('ReportedDisabled');
	return;
}

function TriggerGenericOrderReplySpeech()
{
	TriggerSpeech('ReportedGenericOrderReply', true);
	return;
}

function TriggerBusyEngagingSpeech()
{
	TriggerSpeech('ReportedAlreadyBusy');
	return;
}

function TriggerLostTargetSpeech()
{
	TriggerSpeech('AnnouncedLostTarget');
	return;
}

function TriggerTargetCompliantSpeech(Pawn Target)
{
	if(Target.IsA('SwatEnemy'))
	{
		TriggerSpeech('AnnouncedSuspectComplied');
	}
	else
	{
		TriggerSpeech('AnnouncedCivilianComplied');
	}
	return;
}

function TriggerCouldntBreachLockedDoorSpeech()
{
	TriggerSpeech('CouldntBreachLocked');
	return;
}

function TriggerPlayerInTheWaySpeech()
{
	TriggerSpeech('ToldPlayerToMove', true);
	return;
}

function TriggerPlayerBlockingDoorSpeech()
{
	TriggerSpeech('ToldPlayerBlocksDoor', true);
	return;
}

function TriggerCharacterBlockingDoorSpeech()
{
	TriggerSpeech('ReportedDoorBlocked', true);
	return;
}

function TriggerCouldntCompleteMoveSpeech()
{
	TriggerSpeech('CouldntCompleteMove');
	return;
}

function TriggerCantDeployThrownSpeech()
{
	TriggerSpeech('RepliedCantDeployThrown');
	return;
}

function TriggerRedTeamNeedsOrdersSpeech()
{
	TriggerSpeech('RedTeamReported');
	TriggerSpeech('RequestedOrders');
	return;
}

function TriggerBlueTeamNeedsOrdersSpeech()
{
	TriggerSpeech('BlueTeamReported');
	TriggerSpeech('RequestedOrders');
	return;
}

function TriggerOtherTeamOnItSpeech()
{
	TriggerSpeech('ReportedOtherTeamOnIt');
	return;
}

function TriggerCoveringTargetSpeech()
{
	TriggerSpeech('CoveredCompliedUnrestrained');
	return;
}

function TriggerElementReportedSpeech()
{
	TriggerSpeech('ElementReported');
	return;
}

function TriggerRedTeamReportedSpeech()
{
	TriggerSpeech('RedTeamReported');
	return;
}

function TriggerBlueTeamReportedSpeech()
{
	TriggerSpeech('BlueTeamReported');
	return;
}
