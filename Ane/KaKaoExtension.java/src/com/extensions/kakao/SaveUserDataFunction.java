package com.extensions.kakao;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.kakao.auth.ApiResponseCallback;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.util.helper.log.Logger;

import android.util.Log;

public class SaveUserDataFunction implements FREFunction{
	private static String TAG = "NativeExtension";
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		 String itemField = "";
		 String misson = "";
		 String exitTime = "";
		 
		try {
			itemField = arg1[0].getAsString();
			misson = arg1[1].getAsString();
			exitTime = arg1[2].getAsString();
        } catch (IllegalStateException e) {
            // TODO: handle exception
            e.printStackTrace();
        } catch (FRETypeMismatchException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		Log.d(TAG, "세이브 들어옴1");
		requestUpdateProfile(itemField, misson, exitTime);
		Log.d(TAG, "세이브 나감");
		return null;
	}

	private void requestUpdateProfile(String itemField, String misson, String exitTime) {
		final Map<String, String> properties = new HashMap<String, String>();
		properties.put("itemfield", itemField);
		properties.put("misson", misson);
		properties.put("exit_time", exitTime);
		Log.d(TAG, "세이브 들어옴");
		UserManagement.requestUpdateProfile(new ApiResponseCallback<Long>() {
			@Override
			public void onSuccess(Long userId) {
				InitFunction.userProfile().updateUserProfile(properties);
				if (InitFunction.userProfile() != null) {
					InitFunction.userProfile().saveUserToCache();
				}
				Log.d(TAG,"succeeded to update user profile" + InitFunction.userProfile());
				InitFunction._flashActivity.dispatchStatusEventAsync("NULL", "SAVE_DATA");
			}

			@Override
			public void onNotSignedUp() {
				Log.d(TAG, "3");
				//redirectSignupActivity(self);
			}

			@Override
			public void onFailure(ErrorResult errorResult) {
				Log.d(TAG, "4");
				String message = "failed to get user info. msg=" + errorResult;
				Logger.e(message);
			}

			@Override
			public void onSessionClosed(ErrorResult errorResult) {
				//redirectLoginActivity(self);
				Log.d(TAG, "5");
			}

		}, properties);
	}
}
