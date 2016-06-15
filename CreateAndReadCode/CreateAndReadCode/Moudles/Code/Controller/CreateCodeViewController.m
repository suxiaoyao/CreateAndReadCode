//
//  CreateCodeViewController.m
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import "CreateCodeViewController.h"

@interface CreateCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputCodeInfoTextField;

@property (weak, nonatomic) IBOutlet UIButton *completeCreateButton;

@end

@implementation CreateCodeViewController

#pragma mark --life cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark --action
- (IBAction)completeCreateCode:(UIButton *)sender {
    
    if (self.inputCodeInfoTextField.text.length <= 0) {
        NSLog(@"请输入二维码的信息");
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(completeCreateCodeWithInfo:)]) {
        [self.delegate completeCreateCodeWithInfo:self.inputCodeInfoTextField.text];
    }
    
    NSLog(@"点击-->完成创建");
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
