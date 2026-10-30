// Based on FlexiHUD, credits to jekyllgrim and other authors

class UV_PresetHandler : StaticEventHandler
{
	UV_JsonObject presets;
	
	UV_JsonObject default_presets;
	
	Map<Name, Class<UV_JsonElement> > cvarTypes;
	
	array<UV_PresetCVarData> cvarData;
	
	UV_JsonObject LoadPresets(String jsonData, bool isCVar)
	{
		UV_JsonObject presets;
		
		let presetsOrError = UV_JSON.parse(jsonData);
		if(!(presetsOrError is 'UV_JsonObject'))
		{
			console.PrintfEx(PRINT_NONOTIFY, TEXTCOLOR_RED.."HUD "..(isCVar ? "Presets CVar" : "Default Presets").." has invalid JSON data");
			presets = UV_JsonObject.make();
		}
		else
		{
			presets = UV_JsonObject(presetsOrError);
			
			
			MapIterator<String,UV_JsonElement> it;
			it.Init(presets.data);
			
			Array<String> invalidPresets;
			
			while(it.Next())
			{
				let preset_name = it.getKey();
				let elem = it.getValue();
				
				if(!(elem is "UV_JsonObject"))
				{
					console.PrintfEx(PRINT_NONOTIFY, TEXTCOLOR_RED.."Invalid "..(isCVar ? "" : "default ").."preset '"..preset_name.."' found");
					invalidPresets.Push(preset_name);
				}
				else
				{
					let obj = UV_JsonObject(elem);
					
					Array<String> invalidKeys;
					
					MapIterator<String,UV_JsonElement> it2;
					it2.Init(obj.data);
					
					while(it2.Next())
					{
						let cvarName = it2.getKey();
						
						Class<UV_JsonElement> expectedClass = cvarTypes.GetIfExists(cvarName);
						let obj_elem = it2.getValue();
						
						if(expectedClass == null || !(obj_elem is expectedClass))
						{
							console.PrintfEx(PRINT_NONOTIFY, TEXTCOLOR_RED.."Invalid CVar '"..cvarName.."' found in "..(isCVar ? "" : "default ").."preset '"..preset_name.."'");
							invalidKeys.Push(cvarName);
						}
					}
					
					foreach(cvarName : invalidKeys)
					{
						obj.Delete(cvarName);
					}
				}
			}
			
			foreach(presetName : invalidPresets)
			{
				presets.Delete(presetName);
			}
		}
		return presets;
	}
	
	override void OnRegister()
	{
		InitalizeUVCvars();
		
		int numCVars = cvardata.Size();
		
		for(int i = 0; i < numCVars; i++)
		{
			let data = cvardata[i];
			if (!data) continue;

			class<UV_JsonElement> e;
			switch(data.c_cvar.GetRealType())
			{
			case CVar.CVAR_Int:
			case CVar.CVAR_Color:
				e = 'UV_JsonInt';
				break;
			case CVar.CVAR_String:
				e = 'UV_JsonString';
				break;
			case CVar.CVAR_Float:
				e = 'UV_JsonDouble';
				break;
			case CVar.CVAR_Bool:
				e = 'UV_JsonBool';
				break;
			default:
				ThrowAbortException("Invalid CVar type for cvar "..data.cvarname);
				break;
			}
			cvarTypes.Insert(data.cvarName, e);
		}
		
		presets = LoadPresets(__uvisor_user_presets_json, true);
	}
	
	clearscope void SavePresets()
	{
		CVar.FindCVar("__uvisor_user_presets_json").SetString(presets.serialize());
	}
	
	clearscope UV_JsonObject CurrentToJson()
	{
		let obj = UV_JsonObject.make();
		let n = cvardata.Size();
		for(int i = 0; i < n; i++)
		{
			let data = cvardata[i];
			if (!data) continue;
			
			UV_JsonElement e;
			CVar c = data.c_cvar;
			switch(c.GetRealType())
			{
			case CVar.CVAR_Int:
			case CVar.CVAR_Color:
				e = UV_JsonInt.make(c.GetInt());
				break;
			case CVar.CVAR_Float:
				e = UV_JsonDouble.make(c.GetFloat());
				break;
			case CVar.CVAR_Bool:
				e = UV_JsonBool.make(c.GetBool());
				break;
			case CVar.CVAR_String:
				e = UV_JsonString.make(c.GetString());
				break;
			default:
				ThrowAbortException("Unhandled CVar Type for '"..data.cvarname.."'");
			}
			obj.Set(data.cvarname,e);
		}
		return obj;
	}
	
	static clearscope void LoadPresetJSON(UV_JsonObject obj)
	{
		let handler = UV_PresetHandler(StaticEventHandler.Find('UV_PresetHandler'));
		if (!handler)
		{
			ThrowAbortException("PresetHandler not found");
			return;
		}
		let n = handler.cvardata.Size();
		for(int i = 0; i < n; i++)
		{
			let data = handler.cvardata[i];
			if (!data) continue;

			CVar c = data.c_cvar;
			let e = obj.Get(data.cvarname);
			
			if(!e)
			{
				c.ResetToDefault();
			}
			else switch(c.GetRealType())
			{
			case CVar.CVAR_Int:
			case CVar.CVAR_Color:
				c.SetInt(UV_JsonNumber(e).asInt());
				break;
			case CVar.CVAR_Float:
				c.SetFloat(UV_JsonNumber(e).asDouble());
				break;
			case CVar.CVAR_Bool:
				c.SetBool(UV_JsonBool(e).b);
				break;
			case CVar.CVAR_String:
				c.SetString(UV_JsonString(e).s);
				break;
			default:
				ThrowAbortException("Unhandled CVar Type for '"..data.cvarname.."'");
			}
		}
	}
	
	clearscope void LoadPreset(string preset_name)
	{	
		let obj_e = presets.Get(preset_name);
		if(obj_e && obj_e is "UV_JsonObject")
		{
			LoadPresetJSON(UV_JsonObject(obj_e));
		}
	}
	
	static clearscope void ResetToDefault()
	{
		let handler = UV_PresetHandler(StaticEventHandler.Find('UV_PresetHandler'));
		if (!handler)
		{
			ThrowAbortException("UV_PresetHandler not found");
			return;
		}
		let n = handler.cvardata.Size();
		for(int i = 0; i < n; i++)
		{
			let data = handler.cvardata[i];
			if (!data) continue;
			data.c_cvar.ResetToDefault();
		}
	}
	
	clearscope void ExecuteCommand(name cmd, string preset_name)
	{
		switch(cmd)
		{
		case 'SaveUserPreset':
			presets.Set(preset_name, CurrentToJson());
			SavePresets();
			Console.PrintF("Saved preset: " .. preset_name);
			break;
		case 'DeleteUserPreset':
			presets.Delete(preset_name);
			SavePresets();
			Console.PrintF("Deleted preset: " .. preset_name);
			break;
		case 'LoadUserPreset':
			LoadPreset(preset_name);
			Console.PrintF("Loaded preset: " .. preset_name);
			break;
		case 'ResetToDefault':
		case 'LoadDefaultPreset':
			ResetToDefault();
			break;
		case 'LoadBuiltInPresetJSON':
			{
				UV_JsonObject obj = UV_JsonObject(default_presets.Get(preset_name)); 
				if(obj) LoadPresetJSON(obj);
			}
			break;
		default:
			console.PrintfEx(PRINT_NONOTIFY,TEXTCOLOR_RED.."Unknown command for ExecuteCommand '"..cmd.."'");
		}
	}
	
	void addCVarData(name cvarname) {
		let newData = new('UV_PresetCVarData');
		if (!newData) return;
		if (newData)
		{
			newData.c_cvar = CVar.FindCVar(cvarname);
			if (!newData.c_cvar)
			{
				return;
			}
			newData.cvarName = cvarname;
		}
		if (newData)
		{
			cvarData.Push(newData);
		}
	}
	
	void InitalizeUVCvars() {
			//  Keeping commented out gameplay cvars just in case
// 		addCVarData('uvisor_mod_enabled');
// 		addCVarData('uvisor_tex_res');
		addCVarData('uvisor_show_pieces');
		addCVarData('uvisor_show_glow');
		addCVarData('uvisor_show_glass');
		addCVarData('uvisor_show_tactical_overlay');
		addCVarData('uvisor_show_tactical_marks');
		addCVarData('uvisor_show_armor_grid');
		addCVarData('uvisor_show_glass_cracks');
		addCVarData('uvisor_show_blood_splashes');
// 		addCVarData('uvisor_startup_anim_enabled');
		addCVarData('uvisor_style_helmet_top');
		addCVarData('uvisor_style_helmet_bottom');
		addCVarData('uvisor_style_helmet_corners');
		addCVarData('uvisor_style_side_glass');
		addCVarData('uvisor_style_tactical_overlay_1');
		addCVarData('uvisor_style_tactical_overlay_2');
		addCVarData('uvisor_color_part_top');
		addCVarData('uvisor_sync_part_colors');
		addCVarData('uvisor_color_part_bottom');
		addCVarData('uvisor_color_part_corners');
		addCVarData('uvisor_color_glow');
		addCVarData('uvisor_translucent_glow_style');
		addCVarData('uvisor_sync_glow_glass');
		addCVarData('uvisor_color_glass');
		addCVarData('uvisor_sync_glass_tactical_overlay');
		addCVarData('uvisor_color_tactical_overlay_1');
		addCVarData('uvisor_color_tactical_overlay_2');
		addCVarData('uvisor_color_armor_grid');
		addCVarData('uvisor_color_glass_cracks');
		addCVarData('uvisor_alpha_parts');
		addCVarData('uvisor_alpha_glow');
		addCVarData('uvisor_alpha_glass');
		addCVarData('uvisor_alpha_tactical_1');
		addCVarData('uvisor_alpha_tactical_2');
		addCVarData('uvisor_alpha_armor_grid');
		addCVarData('uvisor_alpha_cracks');
		addCVarData('uvisor_alpha_blood');
		addCVarData('uvisor_override_alpha_bottom');
		addCVarData('uvisor_alpha_part_bottom');
		addCVarData('uvisor_alpha_glow_bottom');
		addCVarData('uvisor_alpha_glass_bottom');
		addCVarData('uvisor_show_part_top');
		addCVarData('uvisor_show_glow_top');
		addCVarData('uvisor_show_glass_top');
		addCVarData('uvisor_show_part_bottom');
		addCVarData('uvisor_show_glow_bottom');
		addCVarData('uvisor_show_glass_bottom');
		addCVarData('uvisor_show_glass_sides');
		addCVarData('uvisor_show_part_corners');
		addCVarData('uvisor_show_glow_corners');
		addCVarData('uvisor_show_glass_corners');
// 		addCVarData('uvisor_auto_hide_corners_mode');
// 		addCVarData('uvisor_auto_hide_corners_screensize');
		addCVarData('uvisor_offset_top');
		addCVarData('uvisor_offset_bottom');
		addCVarData('uvisor_offset_corners_x');
		addCVarData('uvisor_offset_corners_y');
		addCVarData('uvisor_offset_sides_glass');
		addCVarData('uvisor_offset_tactical_marks');
		addCVarData('uvisor_width_scale_bottom');
		addCVarData('uvisor_width_scale_corners');
		addCVarData('uvisor_gameplay_color_basis_glow');
		addCVarData('uvisor_gameplay_color_basis_glass');
		addCVarData('uvisor_gameplay_color_basis_armor_grid');
		addCVarData('uvisor_gameplay_color_step_1');
		addCVarData('uvisor_gameplay_color_step_2');
		addCVarData('uvisor_gameplay_color_step_3');
		addCVarData('uvisor_gameplay_color_step_4');
// 		addCVarData('uvisor_cracks_basis');
// 		addCVarData('uvisor_hide_glow_if_empty_armor');
// 		addCVarData('uvisor_hide_glass_if_empty_armor');
// 		addCVarData('uvisor_hitfeedback_if_empty_armor');
		addCVarData('uvisor_glow_pulse_mode');
		addCVarData('uvisor_glow_pulse_speed');
// 		addCVarData('uvisor_armor_grid_display_mode');
// 		addCVarData('uvisor_gameplay_alpha_basis_armor_grid');
// 		addCVarData('uvisor_powers_overrides_grid_color_mode');
// 		addCVarData('uvisor_grid_disable_when_radsuit_nightvis');
// 		addCVarData('uvisor_transparency_on_invis');
// 		addCVarData('uvisor_hide_helmet_in_third_person');
// 		addCVarData('uvisor_blood_freq');
// 		addCVarData('uvisor_blood_max_init_distance');
// 		addCVarData('uvisor_blood_size');
// 		addCVarData('uvisor_blood_max_count');
// 		addCVarData('uvisor_blood_lifetime');
// 		addCVarData('uvisor_blood_vanishes');
// 		addCVarData('uvisor_screen_wiper_mode');
// 		addCVarData('uvisor_blood_default_saturation_shift');
// 		addCVarData('uvisor_blood_family_friendly_colors');
// 		addCVarData('uvisor_blood_detection_mode');
// 		addCVarData('uvisor_swaying');
// 		addCVarData('uvisor_maxsway_x');
// 		addCVarData('uvisor_maxsway_y');
// 		addCVarData('uvisor_sway_sensitivity');
// 		addCVarData('uvisor_camera_sway_mult_x');
// 		addCVarData('uvisor_camera_sway_mult_y');
// 		addCVarData('uvisor_movement_sway');
// 		addCVarData('uvisor_movement_sway_mult_x');
// 		addCVarData('uvisor_movement_sway_mult_y');
// 		addCVarData('uvisor_movement_sway_mult_bob');
// 		addCVarData('uvisor_bob_sway_mode');
// 		addCVarData('uvisor_bob_sway_freq');
// 		addCVarData('uvisor_crouch_sway');
// 		addCVarData('uvisor_crouch_sway_intensity');
// 		addCVarData('uvisor_jump_sway');
// 		addCVarData('uvisor_jump_sway_intensity');
// 		addCVarData('uvisor_shaking');
// 		addCVarData('uvisor_shaking_sensitivity');
// 		addCVarData('uvisor_warning_sound_mode');
// 		addCVarData('uvisor_warning_volume');
// 		addCVarData('uvisor_warning_sound_channel');
// 		addCVarData('uvisor_cracks_sounds_volume');
// 		addCVarData('uvisor_hit_sounds_volume');
// 		addCVarData('uvisor_depleted_sound_volume');
// 		addCVarData('uvisor_breath_disable_if_no_glass');
// 		addCVarData('uvisor_breath_volume');
// 		addCVarData('uvisor_breath_voice');
// 		addCVarData('uvisor_breath_sound_channel');
// 		addCVarData('uvisor_startup_volume');
// 		addCVarData('uvisor_screen_wiper_volume');
	}
}