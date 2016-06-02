package com.extensions.kakao;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;


//현재 접속 중이 유저의 정보를 리턴 합니다.
public class UserProfileFunction implements FREFunction{
	private FREObject   _playerFREObject;
	private String   _playerString = "";
	
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		_playerString = "";
		
		_playerString += LoginActivity.userProfile().getId();
		_playerString += "$";
		
		_playerString += LoginActivity.userProfile().getNickname();
		_playerString += "$";
		
		_playerString += LoginActivity.userProfile().getProfileImagePath();
		_playerString += "$";
		
		try {
			_playerFREObject = FREObject.newObject(_playerString);
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		return _playerFREObject;
	}
}


