//
//  HandleCodeManager.h
//  CreateAndReadCode
//
//  Created by Dandy on 16/6/15.
//  Copyright © 2016年 Dandy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HandleCodeManager : NSObject

+ (instancetype)shareInstance;
/**
 *  生成二维码
 *
 *  @param info 输入的二维码信息
 *
 *  @return 生成的二维码的UIImage对象
 */
- (UIImage *)createCodeWithInfo:(NSString *)info;

/**
 *  扫描二维码/条形码
 *
 *  @param inView 图层添加到哪一个View中
 *  @param scanView 扫描区域的View
 */
- (void)startScanningCodeWithInView:(UIView *)inView  scanView:(UIView *)scanView block:(void(^)(NSString *result))block;

/**
 *  识别二维码图片
 *
 *  @param qrCodeImage 二维码的图片
 *
 *  @return 结果的数组
 */
- (NSString *)detectorQRCodeWithQRCodeImage:(UIImage *)qrCodeImage;

@end
