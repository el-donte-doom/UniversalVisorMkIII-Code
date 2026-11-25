// Used to show different text in the menu based on sway source 
// (zdoom wiki is incorrect about built-in StaticTextSwitchable, it doesn't use cvar, according to source code)
class OptionMenuItemUV_DynamicText : OptionMenuItemStaticText 
{
	CVar mCvar;
	String mTextDefault;
	String mTextAlt;

	OptionMenuItemUV_DynamicText Init(String cvarName, String textOn, String textOff = "", int color = -1) {
		mCvar = CVar.FindCVar(cvarName);
		mTextDefault = textOff;
		mTextAlt = textOn;
		Super.Init(textOff, color);
		return self;
	}

	override int Draw(OptionMenuDescriptor desc, int y, int indent, bool selected) {
		bool isAlt = (mCvar != null && mCvar.GetBool());
		String currentText = isAlt ? mTextAlt : mTextDefault;
		mLabel = currentText;
		return Super.Draw(desc, y, indent, selected);
	}
}