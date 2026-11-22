class ObjectPool extends Object;

var array<Object> Objects;

simulated function Object AllocateObject(Class ObjectClass)
{
	local Object Result;
	local int ObjectIndex;

	ObjectIndex = 0;
	J0x07:

	if(Less_IntInt(ObjectIndex, Objects.Length))
	{
		if(EqualEqual_ObjectObject(Objects[ObjectIndex].Class, ObjectClass))
		{
			Result = Objects[ObjectIndex];
			Objects.Remove(ObjectIndex, 1);
			// [Explicit Break]
			goto J0x5F;
		}
		AddAdd_Int(ObjectIndex);
		// [Loop Continue]
		goto J0x07;
	}
	J0x5F:

	if(EqualEqual_ObjectObject(Result, none))
	{
		Result = ObjectClass.static.Allocate(self, none).;
		Construct_Void();
	}
	return Result;
	return;
}

simulated function FreeObject(Object Obj)
{
	Objects.Length = Add_IntInt(Objects.Length, 1);
	Objects[Subtract_IntInt(Objects.Length, 1)] = Obj;
	return;
}

simulated function Shrink()
{
	J0x00:
	if(Greater_IntInt(Objects.Length, 0))
	{
		Objects.Remove(Subtract_IntInt(Objects.Length, 1), 1);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}
