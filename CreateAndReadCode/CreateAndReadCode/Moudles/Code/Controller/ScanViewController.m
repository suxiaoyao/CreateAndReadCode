//
//  ScanViewController.m
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HandleCodeManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice *device;

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic,assign) int num;
@property (nonatomic,assign) BOOL upOrdown;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) UIImageView *line;

@property (nonatomic,assign) BOOL torchIsOn;

@end

@implementation ScanViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //扫描的框
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_code_pick_bg"]];
    self.imageView.frame = CGRectMake((SCREEN_WIDTH - 280) / 2.0, (SCREEN_HEIGHT - 280) / 2.0, 280, 280);
    [self.view addSubview:self.imageView];
    
    //扫描的线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    line.image = [UIImage imageNamed:@"scan_code_line"];
    [self.imageView addSubview:line];
    self.line = line;
    
    //刷新线的位置
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(doAnimation) userInfo:nil repeats:YES];
    
    //打开／关闭 闪光灯的按钮
    UIButton *controlTorchBtn = [[UIButton alloc] init];
    controlTorchBtn.frame = CGRectMake((SCREEN_WIDTH / 2.0 - 40) / 2.0 + SCREEN_WIDTH / 2.0, ((SCREEN_HEIGHT - 280) / 2.0 - 40) / 2.0, 40, 40);
    [controlTorchBtn setBackgroundImage:[UIImage imageNamed:@"readCode_light_btn"] forState:UIControlStateNormal];
    [controlTorchBtn addTarget:self action:@selector(doTorchOn) forControlEvents:UIControlEventTouchUpInside];
    controlTorchBtn.alpha = 0.5;
    [self.view addSubview:controlTorchBtn];
    
    //取消按钮
    UIButton *cancleBtn = [[UIButton alloc] init];
    cancleBtn.frame = CGRectMake((SCREEN_WIDTH / 2.0 - 40) / 2.0, ((SCREEN_HEIGHT - 280) / 2.0 - 40) / 2.0, 40, 40);
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"readCode_back_btn"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(doCancle) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.alpha = 0.5;
    [self.view addSubview:cancleBtn];
    
    //提示信息
    UILabel *msgLable = [[UILabel alloc] init];
    msgLable.frame = CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height + 10, SCREEN_WIDTH, 20);
    msgLable.font = [UIFont systemFontOfSize:14];
    msgLable.textColor = [UIColor whiteColor];
    msgLable.textAlignment = NSTextAlignmentCenter;
    msgLable.text = @"将二维码/条形码放入框内";
    [self.view addSubview:msgLable];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[HandleCodeManager shareInstance] startScanningCodeWithInView:self.view scanView:self.imageView block:^(NSString *result) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.timer invalidate];
            //将数据传回去
            if ([self.delegate respondsToSelector:@selector(readCodeCompeleteWithCode:)])
            {
                [self.delegate readCodeCompeleteWithCode:result];
            }
        }];
    }];
    
}

#pragma mark -- Action

- (void)doAnimation
{
    if (_upOrdown == NO)
    {
        _num ++;
        _line.frame = CGRectMake(30, 10 + 2 *_num, 220, 2);
        if (2 * _num == 260)
        {
            _upOrdown = YES;
        }
    }else
    {
        _num --;
        _line.frame = CGRectMake(30, 10 + 2 * _num, 220, 2);
        if (_num == 0)
        {
            _upOrdown = NO;
        }
    }
}

- (void)doTorchOn
{
    BOOL on = !self.torchIsOn;
    if (self.device)
    {
        if ([self.device hasTorch] && [self.device hasFlash])
        {
            [self.device lockForConfiguration:nil];
            if (on)
            {
                [self.device setTorchMode:AVCaptureTorchModeOn];
                [self.device setFlashMode:AVCaptureFlashModeOn];
                self.torchIsOn = YES;
            } else
            {
                [self.device setTorchMode:AVCaptureTorchModeOff];
                [self.device setFlashMode:AVCaptureFlashModeOff];
                self.torchIsOn = NO;
            }
            [self.device unlockForConfiguration];
        }
    }
}

- (void)doCancle
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.timer invalidate];
        //将数据传回去
        if ([self.delegate respondsToSelector:@selector(readCodeCompeleteWithCode:)])
        {
            [self.delegate readCodeCompeleteWithCode:nil];
        }
    }];
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
