package com.lpesign.extensions.Function;

import java.util.List;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.widget.Toast;

public class NoCheatFunction implements FREFunction{
	 @Override
	 public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
		 	
		    PackageManager pm = arg0.getActivity().getPackageManager();
			List< ApplicationInfo > appList = pm.getInstalledApplications( 0 );
			int nSize = appList.size();
			for( int i = 0; i < nSize; i++ ) {
				if(
					(appList.get(i).packageName.indexOf("com.cih.gamecih2") != -1) ||
					(appList.get(i).packageName.indexOf("com.cih.game_cih") != -1) ||			
					(appList.get(i).packageName.indexOf("cn.maocai.gamekiller") != -1) ||			
					(appList.get(i).packageName.indexOf("idv.aqua.bulldog") != -1)
				) 
					
				{
					Toast toast = Toast.makeText(arg0.getActivity(), "치트 어플 발견! 지우고 실행해주세요!", Toast.LENGTH_LONG);
					toast.show();
					arg0.getActivity().onBackPressed();
				}
			}
			return null;
	 }
}

