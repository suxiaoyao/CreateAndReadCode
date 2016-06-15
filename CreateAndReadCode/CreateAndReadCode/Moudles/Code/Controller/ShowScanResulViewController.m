//
//  ShowScanResulViewController.m
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import "ShowScanResulViewController.h"

@interface ShowScanResulViewController ()

@property (weak, nonatomic) IBOutlet UITextView *showResultTextView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ShowScanResulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.showResultTextView.text = self.result;
    
}
- (IBAction)back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
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
