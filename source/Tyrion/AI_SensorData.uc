class AI_SensorData extends DeleteableObject
	native;

enum SensorDataType
{
	SDT_FLOAT,                      // 0
	SDT_INTEGER,                    // 1
	SDT_CATEGORICAL,                // 2
	SDT_OBJECT                      // 3
};

var AI_SensorData.SensorDataType dataType;
var float floatData;
var int integerData;
var Object objectData;

function Clear()
{
	floatData = 0.0000000;
	integerData = 0;
	objectData = none;
	return;
}
