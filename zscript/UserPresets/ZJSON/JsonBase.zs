
class UV_JsonElementOrError {}

class UV_JsonElement : UV_JsonElementOrError abstract
{
	abstract string Serialize();
	abstract string GetPrettyName();
}

class UV_JsonNumber : UV_JsonElement abstract
{
	abstract UV_JsonNumber Negate();
	abstract double  asDouble();
	abstract int asInt();
	
	override string GetPrettyName()
	{
		return "Number";
	}
}

class UV_JsonInt : UV_JsonNumber
{
	int i;
	
	static UV_JsonInt make(int i = 0)
	{
		let elem = new("UV_JsonInt");
		elem.i = i;
		return elem;
	}
	override UV_JsonNumber Negate()
	{
		i = -i;
		return self;
	}
	override string Serialize()
	{
		return ""..i;
	}
	
	override double asDouble()
	{
		return double(i);
	}
	
	override int asInt()
	{
		return i;
	}
}

class UV_JsonDouble : UV_JsonNumber
{
	double d;
	
	static UV_JsonDouble Make(double d = 0)
	{
		UV_JsonDouble elem = new("UV_JsonDouble");
		elem.d = d;
		return elem;
	}
	override UV_JsonNumber Negate()
	{
		d = -d;
		return self;
	}
	override string Serialize()
	{
		return ""..d;
	}
	
	override double asDouble()
	{
		return d;
	}
	
	override int asInt()
	{
		return int(d);
	}
}

class UV_JsonBool : UV_JsonElement
{
	bool b;
	
	static UV_JsonBool Make(bool b = false)
	{
		UV_JsonBool elem = new("UV_JsonBool");
		elem.b = b;
		return elem;
	}
	
	override string Serialize()
	{
		return b? "true" : "false";
	}
	
	override string GetPrettyName()
	{
		return "Bool";
	}
}

class UV_JsonString : UV_JsonElement
{
	string s;
	
	static UV_JsonString make(string s = "")
	{
		UV_JsonString elem = new("UV_JsonString");
		elem.s=s;
		return elem;
	}
	
	override string Serialize()
	{
		return UV_JSON.serialize_string(s);
	}
	
	override string GetPrettyName()
	{
		return "String";
	}
}

class UV_JsonNull : UV_JsonElement
{
	static UV_JsonNull Make()
	{
		return new("UV_JsonNull");
	}
	
	override string Serialize()
	{
		return "null";
	}
	
	override string GetPrettyName()
	{
		return "Null";
	}
}

class UV_JsonError : UV_JsonElementOrError
{
	String what;
	
	static UV_JsonError make(string s)
	{
		UV_JsonError err = new("UV_JsonError");
		err.what = s;
		return err;
	}
}