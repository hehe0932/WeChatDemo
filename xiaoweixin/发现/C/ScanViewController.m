//
//  ScanViewController.m
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/11.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 扫码页*/
@property (nonatomic,strong)ScanView *scanView;
/** device*/
@property (nonatomic,strong)AVCaptureDevice *device;
/** 输入流*/
@property (nonatomic,strong)AVCaptureDeviceInput *input;
/** 输出流*/
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
/** 链接对象*/
@property (nonatomic,strong)AVCaptureSession *session;
/** preview */
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@end

@implementation ScanViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scanView];
    self.title = @"二维码/条码";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(photoAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    //1.添加预览图层
//    self.preview.frame = self.view.bounds;
//    self.preview.videoGravity = AVLayerVideoGravityResize;
//    [self.view.layer insertSublayer:self.preview atIndex:0];
//    //2.设置输出能够解析的数据类型
//    //注意:设置数据类型一定要在输出对象添加到回话之后才能设置
//    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
//    //高质量采集率
//    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
//    //3.开始扫描
//    [self.session startRunning];

}

- (void)photoAction {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //1.弹出系统相册
        UIImagePickerController *pickVC = [[UIImagePickerController alloc]init];
        //2.设置照片来源
        /** UIImagePickerControllerSourceTypePhotoLibrary,相册 UIImagePickerControllerSourceTypeCamera,相机 UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        pickVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //3.设置代理
        pickVC.delegate = self;
        //4.跳到相册
        self.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:pickVC animated:YES completion:nil];
        
    }else{
        NSLog(@"打开相册失败");
    }
}
#pragma mark - UIImagePickerControllerDelegate代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [SVProgressHUD show];
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //初始化一个监听器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    [picker dismissViewControllerAnimated:YES completion:^{
        //检测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            [SVProgressHUD dismiss];
            //结果对象
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            NSLog(@"%@",scannedResult);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"二维码信息" message:[NSString stringWithFormat:@"%@",scannedResult] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVC addAction:alert];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            [SVProgressHUD dismiss];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"二维码信息" message:[NSString stringWithFormat:@"二维码解析错误"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:alert];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate代理方法  只有这一个代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *object = metadataObjects[0];
        NSString *stringValue = object.stringValue;
        if (stringValue != nil) {
            [self.session stopRunning];
            NSLog(@"扫码结果%@",stringValue);
        }
    }
}
#pragma mark - 懒加载
- (AVCaptureDevice *)device{
    if (!_device) {
        //AVMediaTypeVideo是打开相机
        //AVMediaTypeAudio是打开麦克风
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
- (AVCaptureDeviceInput *)input{
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}
- (AVCaptureMetadataOutput *)output{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //限制扫描区域,默认值是CGRect(x: 0,y: 0, width: 1,height: 1)。通过对这个值的观察，我们发现传入的是比例
        CGRect myRect =CGRectMake(((ScreenHeight - 200) / 2 )/ScreenHeight,((ScreenWidth - 200) /2)/ScreenWidth,200/ScreenHeight, 200/ScreenHeight);
        [_output setRectOfInterest:myRect];
    }
    return _output;
}
- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    return _session;
}
- (AVCaptureVideoPreviewLayer *)preview{
    if (!_preview) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _preview;
}
- (ScanView *)scanView{
    if (!_scanView) {
        _scanView = [[ScanView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scanView.backgroundColor = [UIColor clearColor];
    }
    return _scanView;
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
