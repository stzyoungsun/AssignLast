package com.lpesign.extensions.Function;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Service;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;



public class ExitDialogFuncion implements FREFunction{
	private Activity _flashActivity;
	private Boolean _clickedFlag = false;
	 @Override
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub

	        try {
	        	_clickedFlag = arg1[0].getAsBool();
	            _flashActivity = arg0.getActivity();	
	        } catch (IllegalStateException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        } catch (FRETypeMismatchException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        } catch (FREInvalidObjectException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        } catch (FREWrongThreadException e) {
	            // TODO: handle exception
	            e.printStackTrace();
	        }
	        if(_clickedFlag == true)
	        {
	        	  AlertDialog.Builder exitDialog = new AlertDialog.Builder(arg0.getActivity());
	        	  exitDialog.setTitle("Á¾·á Ã¢");
	        	  exitDialog.setPositiveButton("Ok", new OnClickListener() {
	        		  
	  				@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						_flashActivity.onBackPressed();
					}
				}).setNegativeButton("Cancel", new OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						return;
					}
				});
	        	 
	        	  exitDialog.show();
	        }
	        return null;
	    }
}
