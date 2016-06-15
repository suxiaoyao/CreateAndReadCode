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

@interface ViewController ()<CreateCodeViewControllerDelegate, ScanViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *readCodeButton;

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
