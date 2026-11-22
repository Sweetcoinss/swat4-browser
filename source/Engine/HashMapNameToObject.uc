class HashMapNameToObject extends Object;

const NUM_BUCKETS = 256;

var array<HashMapBucket> Buckets;

function int HashKey(string InKey)
{
	return int(Abs(float(Hash(InKey, 256))));
	return;
}

final function Empty()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Buckets.Length))
	{
		Buckets[i].super(HashMapNameToObject).Empty();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	Buckets.Remove(0, Buckets.Length);
	return;
}

final function bool HasKey(string InKey)
{
	local int bucket;

	bucket = HashKey(InKey);
	if(GreaterEqual_IntInt(bucket, Buckets.Length))
	{
		return false;
	}
	return Buckets[bucket].super(HashMapNameToObject).HasKey(InKey);
	return;
}

final function Add(string InKey, Object Object)
{
	local int bucket;

	bucket = HashKey(InKey);
	if(OrOr_BoolBool(GreaterEqual_IntInt(bucket, Buckets.Length), EqualEqual_ObjectObject(Buckets[bucket], none)))
	{
		Buckets[bucket] = Class'Engine.HashMapBucket'.static.Allocate(self).;
		Construct_Void();
	}
	Buckets[bucket].super(HashMapNameToObject).Add(InKey, Object);
	return;
}

final function Remove(string InKey)
{
	local int bucket;

	bucket = HashKey(InKey);
	Buckets[bucket].super(HashMapNameToObject).Remove(InKey);
	return;
}

final function Object Lookup(string InKey)
{
	local int bucket;

	bucket = HashKey(InKey);
	if(OrOr_BoolBool(GreaterEqual_IntInt(bucket, Buckets.Length), EqualEqual_ObjectObject(Buckets[bucket], none)))
	{
		return none;
	}
	if(EqualEqual_ObjectObject(Buckets[bucket], none))
	{
		return none;
	}
	return Buckets[bucket].super(HashMapNameToObject).Lookup(InKey);
	return;
}

final function HashMapBucket GetBucket(string InKey)
{
	local int bucket;

	bucket = HashKey(InKey);
	if(GreaterEqual_IntInt(bucket, Buckets.Length))
	{
		return none;
	}
	return Buckets[HashKey(InKey)];
	return;
}

final function int GetBucketIndex(string InKey)
{
	return HashKey(InKey);
	return;
}

final function Profile()
{
	local float Mean, Variance, StandardDeviation;
	local int i, used, Max;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Buckets.Length))
	{
		if(NotEqual_ObjectObject(Buckets[i], none))
		{
			AddAdd_PreInt(used);
			if(Greater_IntInt(Buckets[i].Entries.Length, Max))
			{
				Max = Buckets[i].Entries.Length;
			}
			AddEqual_FloatFloat(Mean, float(Buckets[i].Entries.Length));
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	Mean = Divide_FloatFloat(Mean, float(Buckets.Length));
	i = 0;
	J0xAD:

	if(Less_IntInt(i, Buckets.Length))
	{
		if(NotEqual_ObjectObject(Buckets[i], none))
		{
			AddEqual_FloatFloat(Variance, Square(Subtract_FloatFloat(float(Buckets[i].Entries.Length), Mean)));
			// [Explicit Continue]
			goto J0x106;
		}
		AddEqual_FloatFloat(Variance, Square(Mean));
		J0x106:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xAD;
	}
	Variance = Divide_FloatFloat(Variance, float(Buckets.Length));
	StandardDeviation = Sqrt(Variance);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), "::Profile(): NUM_BUCKETS="), string(256)), ", BucketsAllocated="), string(Buckets.Length)), ", BucketsUsed="), string(used)), ", MaxBucketSize="), string(Max)), ", MeanBucketSize="), string(Mean)), ", StandardDeviation="), string(StandardDeviation)));
	return;
}
