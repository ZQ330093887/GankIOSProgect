//
//  ToastUtils.h
//  GankIOS
//
//  Created by 周琼 on 2018/11/16.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastUtils : NSObject

/********************************/

//显示菊花
+ (void)showToastAction;
//隐藏菊花
+ (void)hiddenToastAction;

/********************************/
/********************************/

//显示消息-->default center
+ (void)showToastAction:(NSString *)message;

/**
 * 显示消息Toast
 *
 * @param message       显示的信息
 * @param aLocationStr  显示的位置：@"top",@"center",@"bottom",传入字符串，默认center
 * @param aShowTime     显示的时间
 *
 */
+ (void)showToast:(NSString *)message location:(NSString *)aLocationStr showTime:(float)aShowTime;
/********************************/
/********************************/

//显示(带菊花的消息)-->default center
+ (void)showIndicatorToastAction:(NSString *)message;

/**
 * 显示(带菊花的消息)
 *
 * @param message       显示的信息
 * @param aLocationStr  显示的位置：@"top",@"center",@"bottom",传入字符串，默认center
 * @param aShowTime     显示的时间
 *
 */
+ (void)showIndicatorToast:(NSString *)message location:(NSString *)aLocationStr showTime:(float)aShowTime;

//隐藏(带菊花的消息)
+ (void)hiddenIndicatorToastAction;
/********************************/



@end

NS_ASSUME_NONNULL_END
