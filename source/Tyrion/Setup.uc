class Setup extends Tyrion_Setup
	config
	hidecategories(Karma);

var Tyrion_ResourceBase sensorResource;

function PostBeginPlay()
{
	if(EqualEqual_ObjectObject(sensorResource, none))
	{
		default.sensorResource = Class'Tyrion.AI_SensorResource'.static.Allocate(self, none).;
		Construct_Void();
		sensorResource = default.sensorResource;
		Log("AI_SensorResource created!");
	}
	return;
}

function Tick(float DeltaTime)
{
	sensorResource.Tick(DeltaTime);
	return;
}
