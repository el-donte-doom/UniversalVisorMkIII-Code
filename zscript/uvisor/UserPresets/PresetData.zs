// Based on FlexiHUD, credits to jekyllgrim and other authors

class UV_PresetCVarData
{
	CVar c_cvar;
	name cvarName;

	static UV_PresetCVarData Add(name cvarname, out array<UV_PresetCVarData> arr = null)
	{
		let data = new('UV_PresetCVarData');
		if (!data) return null;
		if (data)
		{
			data.c_cvar = CVar.FindCVar(cvarname);
			if (!data.c_cvar)
			{
				return null;
			}
			data.cvarName = cvarname;
		}
		if (data && arr != null)
		{
			arr.Push(data);
		}
		return data;
	}
}
