//
//  ViewController.m
//  LitPOC
//
//  Created by Gert-Jaap Glasbergen on 08/08/2018.
//  Copyright © 2018 Gert-Jaap Glasbergen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"webui"]];
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    [contentController addScriptMessageHandler:self name:@"qrScanner"];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = contentController;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


-(IBAction)startScan:(CGRect)previewRect {
    _previewView = [[UIView alloc] initWithFrame:previewRect];
    [self.view insertSubview:_previewView aboveSubview:_webView];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadata = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadata];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("captureQueue",NULL);
    [captureMetadata setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadata setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewView.layer.bounds];
    [_previewView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if(metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            if([[metadataObj stringValue] hasPrefix:@"ln1"]) {
                // Inform webview of scanning result
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopScan:nil];
                    [_webView evaluateJavaScript:[NSString stringWithFormat:@"var event = new Event('qrRead'); event.data = '%@'; window.dispatchEvent(event);",[metadataObj stringValue]] completionHandler: nil];
                    
                });
                
                
            }
        }
    }
}

-(IBAction)stopScan:(id)sender {
    [_previewView removeFromSuperview];
    _previewView = nil;
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if([message.body hasPrefix:@"startQrScan"]) {
        NSArray *params = [message.body componentsSeparatedByString:@"|"];
        if([params count] > 1) {
            NSArray *coords = [[params objectAtIndex:1] componentsSeparatedByString:@","];
            if([coords count] == 4) {
                [self startScan:CGRectMake([[coords objectAtIndex:0] intValue],[[coords objectAtIndex:1] intValue],[[coords objectAtIndex:2] intValue],[[coords objectAtIndex:3] intValue])];
            }
        }
        else {
            [self startScan:CGRectMake(10,10,400,400)];
        }
    }
    
    if([message.body hasPrefix:@"stopQrScan"]) {
        [self stopScan:nil];
    }
}

@end
