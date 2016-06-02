package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.kakao.auth.ISessionCallback;
import com.kakao.auth.Session;
import com.kakao.util.exception.KakaoException;

import android.util.Log;

public class InitFunction implements FREFunction {

	public static FREContext _flashActivity;
	public  SessionCallback _callback;      //�ݹ� ����

	private static String TAG = "NativeExtension";
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		Log.d(TAG, "�ʱ�ȭ ����");	
		_flashActivity = arg0;	
	
		//�����ݹ��� �Ҵ�
		_callback = new SessionCallback();  
		Session.getCurrentSession().addCallback(_callback);// �� �ΰ��� �Լ� �߿���
		return null;
	}
	
	public class SessionCallback implements ISessionCallback {

		@Override
		//�α��� �� ������ ����
		public void onSessionOpened() {
			Log.d(TAG, "���� ���� �Ϸ�");
			//�α��� �Ϸ� �� �α��� �Ϸ� �Լ� ��û
			LoginActivity.loginActivity().requestMe();
		}
		
		@Override
		//�α��� ���� ���� ���
		public void onSessionOpenFailed(KakaoException exception) {
			if(exception != null) {
				Log.d(TAG,"���� : " + exception);
			}
		}                                            
	}
}
