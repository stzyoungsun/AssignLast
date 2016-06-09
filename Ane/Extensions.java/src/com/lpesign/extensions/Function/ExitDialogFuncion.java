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
	 @Override
	    public FREObject call(FREContext arg0, FREObject[] arg1) {
	        // TODO Auto-generated method stub
	   
		 	arg0.getActivity().onBackPressed();
	       
	        return null;
	    }
}
