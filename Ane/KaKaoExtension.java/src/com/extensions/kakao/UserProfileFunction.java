package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.kakao.auth.ErrorCode;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.MeResponseCallback;
import com.kakao.usermgmt.response.model.UserProfile;
import com.kakao.util.helper.log.Logger;

import android.util.Log;


//���� ���� ���� ������ ������ ���� �մϴ�.
public class UserProfileFunction implements FREFunction{

	private String   _playerString = "";
	private static String TAG = "NativeExtension";
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub

		requestMe();
			
		return null;
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
					Log.d(TAG, "���� ���� ����3");
				}
			}

			@Override
			public void onSessionClosed(ErrorResult errorResult) {
			}

			@Override
			public void onNotSignedUp() {} // īī���� ȸ���� �ƴ� �� showSignup(); ȣ���ؾ���

			@Override
			public void onSuccess(UserProfile userProfile) {  //���� �� userProfile ���·� ��ȯ
				_playerString = "";
				
				_playerString += userProfile.getId();
				_playerString += "$";
				
				_playerString += userProfile.getNickname();
				_playerString += "$";
				
				_playerString += userProfile.getProfileImagePath();
				_playerString += "$";
				
				_playerString += userProfile.getProperty("score");
				_playerString += "$";
				
				_playerString += userProfile.getProperty("itemfield");
				_playerString += "$";

				_playerString += userProfile.getProperty("misson");
				_playerString += "$";
				
				_playerString += userProfile.getProperty("exit_time");
				_playerString += "$";
				
				Log.d(TAG,"_playerString" + _playerString);
				InitFunction._flashActivity.dispatchStatusEventAsync(_playerString, "GET_USERDATA");
			}
		});
	}
}


