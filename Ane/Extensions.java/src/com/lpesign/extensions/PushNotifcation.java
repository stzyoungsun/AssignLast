package com.lpesign.extensions;

import android.R;
import android.app.Notification;
import android.app.NotificationManager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import android.app.PendingIntent;

public class PushNotifcation extends BroadcastReceiver
{
    private String TAG = "PushFunction";
    
    @Override
    public void onReceive(Context context, Intent intent) 
    {
        try
        {
        	 Log.d(TAG, "Çª½Ã µé¾î¿È");
        	CharSequence title = intent.getStringExtra("title");
        	CharSequence message = intent.getStringExtra("message");
        	
        	 String pkgName  = context.getPackageName();
        	 
        	Intent notificationIntent = context
        			.getPackageManager()
                    .getLaunchIntentForPackage(pkgName);
        	
        	notificationIntent.addFlags(
                    Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        	Log.d(TAG, "Çª½Ã µé¾î¿È1");
        	PendingIntent contentIntent = PendingIntent.getActivity(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT); 
        	
            NotificationManager notiManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
            
            NotificationCompat.Builder builder = new NotificationCompat.Builder(context);
            builder.setContentTitle(title);
            builder.setContentText(message);
            builder.setSmallIcon(context.getResources().getIdentifier("icon", "drawable", context.getPackageName()));
            builder.setAutoCancel(true);
            builder.setContentIntent(contentIntent);
            builder.setWhen(System.currentTimeMillis());
            builder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_VIBRATE | Notification.DEFAULT_LIGHTS);
            Notification noti = builder.build();
            Log.d(TAG, "Çª½Ã µé¾î¿È2");
            notiManager.notify(1000, noti);
        }
        catch(Error error)
        {
            Log.d(TAG, error.toString());
        }
    }
}