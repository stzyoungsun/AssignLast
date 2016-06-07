package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.os.AsyncTask;
import android.util.Log;

public class GetServerUserDataFunction implements FREFunction{
    private static String TAG = "NativeExtension";
    private String _userNum = "";
    private String _userData;
	 @Override
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
		 	Log.d(TAG, "서버 유저 데이터 불러오기");	
	 
				try {
					_userNum = arg1[0].getAsString();
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
				
				getServerUserData();
				
	        return null;
	    }
	 
		private void getServerUserData()
		{
			Log.d(TAG, "겟 서버 유저 데이터 들어옴");
			new ProcessKakaoTask().execute(null,null,null);
		}

		//AsyncTask<Params,Progress,Result>
		private class ProcessKakaoTask extends AsyncTask<Void, Void, Void>{

			@Override
			protected Void doInBackground(Void... params) {
				try
				{
					Log.d(TAG, "겟 서버 유저 데이터 들어옴1");
					_userData = InitFunction.apiHelper().idTOData(_userNum);
					InitFunction._flashActivity.dispatchStatusEventAsync(_userData, "GET_SERVER_USERDATA");
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
				return null;
			}


		}
}
