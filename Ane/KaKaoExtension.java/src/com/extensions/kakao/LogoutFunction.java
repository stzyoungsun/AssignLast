package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.LogoutResponseCallback;

import android.util.Log;

public class LogoutFunction implements FREFunction{
	private static String TAG = "NativeExtension";
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		Log.d(TAG, "로그아웃 함수 들어옴");
		Logout();
		return null;
	}

	private void Logout() {
		UserManagement.requestLogout(new LogoutResponseCallback() {
			@Override
			public void onCompleteLogout() {
				Log.d(TAG, "로그아웃 완료");
				//로그아웃 완료시 LOGOUT_OK 이벤트를 발생시킵니다.
				InitFunction._flashActivity.dispatchStatusEventAsync("NULL", "LOGOUT_OK");
			}
		});
	}
}
