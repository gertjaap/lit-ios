//
//  ViewController.h
//  LitPOC
//
//  Created by Gert-Jaap Glasbergen on 08/08/2018.
//  Copyright © 2018 Gert-Jaap Glasbergen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate, WKScriptMessageHandler, WKNavigationDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) IBOutlet WKWebView *webView;


@property (strong, nonatomic) IBOutlet UIView *previewView;
@end

