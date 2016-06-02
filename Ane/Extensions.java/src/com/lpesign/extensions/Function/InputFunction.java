package com.lpesign.extensions.Function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager.LayoutParams;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;

public class InputFunction implements FREFunction {
	
	@Override
	public FREObject call(final FREContext arg0, FREObject[] arg1) {
		// ���̾ƿ� �ҷ�����
		final LinearLayout linearLayout = (LinearLayout) View.inflate(arg0.getActivity(), arg0.getResourceId("layout.input_text"), null);
		
		// ���̾�α� ����
		final Dialog dialog  = new Dialog(arg0.getActivity());
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		// ������ �ҷ��� ���̾ƿ��� ���̾�α׿� ����
		dialog.setContentView(linearLayout);
		dialog.show();
		
		// ���̾�α��� ũ�� ����
		DisplayMetrics dm = arg0.getActivity().getResources().getDisplayMetrics();
		LayoutParams params = dialog.getWindow().getAttributes();
		params.width = (int) (dm.widthPixels);
		params.height = (int) (dm.heightPixels * 0.4);
		dialog.getWindow().setAttributes(params);
		
		Button okBtn = (Button) linearLayout.findViewById(arg0.getResourceId("id.ok_button"));
		final EditText editText = (EditText) linearLayout.findViewById(arg0.getResourceId("id.id_edit_text"));
		
		okBtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				// Ű���� �����
				InputMethodManager ipm = (InputMethodManager) arg0.getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
				ipm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
				// EditText�� �Էµ� ���ڿ��� ������ �̺�Ʈ�� ����ġ
				arg0.dispatchStatusEventAsync(editText.getText().toString(), "INPUT_ID");
				// ���̾�α� ���ֱ�
                dialog.dismiss();
			}
		});
		
		return null;
	}
}
