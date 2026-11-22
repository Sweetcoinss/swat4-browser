interface ISwatHostage implements ISwatAICharacter
	parseconfig;

enum HostageState
{
	HostageState_Unaware,           // 0
	HostageState_Aware              // 1
};

function HostageCommanderAction GetHostageCommanderAction()
{
	return;
}

function HostageSpeechManagerAction GetHostageSpeechManagerAction()
{
	return;
}

function name SpawnedFromGroup()
{
	return;
}

function ISwatHostage.HostageState GetCurrentState()
{
	return;
}

function SetCurrentState(ISwatHostage.HostageState NewState)
{
	return;
}
