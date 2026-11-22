interface ISwatAICharacter implements ISwatAI
	parseconfig;

enum AIEquipment
{
	AIE_Invalid,                    // 0
	AIE_Primary,                    // 1
	AIE_Backup,                     // 2
	AIE_IAmCuffed                   // 3
};

function ForceUpdateAwareness()
{
	return;
}

function bool IsFemale()
{
	return;
}

function SetCanBeArrested()
{
	return;
}

function SetDesiredAIEquipment(ISwatAICharacter.AIEquipment NewItem)
{
	return;
}
