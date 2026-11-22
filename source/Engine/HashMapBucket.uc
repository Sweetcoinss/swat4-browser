class HashMapBucket extends Object;

var array<HashMapEntry> Entries;

final function Empty()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Entries.Length))
	{
		Entries[i].Object = none;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	Entries.Remove(0, Entries.Length);
	return;
}

final function bool HasKey(string InKey)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Entries.Length))
	{
		if(EqualEqual_StrStr(Entries[i].Key, InKey))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

final function Add(string InKey, Object Object)
{
	local HashMapEntry newEntry;

	newEntry = Class'Engine.HashMapEntry'.static.Allocate(self).;
	Construct_Void();
	newEntry.Key = InKey;
	newEntry.Object = Object;
	Entries[Entries.Length] = newEntry;
	return;
}

final function Remove(string InKey)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Entries.Length))
	{
		if(EqualEqual_StrStr(Entries[i].Key, InKey))
		{
			Entries.Remove(i, 1);
			// [Explicit Break]
			goto J0x4E;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x4E:

	return;
}

final function Object Lookup(string InKey)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Entries.Length))
	{
		if(EqualEqual_StrStr(Entries[i].Key, InKey))
		{
			return Entries[i].Object;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}
