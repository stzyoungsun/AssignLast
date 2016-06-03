package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import android.os.AsyncTask;
import android.util.Log;

public class UserIDListFunction implements FREFunction{
	private static String TAG = "NativeExtension";
	private String _idList;
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		Log.d(TAG, "���� ID ����Ʈ ��û");	
		getIDList();
		return null;
	}
	
	private void getIDList()
	{
		Log.d(TAG, "���� ID ����Ʈ ����");
		new ProcessKakaoTask().execute(null,null,null);
	}
	
	//AsyncTask<Params,Progress,Result>
	private class ProcessKakaoTask extends AsyncTask<Void, Void, Void>{

		@Override
		protected Void doInBackground(Void... params) {
			try
			{
				Log.d(TAG, "���� ID ����Ʈ ����1");
				_idList = InitFunction.apiHelper().getUserIds();
				InitFunction._flashActivity.dispatchStatusEventAsync(_idList, "GET_IDLIST");
			}
			catch (Exception e)
			{
				e.printStackTrace();
				Log.d(TAG, "���� ID ����");
			}
			return null;
		}
	}
}
