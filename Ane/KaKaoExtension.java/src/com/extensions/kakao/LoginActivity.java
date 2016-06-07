package com.extensions.kakao;

import java.security.MessageDigest;


import com.kakao.auth.Session;

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


public class LoginActivity extends Activity{

	private static String TAG = "NativeExtension";
	public static LoginActivity loginActivity = null;
	@Override
	// 로그인 액티비티 입니다
	// 액티비티는 불투명으로 정의되어 있고 로그인 버튼이 달립니다.
	protected void onCreate(Bundle savedInstanceState) {
		Log.d(TAG, "로그인 액티비티 생성");
		super.onCreate(savedInstanceState);
		loginActivity = this;
		
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

	@Override
	public void onBackPressed() {
	    //super.onBackPressed();
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.d(TAG, "로그인 액티비티 종료");
	}
	
}
