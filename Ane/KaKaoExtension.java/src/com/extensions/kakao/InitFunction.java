package com.extensions.kakao;

import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Map;

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
import android.os.AsyncTask;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

public class InitFunction implements FREFunction {

	public static FREContext _flashActivity;
	public  SessionCallback _callback;      //�ݹ� ����
	private static UserProfile _playerProfile;

	private static String TAG = "NativeExtension";

	private static KakaoRestApiHelper _apiHelper = new KakaoRestApiHelper();
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		Log.d(TAG, "�ʱ�ȭ ����");	
		_flashActivity = arg0;

		_apiHelper.setAccessToken("06373bbd67f9fd15336a54f07286d73c");
		_apiHelper.setAdminKey("fe0c6b0f34c49d111226e48254e87808");

		//�����ݹ��� �Ҵ�
		_callback = new SessionCallback();  
		Session.getCurrentSession().addCallback(_callback);// �� �ΰ��� �Լ� �߿���
		Session.getCurrentSession().checkAndImplicitOpen();

		return null;
	}

	public class SessionCallback implements ISessionCallback {

		@Override
		//�α��� �� ������ ����
		public void onSessionOpened() {
			Log.d(TAG, "���� ���� �Ϸ�1");
			//�α��� �Ϸ� �� �α��� �Ϸ� �Լ� ��û
			//feed();
			requestMe();
		}

		@Override
		//�α��� ���� ���� ���
		public void onSessionOpenFailed(KakaoException exception) {
			if(exception != null) {
				Log.d(TAG,"���� : " + exception);
			}
		}                                            
	}

	public void requestMe() { //������ ������ �޾ƿ��� �Լ�
		UserManagement.requestMe(new MeResponseCallback() {

			@Override
			public void onFailure(ErrorResult errorResult) {
				String message = "failed to get user info. msg=" + errorResult;
				Logger.d(message);

				ErrorCode result = ErrorCode.valueOf(errorResult.getErrorCode());
				if (result == ErrorCode.CLIENT_ERROR_CODE) {
				} else {
					Log.d(TAG, "���� ���� ����1");	
				}
			}

			@Override
			public void onSessionClosed(ErrorResult errorResult) {
				Log.d(TAG, "���� ���� ����2");
			}

			@Override
			public void onNotSignedUp() {} // īī���� ȸ���� �ƴ� �� showSignup(); ȣ���ؾ���

			@Override
			public void onSuccess(UserProfile userProfile) {  //���� �� userProfile ���·� ��ȯ
				_playerProfile = userProfile;
				redirectMainActivity();
			}
		});
	}

	//�α��� �Ϸ�� ��û �Ǵ� �Լ�
	protected void redirectMainActivity() {
		//�α��� �Ϸ� �̺�Ʈ ����
		InitFunction._flashActivity.dispatchStatusEventAsync("NULL", "LOGIN_OK");
		Log.d(TAG, "�α��� �Ϸ� ����0");
		Toast.makeText(InitFunction._flashActivity.getActivity(), _playerProfile.getNickname() + "�� ȯ���մϴ�.", Toast.LENGTH_LONG).show();
		Log.d(TAG, "����" + LoginActivity.loginActivity);

		if(LoginActivity.loginActivity != null)
		{
			Log.d(TAG, "��Ƽ��Ƽ ����");
			LoginActivity.loginActivity.finish();
		}
	}

	public static UserProfile userProfile()
	{
		return _playerProfile;
	}

	public static KakaoRestApiHelper apiHelper()
	{
		return _apiHelper;
	}

}
