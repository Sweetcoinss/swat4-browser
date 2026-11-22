class SpeechManager extends Object
	native;

enum SpeechRecognitionConfidence
{
	Confidence_Low,                 // 0
	Confidence_Medium,              // 1
	Confidence_High                 // 2
};

struct native ClientInterest
{
	var ISpeechClient Client;
	var name Rule;
};

var array<ClientInterest> ClientInterests;
var Viewport Viewport;

final function RegisterRuleInterest(ISpeechClient Client, name Rule)
{
	local ClientInterest Interest;

	Interest.Client = Client;
	Interest.Rule = Rule;
	ClientInterests[ClientInterests.Length] = Interest;
	return;
}

final function UnRegisterRuleInterest(ISpeechClient Client, name Rule)
{
	local int i;

	J0x00:
	if(Less_IntInt(i, ClientInterests.Length))
	{
		J0x10:

		if(AndAnd_BoolBool(EqualEqual_ObjectObject(ClientInterests[i].Client, Client), OrOr_BoolBool(EqualEqual_NameName(ClientInterests[i].Rule, Rule), EqualEqual_NameName(Rule, 'None'))))
		{
			ClientInterests.Remove(i, 1);
			// [Loop Continue]
			goto J0x10;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x00;
	}
	if(EqualEqual_IntInt(ClientInterests.Length, 0))
	{
		StopRecognition();
	}
	return;
}

final function Init()
{
	StartRecognition();
	return;
}

event OnCommandRecognized(name Rule, name Value, SpeechManager.SpeechRecognitionConfidence Confidence)
{
	local int i;

	AssertWithDescription(Greater_IntInt(ClientInterests.Length, 0), "[tcohen] The SpeechManager was called OnCommandRecognized(), but nobody is interested.");
	i = 0;
	J0x6E:

	if(Less_IntInt(i, ClientInterests.Length))
	{
		if(OrOr_BoolBool(EqualEqual_NameName(ClientInterests[i].Rule, Rule), EqualEqual_NameName(ClientInterests[i].Rule, 'None')))
		{
			ClientInterests[i].Client.OnSpeechCommandRecognized(Rule, Value, Confidence);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x6E;
	}
	return;
}

// Export USpeechManager::execStartRecognition(FFrame&, void* const)
native function StartRecognition();

// Export USpeechManager::execStopRecognition(FFrame&, void* const)
native function StopRecognition();
