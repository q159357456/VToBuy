//
//  ScanningQRCodeVC.m
//  Restaurant
//
//  Created by 张帆 on 16/11/4.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "ScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanningQRCodeView.h"
#import "ScanSuccessJumpVC.h"
#import "ErWeiMaWebViewController.h"
@interface ScanningQRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) ScanningQRCodeView *scanningView;

@property (nonatomic, strong) UIButton *right_Button;
@property (nonatomic, assign) BOOL first_push;

@end

@implementation ScanningQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
  
    self.navigationController.navigationBar.translucent=YES;
    // 创建扫描边框
    self.scanningView = [[ScanningQRCodeView alloc] initWithFrame:self.view.frame outsideViewLayer:self.view.layer withScanType:self.scanStyle WithSuperViewController:self];
    [self.view addSubview:self.scanningView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBar.translucent=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];

    self.navigationItem.title = @"扫一扫";

    // 二维码扫描
    [self setupScanningQRCode];

    self.first_push = YES;
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CodepaySuccess) name:@"CodepaySuccess" object:nil];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];


}
#pragma mark - - - rightBarButtonItenAction 的点击事件
//- (void)rightBarButtonItenAction {
//    [self readImageFromAlbum];
//}
#pragma mark - - - 从相册中读取照片
- (void)readImageFromAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
    imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
    [self presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
}
#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:image];
    }];
}
/** 从相册中识别二维码, 并进行界面跳转 */
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果

    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        NSLog(@"------result:%@",scannedResult);
        
        if (self.first_push) {
            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
            jumpVC.jump_URL = scannedResult;
            [self.navigationController pushViewController:jumpVC animated:YES];
            
            self.first_push = NO;
        }
    }
}
#pragma mark - - - 二维码扫描
- (void)setupScanningQRCode {
    

    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
        //直接跳转到 【设置-隐私-照片】
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:errorStr
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                             
                                                             NSURL *url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                             [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
                                                         }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
    
        // 1、获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 2、创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        // 3、创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        // 4、设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        NSLog(@"-----------6");
        
        // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
        // 注：微信二维码的扫描范围是整个屏幕， 这里并没有做处理（可不用设置）
        output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
        
        // 5、 初始化链接对象（会话对象）
        self.session = [[AVCaptureSession alloc] init];
        // 高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        NSLog(@"-----------7");
        
        // 5.1 添加会话输入
        [_session addInput:input];
        NSLog(@"-----------7。1");
        
        // 5.2 添加会话输出
        [_session addOutput:output];
        NSLog(@"-----------7.2");
        
        // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
        // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        NSLog(@"-----------7.3");
        
        // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.layer.bounds;
        
        // 8、将图层插入当前视图
        [self.view.layer insertSublayer:_previewLayer atIndex:0];
        NSLog(@"-----------8");
        
        // 9、启动会话
        [_session startRunning];
        
    }
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 会频繁的扫描，调用代理方法
    
    // 0. 扫描成功之后的提示音
    [self playSoundEffect:@"sound.caf"];
    
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        NSLog(@"metadataObjects = %@", metadataObjects);
        
        if ([obj.stringValue hasPrefix:@"http"]) {
            // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
            jumpVC.jump_URL = obj.stringValue;
            NSLog(@"stringValue = = %@", obj.stringValue);
            [self.navigationController pushViewController:jumpVC animated:YES];
            
        } else {
            // 扫描结果为条形码
          
            NSLog(@"stringValue = = %@", obj.stringValue);
            self.backBlock(obj.stringValue);
            [self.navigationController popViewControllerAnimated:YES];
         
            
        }
    }
}

// 移除定时器
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;

}

#pragma mark - - - 扫描提示声
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */
- (void)playSoundEffect:(NSString *)name{
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    // 1.获得系统声音ID
    SystemSoundID soundID = 0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
}




@end
