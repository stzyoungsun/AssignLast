package com.extensions.kakao;

import java.security.MessageDigest;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.kakao.auth.ErrorCode;
import com.kakao.auth.ISessionCallback;
import com.kakao.auth.Session;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.MeResponseCallback;
import com.kakao.usermgmt.response.model.UserProfile;
import com.kakao.util.exception.KakaoException;
import com.kakao.util.helper.log.Logger;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

public class InitFunction implements FREFunction {

	public static FREContext _flashActivity;
	public  SessionCallback _callback;      //콜백 선언
	private static UserProfile _playerProfile;
	
	private static String TAG = "NativeExtension";
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		Log.d(TAG, "초기화 들어옴");	
		_flashActivity = arg0;
	
		//세션콜백을 할당
		_callback = new SessionCallback();  
		Session.getCurrentSession().addCallback(_callback);// 이 두개의 함수 중요함
		Session.getCurrentSession().checkAndImplicitOpen();
		
		return null;
	}
	
	public class SessionCallback implements ISessionCallback {

		@Override
		//로그인 시 세션의 오픈
		public void onSessionOpened() {
			Log.d(TAG, "세션 오픈 완료");
			//로그인 완료 후 로그인 완료 함수 요청
			requestMe();
		}
		
		@Override
		//로그인 실패 했을 경우
		public void onSessionOpenFailed(KakaoException exception) {
			if(exception != null) {
				Log.d(TAG,"오류 : " + exception);
			}
		}                                            
	}
	
	public void requestMe() { //유저의 정보를 받아오는 함수
		UserManagement.requestMe(new MeResponseCallback() {

			@Override
			public void onFailure(ErrorResult errorResult) {
				String message = "failed to get user info. msg=" + errorResult;
				Logger.d(message);

				ErrorCode result = ErrorCode.valueOf(errorResult.getErrorCode());
				if (result == ErrorCode.CLIENT_ERROR_CODE) {
				} else {

				}
			}
			
			@Override
			public void onSessionClosed(ErrorResult errorResult) {
			}

			@Override
			public void onNotSignedUp() {} // 카카오톡 회원이 아닐 시 showSignup(); 호출해야함

			@Override
			public void onSuccess(UserProfile userProfile) {  //성공 시 userProfile 형태로 반환
				_playerProfile = userProfile;
				redirectMainActivity();
			}
		});
	}
	
	//로그인 완료시 요청 되는 함수
	protected void redirectMainActivity() {
		InitFunction._flashActivity.dispatchStatusEventAsync("NULL", "LOGIN_OK");
		Log.d(TAG, "로그인 완료 보냄0");
		Toast.makeText(InitFunction._flashActivity.getActivity(), _playerProfile.getNickname() + "님 환영합니다.", Toast.LENGTH_LONG).show();
		Log.d(TAG, "모지" + LoginActivity.loginActivity);
		
		if(LoginActivity.loginActivity != null)
		{
			Log.d(TAG, "액티비티 죽음");
			LoginActivity.loginActivity.finish();
		}
	}
	
	public static UserProfile userProfile()
	{
		return _playerProfile;
	}
}
