//
//  ViewController.m
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import "ViewController.h"
#import "CreateCodeViewController.h"
#import "HandleCodeManager.h"
#import "ShowCodeView.h"
#import "ScanViewController.h"
#import "ShowScanResulViewController.h"

@interface ViewController ()<CreateCodeViewControllerDelegate, ScanViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *readCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *readFromAlbumButton;


@property (nonatomic, strong) ShowCodeView *showCodeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

#pragma mark --getter showCodeView
- (ShowCodeView *)showCodeView {
    if (!_showCodeView) {
        _showCodeView = [[ShowCodeView alloc] init];
    }
    return _showCodeView;
}

#pragma mark --action
- (IBAction)startCreateCode:(UIButton *)sender {
    
    NSLog(@"点击-->创建二维码");
    
    CreateCodeViewController *createCodeVC = [[CreateCodeViewController alloc] init];
    createCodeVC.delegate = self;
    [self presentViewController:createCodeVC animated:YES completion:^{
        
    }];
    
}

- (IBAction)startReadCode:(UIButton *)sender {
    
    NSLog(@"点击-->读取二维码");
    
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.delegate = self;
    [self presentViewController:scanVC animated:YES completion:^{
        
    }];
    
}

- (IBAction)startOpenAlbum:(UIButton *)sender {
    
    // 1.判断点的哪一个按钮
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 2.判断数据源是否可用
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSLog(@"相册不可用");
        return;
    }
    
    // 3.创建照片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    // 4.设置数据源
    ipc.sourceType = sourceType;
    
    // 5.设置代理
    ipc.delegate = self;
    
    // 6.弹出控制器
    [self presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - 实现UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 1.获取选中的图片
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    
    // 2.退出控制器
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    //读取到二维码/条形码信息
    NSString *codeString = [[HandleCodeManager shareInstance] detectorQRCodeWithQRCodeImage:selectedImage];
    if (codeString.length > 0) {
        ShowScanResulViewController *showScanResultVC = [[ShowScanResulViewController alloc] init];
        showScanResultVC.result = codeString;
        [self presentViewController:showScanResultVC animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --CreateCodeViewControllerDelegate
- (void)completeCreateCodeWithInfo:(NSString *)codeInfo {
    
    UIImage *codeImage = [[HandleCodeManager shareInstance] createCodeWithInfo:codeInfo];
    [self.showCodeView showWithImage:codeImage inView:self.view];
}

#pragma mark --ScanViewControllerDelegate
- (void)readCodeCompeleteWithCode:(NSString *)code {
    if (code && code.length > 0) {
        ShowScanResulViewController *showScanResultVC = [[ShowScanResulViewController alloc] init];
        showScanResultVC.result = code;
        [self presentViewController:showScanResultVC animated:YES completion:^{
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
