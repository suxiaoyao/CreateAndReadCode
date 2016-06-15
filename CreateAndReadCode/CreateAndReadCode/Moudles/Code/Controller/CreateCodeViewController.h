//
//  CreateCodeViewController.h
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateCodeViewControllerDelegate <NSObject>

@optional
- (void)completeCreateCodeWithInfo:(NSString *)codeInfo;

@end

@interface CreateCodeViewController : UIViewController

@property (nonatomic, weak) id<CreateCodeViewControllerDelegate> delegate;

@end
