class VariableBool extends Variable
	editinlinenew
	collapsecategories
	hidecategories(Object);

var bool Value;

function Add(string rhs)
{
	return;
}

function subtract(string rhs)
{
	return;
}

function multiply(string rhs)
{
	return;
}

function divide(string rhs)
{
	return;
}

function bool less(string rhs)
{
	return false;
	return;
}

function bool lessEqual(string rhs)
{
	return false;
	return;
}

function bool equal(string rhs)
{
	return EqualEqual_BoolBool(Value, bool(rhs));
	return;
}

function bool notEqual(string rhs)
{
	return NotEqual_BoolBool(Value, bool(rhs));
	return;
}

function bool greaterEqual(string rhs)
{
	return false;
	return;
}

function bool greater(string rhs)
{
	return false;
	return;
}

function bool and(string rhs)
{
	return AndAnd_BoolBool(Value, bool(rhs));
	return;
}

function bool or(string rhs)
{
	return OrOr_BoolBool(Value, bool(rhs));
	return;
}

function bool not()
{
	return Not_PreBool(Value);
	return;
}

function bool truth()
{
	return Value;
	return;
}
