package com.extensions.kakao;

import com.kakao.auth.KakaoSDK;
import com.kakao.util.helper.log.Logger;

import android.app.Activity;
import android.app.Application;
import android.util.Log;

//맨 위창에 실행 되는 GlobalApplication (카톡 연동을 준비)
public class GlobalApplication extends Application {
	private static GlobalApplication mInstance;
	private static volatile Activity currentActivity = null;
	private static String TAG = "NativeExtension";
	
	public static Activity getCurrentActivity() {
		Logger.d("TAG",
				"++ currentActivity : " + (currentActivity != null ? currentActivity.getClass().getSimpleName() : ""));
		return currentActivity;
	}

	public static void setCurrentActivity(Activity currentActivity) {
		GlobalApplication.currentActivity = currentActivity;
	}

	/**
	 * singleton
	 * 
	 * @return singleton
	 */
	public static GlobalApplication getGlobalApplicationContext() {
		if (mInstance == null)
			throw new IllegalStateException("this application does not inherit GlobalApplication");
		return mInstance;
	}

	@Override
	public void onCreate() {
		super.onCreate();
		Log.d(TAG, "글로벌 들어옴");
		mInstance = this;
		KakaoSDK.init(new KakaoSDKAdapter());
	}
}
