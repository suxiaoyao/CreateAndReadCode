//
//  ShowCodeView.m
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import "ShowCodeView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ShowCodeView ()

@property (nonatomic, strong) UIImageView *codeImageView;

@end

@implementation ShowCodeView

#pragma mark --init

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [self addGestureRecognizer:singleTap];
        
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [self addGestureRecognizer:singleTap];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(30, (SCREEN_HEIGHT - (SCREEN_WIDTH - 30*2))/2, SCREEN_WIDTH - 30*2, SCREEN_WIDTH - 30*2)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    self.codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (backView.frame.size.height - (backView.frame.size.width - 30*2))/2, backView.frame.size.width - 30*2, backView.frame.size.width - 30*2)];
    [backView addSubview:self.codeImageView];
    
}

- (void)showWithImage:(UIImage *)image inView:(UIView *)view{
    if (self.superview) {
        [self removeFromSuperview];
    }
    self.codeImageView.image = image;
    [view addSubview:self];
}

- (void)singleTap {
    [self hide];
}

- (void)hide {
    self.codeImageView.image = nil;
    if (self.superview) {
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
