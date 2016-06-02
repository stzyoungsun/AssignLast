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
	public  SessionCallback _callback;      //콜백 선언

	private static String TAG = "NativeExtension";
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		Log.d(TAG, "초기화 들어옴");	
		_flashActivity = arg0;	
	
		//세션콜백을 할당
		_callback = new SessionCallback();  
		Session.getCurrentSession().addCallback(_callback);// 이 두개의 함수 중요함
		return null;
	}
	
	public class SessionCallback implements ISessionCallback {

		@Override
		//로그인 시 세션의 오픈
		public void onSessionOpened() {
			Log.d(TAG, "세션 오픈 완료");
			//로그인 완료 후 로그인 완료 함수 요청
			LoginActivity.loginActivity().requestMe();
		}
		
		@Override
		//로그인 실패 했을 경우
		public void onSessionOpenFailed(KakaoException exception) {
			if(exception != null) {
				Log.d(TAG,"오류 : " + exception);
			}
		}                                            
	}
}
