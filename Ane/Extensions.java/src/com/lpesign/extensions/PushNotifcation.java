package com.lpesign.extensions;

import android.R;
import android.app.Notification;
import android.app.NotificationManager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
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
        	byte[] arr = intent.getByteArrayExtra("bitmap");
        	CharSequence title = intent.getStringExtra("title");
        	CharSequence message = intent.getStringExtra("message");
        	
        	Bitmap bm = BitmapFactory.decodeByteArray(arr, 0, arr.length);
        	 String pkgName  = context.getPackageName();
        	 
        	Intent notificationIntent = context
        			.getPackageManager()
                    .getLaunchIntentForPackage(pkgName);
        	
        	notificationIntent.addFlags(
                    Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        	
        	PendingIntent contentIntent = PendingIntent.getActivity(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT); 
        	
            NotificationManager notiManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
            
            NotificationCompat.Builder builder = new NotificationCompat.Builder(context);
            builder.setContentTitle(title);
            builder.setContentText(message);
            builder.setSmallIcon(R.drawable.ic_dialog_alert);
            builder.setLargeIcon(bm);
            builder.setAutoCancel(true);
            builder.setContentIntent(contentIntent);
            builder.setWhen(System.currentTimeMillis());
            builder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_VIBRATE | Notification.DEFAULT_LIGHTS);
            Notification noti = builder.build();
            
            notiManager.notify(1000, noti);
        }
        catch(Error error)
        {
            Log.d(TAG, error.toString());
        }
    }
}