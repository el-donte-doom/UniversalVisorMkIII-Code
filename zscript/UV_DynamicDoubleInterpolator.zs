// PB_DynamicDoubleInterpolator with permission from generic name guy

class UV_DynamicDoubleInterpolator : Object
{
	double mCurrentValue;
	double mMinChange;
	double mMaxChange;
	double mChangeFactor;

	static UV_DynamicDoubleInterpolator Create(int startval, double changefactor, double minchange, double maxchange)
	{
		let v = new("UV_DynamicDoubleInterpolator");
		v.mCurrentValue = startval;
		v.mMinChange = minchange;
		v.mMaxChange = maxchange;
		v.mChangeFactor = changefactor;
		return v;
	}

	void Reset(double value)
	{
		mCurrentValue = value;
	}

	// This must be called periodically in the status bar's Tick function.
	// Do not call this in the Draw function because that may skip some frames!
	void Update(double destvalue)
	{
		double diff = clamp(abs(destvalue - mCurrentValue) * mChangeFactor, mMinChange, mMaxChange);
		if (mCurrentValue > destvalue)
		{
			mCurrentValue = max(destvalue, mCurrentValue - diff);
		}
		else
		{
			mCurrentValue = min(destvalue, mCurrentValue + diff);
		}
	}

	// This must be called in the draw function to retrieve the value for output.
	double GetValue()
	{
		return mCurrentValue;
	}
}
