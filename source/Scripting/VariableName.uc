class VariableName extends Variable
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Value;

function Add(string rhs)
{
	Value = string(Concat_StrStr(string(Value), rhs));
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
	return EqualEqual_StrStr(string(Value), rhs);
	return;
}

function bool notEqual(string rhs)
{
	return NotEqual_StrStr(string(Value), rhs);
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
	return AndAnd_BoolBool(NotEqual_NameName(Value, 'None'), NotEqual_NameName(string(rhs), 'None'));
	return;
}

function bool or(string rhs)
{
	return OrOr_BoolBool(NotEqual_NameName(Value, 'None'), NotEqual_NameName(string(rhs), 'None'));
	return;
}

function bool not()
{
	return EqualEqual_NameName(Value, 'None');
	return;
}

function bool truth()
{
	return NotEqual_NameName(Value, 'None');
	return;
}
