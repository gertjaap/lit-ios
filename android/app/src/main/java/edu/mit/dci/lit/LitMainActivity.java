package edu.mit.dci.lit;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import litrpcproxy.Litrpcproxy;

public class LitMainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        byte[] mKey = new byte[] { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 };
        try {
            Litrpcproxy.startUnconnectedProxy(mKey, 45678);
        } catch (Exception ex) {
            Log.e("LitRPC", ex.toString());
        }


        // Create new Webview to hold the WebUI
        WebView webView = new WebView(getApplicationContext());

        // Enable Javascript
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);


        setContentView(webView);
        WebView.setWebContentsDebuggingEnabled(true);
        webView.loadUrl("http://10.200.4.154:3000/?port=45678");




    }

}
