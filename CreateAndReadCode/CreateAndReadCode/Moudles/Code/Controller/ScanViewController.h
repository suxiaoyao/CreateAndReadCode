//
//  ScanViewController.h
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanViewController;

@protocol ScanViewControllerDelegate <NSObject>

- (void)readCodeCompeleteWithCode:(NSString *)code;

@end

@interface ScanViewController : UIViewController

@property (nonatomic,weak) id<ScanViewControllerDelegate> delegate;

@end
