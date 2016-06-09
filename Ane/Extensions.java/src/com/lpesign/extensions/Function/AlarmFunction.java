package com.lpesign.extensions.Function;

import java.io.ByteArrayOutputStream;

import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.lpesign.extensions.PushNotifcation;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.os.IBinder;
import android.util.Log;


public class AlarmFunction implements FREFunction
{
	private static String TAG = "NativeExtension";
    
    private  FREContext _context;
    private  CharSequence _title = "";
    private  CharSequence _message = "";
    private int _interval = 0;
    private boolean _alarmFlag = false;
    
    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) 
    {
        _context = arg0;
        try 
        {
        	_title = arg1[0].getAsString();
            _message = arg1[1].getAsString(); 
            _interval = arg1[2].getAsInt();
            _alarmFlag = arg1[3].getAsBool();
            Log.d(TAG, "시간" + _interval);
        }
        catch (IllegalStateException e)
        {
            // TODO Auto-generated catch block
        	 Log.d(TAG, e.toString());
            e.printStackTrace();
        }
        catch (FRETypeMismatchException e)
        {
            // TODO Auto-generated catch block
        	 Log.d(TAG, e.toString());
            e.printStackTrace();
        }
        catch (FREInvalidObjectException e)
        {
            // TODO Auto-generated catch block
        	 Log.d(TAG, e.toString());
            e.printStackTrace();
        }
        catch (FREWrongThreadException e)
        {
            // TODO Auto-generated catch block
        	 Log.d(TAG, e.toString());
            e.printStackTrace();
        }
        
        setAlarm();
        return null;
    }
    

private boolean setAlarm(){

    try{
         AlarmManager alarm = (AlarmManager) _context.getActivity().getSystemService(Context.ALARM_SERVICE);
         //아래는 리시버에서 호출할 이름을 지정
         Intent putIntent = new Intent(_context.getActivity(),PushNotifcation.class);
         
         putIntent.putExtra("title",_title);
         putIntent.putExtra("message",_message);
         
         PendingIntent pender = PendingIntent.getBroadcast(_context.getActivity(), 0, putIntent, 0);
         Log.d(TAG, "알람 날림");
         if(_alarmFlag == true)
        	 alarm.set(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + _interval , pender);
         else
        	 alarm.cancel(pender);

         return true;

        }catch(Exception e){
        Log.d(TAG, e.toString());
         e.printStackTrace();
        }
        return false;
      }
}