package com.lpesign.extensions;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.lpesign.extensions.Function.AlarmFunction;
import com.lpesign.extensions.Function.ExitDialogFuncion;
import com.lpesign.extensions.Function.InputFunction;
import com.lpesign.extensions.Function.ListDialogFunction;
import com.lpesign.extensions.Function.SpriteSheetFunction;
import com.lpesign.extensions.Function.ToastFunction;

public class Context extends FREContext{


	@Override
    public void dispose() {
        // TODO Auto-generated method stub
 
    }
 
    @Override
    public Map<String, FREFunction> getFunctions() {
        // TODO Auto-generated method stub
    
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put("toast", new ToastFunction());
        map.put("exitdialog",new ExitDialogFuncion());
        map.put("listdialog",new ListDialogFunction());
		map.put("spritesheet",new SpriteSheetFunction());
		map.put("push", new AlarmFunction());
		map.put("input", new InputFunction());

        return map;
    }
}
