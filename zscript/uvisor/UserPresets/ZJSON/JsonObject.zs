
class UV_JsonObjectKeys
{
	Array<String> keys;
}

class UV_JsonObject : UV_JsonElement
{
	Map<String,UV_JsonElement> data;
	
	static UV_JsonObject make()
	{
		return new("UV_JsonObject");
	}
	
	UV_JsonElement Get(String key)
	{
		return data.GetIfExists(key);
	}
	
	void Set(String key,UV_JsonElement e)
	{
		data.Insert(key,e);
	}
	
	bool Insert(String key, UV_JsonElement e)
	{ // only inserts if key doesn't exist, otherwise fails and returns false
		if(data.CheckKey(key)) return false;
		data.Insert(key,e);
		return true;
	}
	
	bool Delete(String key)
	{
// 		Console.PrintF("In JsonObject - Delete(), key: "..key);
		if(!data.CheckKey(key)) return false;
		data.Remove(key);
		return true;
	}
    
	void GetKeysInto(out Array<String> keys)
	{
		keys.Clear();
		MapIterator<String, UV_JsonElement> it;
		it.Init(data);
		while(it.Next())
		{
			keys.Push(it.GetKey());
		}
	}
    
	UV_JsonObjectKeys GetKeys()
	{
		UV_JsonObjectKeys keys = new("UV_JsonObjectKeys");
        GetKeysInto(keys.keys);
		return keys;
	}
    
    deprecated("0.0", "Use IsEmpty Instead") bool Empty()
	{
        return data.CountUsed() == 0;
    }

	bool IsEmpty()
	{
		return data.CountUsed() == 0;
	}
	
	void Clear()
	{
		data.Clear();
	}
	
	uint Size()
	{
		return data.CountUsed();
	}
	
	override string Serialize()
	{
		String s;
		s.AppendCharacter("{");
		bool first = true;
		
		MapIterator<String,UV_JsonElement> it;
		it.Init(data);
		
		while(it.Next()){
			if(!first){
				s.AppendCharacter(",");
			}
			s.AppendFormat("%s:%s", UV_JSON.serialize_string(it.GetKey()), it.GetValue().serialize());
			first = false;
		}
		
		s.AppendCharacter("}");
		return s;
	}
    
	override string GetPrettyName()
	{
		return "Object";
	}
}
