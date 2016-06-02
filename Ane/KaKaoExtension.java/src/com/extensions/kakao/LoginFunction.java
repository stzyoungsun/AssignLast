package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import android.content.Intent;

import android.util.Log;


public class LoginFunction implements FREFunction{
    private static String TAG = "NativeExtension";
	 @Override
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
		 	Log.d(TAG, "로그인 요청");	
	 
		 	//로그인 요청 시 로그인 액티비티 인텐트
	        Intent spriteIntent = new Intent(arg0.getActivity(),LoginActivity.class);
	        arg0.getActivity().startActivity(spriteIntent);
	        return null;
	    }
}
