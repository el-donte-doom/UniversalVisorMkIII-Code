// Based on FlexiHUD, credits to jekyllgrim and other authors

class UV_PresetMessageBox : CustomMessageBoxMenuBase {
	
	string mPreset;
	
	static const string menuOptions[] = 
	{
		"$JGPHUD_Presets_Verb_Load",
		"$JGPHUD_Presets_Verb_Overwrite",
		"$JGPHUD_Presets_Verb_Delete",
		"$JGPHUD_Presets_Menu_Cancel"
	};
	
	static const string menuAction[] = 
	{
		"$JGPHUD_Presets_ConfirmAction_Load",
		"$JGPHUD_Presets_ConfirmAction_Overwrite",
		"$JGPHUD_Presets_ConfirmAction_Delete",
		"$JGPHUD_Presets_Menu_Cancel"
	};
	
	static const string cmds[] = 
	{
		"LoadUserPreset",
		"SaveUserPreset",
		"DeleteUserPreset"
	};
	
	int confirm_index;
	
	override uint optionCount()
	{
		return menuOptions.Size();
	}
	
	override string optionName(uint i)
	{
		return StringTable.Localize(menuOptions[i]);
	}
	
	override int OptionXOffset(uint index) 
	{
		return -30;
	}
	
	// -1 = no shortcut
	override int OptionForShortcut(int char_key, out bool activate) 
	{
		if(char_key == 110) 
		{
			activate = false;
			return 3;
		}
		return -1;
	}
	
	// -1 = escape
	override void HandleResult(int i) 
	{
		if(i == -1 || i == 3) 
		{
			CloseSound();
			Close();
		}
		else
		{
			MenuSound("menu/activate");
			confirm_index = i;
			String msg = String.Format(StringTable.Localize(menuAction[i]), mPreset);
			Menu.StartMessage(TEXTCOLOR_NORMAL..msg, 0);
		}
	}
	
	int toCloseMessageBox;
	
	override void OnReturn() 
	{
		if (toCloseMessageBox) 
		{
			UV_UserPresetsMenu(mParentMenu).CleanDisplayedPresets(UV_UserPresetsMenu(mParentMenu).mDesc);
			UV_UserPresetsMenu(mParentMenu).RebuildList(UV_UserPresetsMenu(mParentMenu).mDesc);
			Close();
		}
	}

	override bool MenuEvent (int mkey, bool fromcontroller)
	{
		if (mkey == Menu.MKEY_MBYes)
		{
			UV_PresetHandler(StaticEventHandler.Find("UV_PresetHandler")).ExecuteCommand(cmds[confirm_index],mPreset);
			toCloseMessageBox = confirm_index == 0 ? 3 : confirm_index == 1 ? 1 : 2;
			
			return true;
		}
		return Super.MenuEvent(mkey, fromcontroller);
	}
	
}

class UV_UserPreset : OptionMenuItemSubmenu
{
	String mPreset;

	UV_UserPreset Init(String preset)
	{
		Super.Init(preset, "");
		mPreset = preset;
		return self;
	}

	override bool Activate()
	{
		let mBox = new("UV_PresetMessageBox");
		mBox.mPreset = mPreset;
		mBox.Init(Menu.GetCurrentMenu(),mPreset,true);
		mBox.ActivateMenu();
		return true;
	}
}

class UV_SavePresetMenu : OptionMenu
{
	bool toClose;
	
	override void OnReturn() 
	{
		if(toClose) 
		{
			Close();
		}
	}
}

class OptionMenuItemUV_SaveUserPreset : OptionMenuItemSubmenu
{
	
	OptionMenuItemUV_SaveUserPreset Init()
	{
		Super.Init(StringTable.Localize("$JGPHUD_Presets_Menu_Confirm"), "", 0, true);
		return self;
	}
	
	UV_UserPresetsMenu parentMenu;

	override bool MenuEvent (int mkey, bool fromcontroller)
	{
		if (mkey == Menu.MKEY_MBYes)
		{
			UV_PresetHandler(StaticEventHandler.Find("UV_PresetHandler")).ExecuteCommand("SaveUserPreset", __uvisor_save_preset_name);
			CVar.GetCVar("__uvisor_save_preset_name").SetString("");
			return true;
		}
		return Super.MenuEvent(mkey, fromcontroller);
	}
	
	override bool Activate()
	{
		let handler = UV_PresetHandler(StaticEventHandler.Find("UV_PresetHandler"));
		parentMenu = UV_UserPresetsMenu(Menu.GetCurrentMenu());
		handler.presets;
		String msg;
		if(__uvisor_save_preset_name.RightIndexOf(" ") != -1){
			msg = StringTable.Localize("$JGPHUD_Preset_Warning_Whitespace");
			Menu.StartMessage(TEXTCOLOR_NORMAL..msg, 1);
		} else if(handler.presets.Get(__uvisor_save_preset_name) != null) {
			msg = StringTable.Localize("$JGPHUD_Preset_Warning_Overwrite");
			msg = String.Format(msg, __uvisor_save_preset_name);
			Menu.StartMessage(TEXTCOLOR_NORMAL..msg, 0);
		} else if(__uvisor_save_preset_name.Length() == 0){
			msg = StringTable.Localize("$JGPHUD_Preset_Warning_EmptyName");
			Menu.StartMessage(TEXTCOLOR_NORMAL..msg, 1);
		} else {
			handler.ExecuteCommand("SaveUserPreset",__uvisor_save_preset_name);
			parentMenu.CleanDisplayedPresets(parentMenu.mDesc);
			parentMenu.RebuildList(parentMenu.mDesc);
		}
		return true;
	}
}

class OptionMenuItemUV_ConfirmCommand : OptionMenuItemSubmenu
{
	String mPrompt;
	Name mCommand;
	String mData;


	OptionMenuItemUV_ConfirmCommand Init(String label, Name command, String data, String prompt = "")
	{
		Super.Init(label, "");
		if (prompt != "")
		{
			mPrompt = StringTable.Localize(prompt);
		}
		else
		{
			String toLoc = StringTable.Localize("$JGPHUD_Presets_ConfirmAction_Load");
			String presetName = data;
			mPrompt = String.Format(toLoc, presetname);
		}
		mCommand = command;
		mData = data;
		return self;
	}

	override bool MenuEvent (int mkey, bool fromcontroller)
	{
		if (mkey == Menu.MKEY_MBYes)
		{
			UV_PresetHandler(StaticEventHandler.Find("UV_PresetHandler")).ExecuteCommand(mCommand,mData);
			return true;
		}
		return Super.MenuEvent(mkey, fromcontroller);
	}
	
	override bool Activate()
	{
		Menu.StartMessage(TEXTCOLOR_NORMAL..mPrompt, 0);
		return true;
	}
}

class UV_UserPresetsMenu : OptionMenu
{

	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		CleanDisplayedPresets(desc);
		RebuildList(desc);
		Super.Init(parent,desc);
	}
	
	void RebuildList(OptionMenuDescriptor desc)
	{
		let handler = UV_PresetHandler(StaticEventHandler.Find("UV_PresetHandler"));
		Array<String> keys;
		
		handler.presets.GetKeysInto(keys);
		let n = keys.Size();
		if (n > 0) 
		{
			for(int i = 0; i < n; i++)
			{	
				desc.mItems.Push(new("UV_UserPreset").Init(keys[i]));
			}
		}
		// clamp the selection to the new item count
		if (desc.mItems.Size() > 0)
		{
			desc.mSelectedItem = min(desc.mSelectedItem, desc.mItems.Size() - 1);
		}
		else
		{
			desc.mSelectedItem = 0; // if everything was removed
		}
	}
	
	void CleanDisplayedPresets(OptionMenuDescriptor desc) {
		for(int i = desc.mItems.Size() - 1; i >= 0; i--) {
			if (desc.mItems[i] is 'UV_UserPreset') {
				desc.mItems.Delete(i);
			}
		}
	}
	
	int toClose;
	
	override void OnReturn()
	{
		if(toClose) 
		{
			mDesc.mSelectedItem = 0;
			Close();
		}
	}
}

class OptionMenuItemUV_UserPresetsSubmenu : OptionMenuItemSubmenu
{
	UV_PresetHandler handler;
	OptionMenuItemUV_UserPresetsSubmenu Init(String label, Name command, int param = 0, bool centered = false)
	{
		Super.Init(label,command,param,centered);
		handler = UV_PresetHandler(StaticEventHandler.Find("UV_PresetHandler"));
		return self;
	}
	override bool Selectable()
	{
		return handler.presets.size() != 0;
	}
	
	override bool Activate()
	{
		if(Selectable()) return Super.Activate();
		return false;
	}
}

class UV_PresetsMenu : OptionMenu
{
	bool toClose;
	
	override void OnReturn()
	{
		CVar.GetCVar("__uvisor_save_preset_name").SetString("");
		if(toClose) 
		{
			Close();
		}
	}
}
