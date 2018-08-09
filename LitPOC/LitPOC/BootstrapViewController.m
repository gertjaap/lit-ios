//
//  BootstrapViewController.m
//  LitPOC
//
//  Created by Gert-Jaap Glasbergen on 09/08/2018.
//  Copyright © 2018 Gert-Jaap Glasbergen. All rights reserved.
//

#import "BootstrapViewController.h"
#import "ProxyManager.h"

@interface BootstrapViewController ()

@end

@implementation BootstrapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if([ProxyManager isInitialized]) {
        [ProxyManager startProxy];
        [self performSegueWithIdentifier:@"goToMain" sender:self];
    }
}

-(IBAction)startScan:(id)sender {
    _introView.hidden = YES;
    _scanView.hidden = NO;
    
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
            [self stopScan:nil];
            
            [ProxyManager setNodeAddress:[metadataObj stringValue]];
            [ProxyManager startProxy];
            [self performSegueWithIdentifier:@"goToMain" sender:self];
        }
    }
}

-(IBAction)stopScan:(id)sender {
    _introView.hidden = NO;
    _scanView.hidden = YES;
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
