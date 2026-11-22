class VariableFloat extends Variable
	editinlinenew
	collapsecategories
	hidecategories(Object);

var float Value;

function Add(string rhs)
{
	AddEqual_FloatFloat(Value, float(rhs));
	return;
}

function subtract(string rhs)
{
	SubtractEqual_FloatFloat(Value, float(rhs));
	return;
}

function multiply(string rhs)
{
	MultiplyEqual_FloatFloat(Value, float(rhs));
	return;
}

function divide(string rhs)
{
	DivideEqual_FloatFloat(Value, float(rhs));
	return;
}

function bool less(string rhs)
{
	return Less_FloatFloat(Value, float(rhs));
	return;
}

function bool lessEqual(string rhs)
{
	return LessEqual_FloatFloat(Value, float(rhs));
	return;
}

function bool equal(string rhs)
{
	return EqualEqual_FloatFloat(Value, float(rhs));
	return;
}

function bool notEqual(string rhs)
{
	return NotEqual_FloatFloat(Value, float(rhs));
	return;
}

function bool greaterEqual(string rhs)
{
	return GreaterEqual_FloatFloat(Value, float(rhs));
	return;
}

function bool greater(string rhs)
{
	return Greater_FloatFloat(Value, float(rhs));
	return;
}

function bool and(string rhs)
{
	return AndAnd_BoolBool(NotEqual_FloatFloat(Value, 0.0000000), NotEqual_FloatFloat(float(rhs), 0.0000000));
	return;
}

function bool or(string rhs)
{
	return OrOr_BoolBool(NotEqual_FloatFloat(Value, 0.0000000), NotEqual_FloatFloat(float(rhs), 0.0000000));
	return;
}

function bool not()
{
	return EqualEqual_FloatFloat(Value, 0.0000000);
	return;
}

function bool truth()
{
	return NotEqual_FloatFloat(Value, 0.0000000);
	return;
}
