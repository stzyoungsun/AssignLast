package com.lpesign.extensions.Function;

import java.io.ByteArrayOutputStream;

import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.lpesign.extensions.SpriteActivity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.util.Log;


public class SpriteSheetFunction implements FREFunction{
	private Activity _flashActivity;
	private static String TAG = "NativeExtension";
	 @Override
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
		 
		 _flashActivity = arg0.getActivity();
		 byte[] byteArray = {};
	        try {
	        	
	        	 FREBitmapData inputValue = (FREBitmapData)arg1[0];
	        	 inputValue.acquire();
	        	 Log.d(TAG, "[NativeExtension] Bitmapdata Width : "+inputValue.getWidth());
	   		    int srcWidth = inputValue.getWidth();
	   		    int srcHeight = inputValue.getHeight();
	   		    Bitmap bm = Bitmap.createBitmap(srcWidth, srcHeight, Config.ARGB_8888);
	   		    
	   		    bm.copyPixelsFromBuffer(inputValue.getBits());
	   		    ByteArrayOutputStream os = new ByteArrayOutputStream();
	   		    
	   		    bm.compress(Bitmap.CompressFormat.JPEG, 80, os);
	   		    byteArray =  os.toByteArray();
	   		    Log.d(TAG, "[NativeExtension] byteArray : "+byteArray.length);
	   		    inputValue.release();

	        } catch (IllegalStateException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        } catch (FREInvalidObjectException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (FREWrongThreadException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
	        Log.d(TAG, "[NativeExtension] byteArray 123: "+byteArray.length);
	        Intent spriteIntent = new Intent(_flashActivity,SpriteActivity.class);
	        spriteIntent.putExtra("image",byteArray);
	        _flashActivity.startActivity(spriteIntent);
	       
	        return null;
	    }
}
