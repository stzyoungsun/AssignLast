package com.lpesign.extensions;

import org.json.JSONException;
import org.json.JSONObject;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;


public class Extension implements FREExtension{
	
	private static String TAG = "AirPushNotification";

	public static Context context;
	
	public static boolean isInForeground = false;
	
	public FREContext createContext(String extId)
	{
		return context = new Context();
	}

	public void dispose()
	{
		context = null;
	}
	
	public void initialize() {}
	
	public static void log(String message)
	{
		Log.d(TAG, message);
		
		if (context != null)
		{
			context.dispatchStatusEventAsync("LOGGING", message);
		}
	}
	
	public static String getParametersFromIntent(Intent intent)
	{
		JSONObject paramsJson = new JSONObject();
		Bundle bundle = intent.getExtras();
		String parameters = intent.getStringExtra("parameters");
		try
		{
			for (String key : bundle.keySet())
			{
				paramsJson.put(key, bundle.getString(key));
			}
			
			if(parameters != null)
			{
				paramsJson.put("parameters", new JSONObject(parameters));
			}
		}
		catch (JSONException e)
		{
			e.printStackTrace();
		}
		
		return paramsJson.toString();
	}
}
