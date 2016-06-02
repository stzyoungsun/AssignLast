package com.extensions.kakao;

import java.security.MessageDigest;

import com.kakao.auth.ErrorCode;
import com.kakao.auth.Session;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.MeResponseCallback;
import com.kakao.usermgmt.response.model.UserProfile;
import com.kakao.util.helper.log.Logger;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

public class LoginActivity extends Activity{

	private static UserProfile _playerProfile;
	private static String TAG = "NativeExtension";
	private static LoginActivity _loginActivity;
	
	@Override
	// 로그인 액티비티 입니다
	// 액티비티는 불투명으로 정의되어 있고 로그인 버튼이 달립니다.
	protected void onCreate(Bundle savedInstanceState) {
		Log.d(TAG, "로그인 액티비티 생성");
		_loginActivity = this;
		super.onCreate(savedInstanceState);
		
		
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_BLUR_BEHIND, 
				WindowManager.LayoutParams.FLAG_BLUR_BEHIND);
		//현재 프로젝트의 해쉬키를 받아옵니다.
		getAppKeyHash();// 호출

		setContentView(InitFunction._flashActivity.getResourceId("layout.login_activty"));
	}

	private void getAppKeyHash() {
		try {
			PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_SIGNATURES);
			for (Signature signature : info.signatures) {
				MessageDigest md;
				md = MessageDigest.getInstance("SHA");
				md.update(signature.toByteArray());
				String something = new String(Base64.encode(md.digest(), 0));
				Log.d(TAG, something);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			Log.d(TAG, e.toString());
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (Session.getCurrentSession().handleActivityResult(requestCode, resultCode, data)) {
			return;
		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	
	
	public void requestMe() { //유저의 정보를 받아오는 함수
		UserManagement.requestMe(new MeResponseCallback() {

			@Override
			public void onFailure(ErrorResult errorResult) {
				String message = "failed to get user info. msg=" + errorResult;
				Logger.d(message);

				ErrorCode result = ErrorCode.valueOf(errorResult.getErrorCode());
				if (result == ErrorCode.CLIENT_ERROR_CODE) {
					finish();
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
				Log.d(TAG,"UserProfile" + userProfile);
				_playerProfile = userProfile;
				redirectMainActivity();	
			}
		});
	}
	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.d(TAG, "로그인 액티비티 종료");
	}
	
	//로그인 완료시 요청 되는 함수
	protected void redirectMainActivity() {
		InitFunction._flashActivity.dispatchStatusEventAsync("NULL", "LOGIN_OK");
		Log.d(TAG, "로그인 완료 보냄");
		finish();
		Toast.makeText(InitFunction._flashActivity.getActivity(), _playerProfile.getNickname() + "님 환영합니다.", Toast.LENGTH_LONG).show();
	}

	public static LoginActivity loginActivity()
	{
		if(_loginActivity != null)
			return _loginActivity;
		else
			return null;
	}
	
	public static UserProfile userProfile()
	{
		if(_loginActivity != null)
			return _playerProfile;
		else
			return null;
	}
}
