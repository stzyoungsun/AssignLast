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
	// �α��� ��Ƽ��Ƽ �Դϴ�
	// ��Ƽ��Ƽ�� ���������� ���ǵǾ� �ְ� �α��� ��ư�� �޸��ϴ�.
	protected void onCreate(Bundle savedInstanceState) {
		Log.d(TAG, "�α��� ��Ƽ��Ƽ ����");
		_loginActivity = this;
		super.onCreate(savedInstanceState);
		
		
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_BLUR_BEHIND, 
				WindowManager.LayoutParams.FLAG_BLUR_BEHIND);
		//���� ������Ʈ�� �ؽ�Ű�� �޾ƿɴϴ�.
		getAppKeyHash();// ȣ��

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

	
	
	public void requestMe() { //������ ������ �޾ƿ��� �Լ�
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
			public void onNotSignedUp() {} // īī���� ȸ���� �ƴ� �� showSignup(); ȣ���ؾ���

			@Override
			public void onSuccess(UserProfile userProfile) {  //���� �� userProfile ���·� ��ȯ
				Log.d(TAG,"UserProfile" + userProfile);
				_playerProfile = userProfile;
				redirectMainActivity();	
			}
		});
	}
	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.d(TAG, "�α��� ��Ƽ��Ƽ ����");
	}
	
	//�α��� �Ϸ�� ��û �Ǵ� �Լ�
	protected void redirectMainActivity() {
		InitFunction._flashActivity.dispatchStatusEventAsync("NULL", "LOGIN_OK");
		Log.d(TAG, "�α��� �Ϸ� ����");
		finish();
		Toast.makeText(InitFunction._flashActivity.getActivity(), _playerProfile.getNickname() + "�� ȯ���մϴ�.", Toast.LENGTH_LONG).show();
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
