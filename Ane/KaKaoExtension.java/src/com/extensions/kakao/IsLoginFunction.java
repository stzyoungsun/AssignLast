package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.kakao.auth.Session;

import android.util.Log;

public class IsLoginFunction implements FREFunction{
    private static String TAG = "NativeExtension";
    private FREObject   _loginState;
	 @Override
	 //로그인 유무를 체크 하는 함수
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
		 	Log.d(TAG, "로그인 상태 확인");	
	  
		 	if(Session.getCurrentSession().isClosed() == true)
		 	{
		 		try {
		 			//로그인이 아닐 경우 LOGIN_OFF 이벤트 발생
		 			_loginState = FREObject.newObject("LOGIN_OFF");
				} catch (FREWrongThreadException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		 	}
		 	else
		 	{
		 		try {
		 			//로그인 일 경우 LOGIN_ON 이벤트 발생
		 			_loginState = FREObject.newObject("LOGIN_ON");
				} catch (FREWrongThreadException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		 	}
		 	
		 	 return _loginState;
	    }
}


