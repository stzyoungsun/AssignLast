 package com.extensions;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.extensions.kakao.GetServerUserDataFunction;
import com.extensions.kakao.InitFunction;
import com.extensions.kakao.IsLoginFunction;
import com.extensions.kakao.LoginFunction;
import com.extensions.kakao.LogoutFunction;
import com.extensions.kakao.SaveUserScoreFunction;
import com.extensions.kakao.UserIDListFunction;
import com.extensions.kakao.UserProfileFunction;



public class Context extends FREContext{


	@Override
    public void dispose() {
        // TODO Auto-generated method stub
 
    }
 
    @Override
    public Map<String, FREFunction> getFunctions() {
        // TODO Auto-generated method stub
    
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        
        map.put("init", new InitFunction());
		map.put("login", new LoginFunction());
		map.put("logout", new LogoutFunction());
		map.put("curuserdata", new UserProfileFunction());
		map.put("loginstate", new IsLoginFunction());
		map.put("saveuserdata", new SaveUserScoreFunction());
		map.put("useridlist", new UserIDListFunction());
		map.put("getserveruserdata", new GetServerUserDataFunction());
		
        return map;
    }
}
