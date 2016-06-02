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
		Log.d(TAG, "�α׾ƿ� �Լ� ����");
		Logout();
		return null;
	}

	private void Logout() {
		UserManagement.requestLogout(new LogoutResponseCallback() {
			@Override
			public void onCompleteLogout() {
				Log.d(TAG, "�α׾ƿ� �Ϸ�");
				//�α׾ƿ� �Ϸ�� LOGOUT_OK �̺�Ʈ�� �߻���ŵ�ϴ�.
				InitFunction._flashActivity.dispatchStatusEventAsync("NULL", "LOGOUT_OK");
			}
		});
	}
}
