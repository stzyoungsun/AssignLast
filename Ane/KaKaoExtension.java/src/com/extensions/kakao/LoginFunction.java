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
		 	Log.d(TAG, "�α��� ��û");	
	 
		 	//�α��� ��û �� �α��� ��Ƽ��Ƽ ����Ʈ
	        Intent spriteIntent = new Intent(arg0.getActivity(),LoginActivity.class);
	        arg0.getActivity().startActivity(spriteIntent);
	        return null;
	    }
}
