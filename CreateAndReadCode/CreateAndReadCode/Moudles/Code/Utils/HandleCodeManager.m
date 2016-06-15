//
//  HandleCodeManager.m
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import "HandleCodeManager.h"
#import <AVFoundation/AVFoundation.h>

@interface HandleCodeManager ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic ,copy) void(^resultBlock)(NSString *result);

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation HandleCodeManager

#pragma mark --singleton

static HandleCodeManager *_instance;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark --create code

- (UIImage *)createCodeWithInfo:(NSString *)info {
    
    // 1.将内容生成二维码
    // 1.1.创建滤镜(name = "CIQRCodeGenerator")
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 1.1.1.恢复默认设置
    [filter setDefaults];
    
    // 1.2.2.设置生成的二维码的容错率
    // key = inputCorrectionLevel value = @"L/M/Q/H"
    [filter setValue:@"H" forKeyPath:@"inputCorrectionLevel"];
    
    // 2.设置输入的内容(KVC)
    // 注意:key = inputMessage, value必须是NSData类型
    NSData *inputData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:inputData forKeyPath:@"inputMessage"];
    
    // 3.获取输出的图片
    CIImage *outImage = [filter outputImage];
    
    // 4.获取高清图片
    UIImage *hdImage = [self getUIImageFromCIImage:outImage];
    
    // 5.判断是否有前景图片
    return hdImage;
}

- (UIImage *)getUIImageFromCIImage:(CIImage *)image {
    // 1.创建Transform
    CGAffineTransform transform = CGAffineTransformMakeScale(10, 10);
    
    // 2.放大图片
    image = [image imageByApplyingTransform:transform];
    
    return [UIImage imageWithCIImage:image];
}

#pragma mark - scann code

- (void)startScanningCodeWithInView:(UIView *)inView  scanView:(UIView *)scanView block:(void(^)(NSString *result))block {
    // 0.保存block
    self.resultBlock = block;
    
    // 1.创建输入
    // 1.1.定义错误
    NSError *error = nil;
    
    // 1.2.获取摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 1.3.创建输入
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error != nil) {
        return;
    }
    
    // 2.创建输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 3.创建捕捉会话
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:input];
    [self.session addOutput:output];
    
    // 4.设置输入的内容类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    // 5.添加预览图层(让用户看到扫描的界面)
    // 5.1.创建图层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    // 5.2.设置的layer的frame
    previewLayer.frame = inView.bounds;
    
    // 5.3.将图层添加到其它图层中
    [inView.layer insertSublayer:previewLayer below:scanView.layer];
    
    // 6.设置扫描区域
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat x = scanView.frame.origin.y / screenSize.height;
    CGFloat y = scanView.frame.origin.x / screenSize.width;
    CGFloat w = scanView.frame.size.height / screenSize.height;
    CGFloat h = scanView.frame.size.width / screenSize.width;
    output.rectOfInterest = CGRectMake(x, y, w, h);
    
    // 7.开始扫描
    [self.session startRunning];
}

#pragma mark - 实现AVCaptureMetadataOutput代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self.session stopRunning];
    
    // 2.将结果回调出去
    self.resultBlock(stringValue);
}

@end
