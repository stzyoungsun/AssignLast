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
	 //�α��� ������ üũ �ϴ� �Լ�
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
		 	Log.d(TAG, "�α��� ���� Ȯ��");	
	  
		 	if(Session.getCurrentSession().isClosed() == true)
		 	{
		 		try {
		 			//�α����� �ƴ� ��� LOGIN_OFF �̺�Ʈ �߻�
		 			_loginState = FREObject.newObject("LOGIN_OFF");
				} catch (FREWrongThreadException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		 	}
		 	else
		 	{
		 		try {
		 			//�α��� �� ��� LOGIN_ON �̺�Ʈ �߻�
		 			_loginState = FREObject.newObject("LOGIN_ON");
				} catch (FREWrongThreadException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		 	}
		 	
		 	 return _loginState;
	    }
}


