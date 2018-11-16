//
//  ToastUtils.m
//  GankIOS
//
//  Created by 周琼 on 2018/11/16.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "ToastUtils.h"

@implementation ToastUtils

static UIView *toastView = nil;
+ (UIView *)currentToastView {
    @synchronized(self) {
        if (toastView == nil) {
            toastView = [[UIView alloc] init];
            toastView.backgroundColor = [UIColor darkGrayColor];
            toastView.layer.masksToBounds = YES;
            toastView.layer.cornerRadius = 5.0;
            toastView.alpha = 0;
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicatorView.tag = 10;
            indicatorView.hidesWhenStopped = YES;
            indicatorView.color = [UIColor whiteColor];
            [toastView addSubview:indicatorView];
        }
        return toastView;
    }
}

static UILabel *toastLabel = nil;
+ (UILabel *)currentToastLabel {
    @synchronized(self) {
        if (toastLabel == nil) {
            toastLabel = [[UILabel alloc] init];
            toastLabel.backgroundColor = [UIColor darkGrayColor];
            toastLabel.font = [UIFont systemFontOfSize:16];
            toastLabel.textColor = [UIColor whiteColor];
            toastLabel.numberOfLines = 0;
            toastLabel.textAlignment = NSTextAlignmentCenter;
            toastLabel.lineBreakMode = NSLineBreakByCharWrapping;
            toastLabel.layer.masksToBounds = YES;
            toastLabel.layer.cornerRadius = 5.0;
            toastLabel.alpha = 0;
        }
        return toastLabel;
    }
}

static UIView *toastViewLabel = nil;
+ (UIView *)currentToastViewLabel {
    @synchronized(self) {
        if (toastViewLabel == nil) {
            toastViewLabel = [[UIView alloc] init];
            toastViewLabel.backgroundColor = [UIColor darkGrayColor];
            toastViewLabel.layer.masksToBounds = YES;
            toastViewLabel.layer.cornerRadius = 5.0;
            toastViewLabel.alpha = 0;
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicatorView.tag = 10;
            indicatorView.hidesWhenStopped = YES;
            indicatorView.color = [UIColor whiteColor];
            [toastViewLabel addSubview:indicatorView];
            
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.tag = 11;
            aLabel.backgroundColor = toastViewLabel.backgroundColor;
            aLabel.font = [UIFont systemFontOfSize:16];
            aLabel.textColor = [UIColor whiteColor];
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.lineBreakMode = NSLineBreakByCharWrapping;
            aLabel.layer.masksToBounds = YES;
            aLabel.layer.cornerRadius = 5.0;
            aLabel.numberOfLines = 0;
            [toastViewLabel addSubview:aLabel];
        }
        return toastViewLabel;
    }
}

//显示菊花
+ (void)showToastAction
{
    if ([[NSThread currentThread] isMainThread]) {
        toastView = [self currentToastView];
        [toastView removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:toastView];
        
        CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat main_height = [[UIScreen mainScreen] bounds].size.height;
        
        UIActivityIndicatorView *indicatorView = [toastView viewWithTag:10];
        indicatorView.center = CGPointMake(70/2, 70/2);
        [indicatorView startAnimating];
        toastView.frame = CGRectMake((main_width-70)/2, (main_height-70)/2, 70, 70);
        toastView.alpha = 1;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToastAction];
        });
        return;
    }
}

//隐藏菊花
+ (void)hiddenToastAction
{
    if (toastView) {
        UIActivityIndicatorView *indicatorView = [toastView viewWithTag:10];
        [indicatorView stopAnimating];
        toastView.alpha = 0;
        [toastView removeFromSuperview];
    }
}

//默认显示消息-->center
+ (void)showToastAction:(NSString *)message
{
    [self showToast:message location:@"center" showTime:2.0];
}

//显示消息
+ (void)showToast:(NSString *)message location:(NSString *)aLocationStr showTime:(float)aShowTime
{
    if (!message) {
        message = @"";
    }
    if ([[NSThread currentThread] isMainThread]) {
        toastLabel = [self currentToastLabel];
        [toastLabel removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:toastLabel];
        
        CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat main_height = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat width = [self stringText:message font:16 isHeightFixed:YES fixedValue:40];
        CGFloat height = 0;
        if (width > main_width - 20) {
            width = main_width - 20;
            height = [self stringText:message font:16 isHeightFixed:NO fixedValue:width];
        }else{
            height = 40;
        }
        
        CGRect labFrame;
        if (aLocationStr && [aLocationStr isEqualToString:@"top"]) {
            labFrame = CGRectMake((main_width-width)/2, main_height*0.15, width, height);
        }else if (aLocationStr && [aLocationStr isEqualToString:@"bottom"]) {
            labFrame = CGRectMake((main_width-width)/2, main_height*0.85, width, height);
        }else{
            //default-->center
            labFrame = CGRectMake((main_width-width)/2, main_height*0.5, width, height);
        }
        toastLabel.frame = labFrame;
        toastLabel.text = message;
        toastLabel.alpha = 1;
        [UIView animateWithDuration:aShowTime animations:^{
            toastLabel.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToast:message location:aLocationStr showTime:aShowTime];
        });
        return;
    }
}

//显示(带菊花的消息)-->default center
+ (void)showIndicatorToastAction:(NSString *)message
{
    [self showIndicatorToast:message location:@"center" showTime:2.0];
}

//显示(带菊花的消息)
+ (void)showIndicatorToast:(NSString *)message location:(NSString *)aLocationStr showTime:(float)aShowTime
{
    if (!message) {
        message = @"";
    }
    if ([[NSThread currentThread] isMainThread]) {
        toastViewLabel = [self currentToastViewLabel];
        [toastViewLabel removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:toastViewLabel];
        
        CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat main_height = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat width = [self stringText:message font:16 isHeightFixed:YES fixedValue:40];
        CGFloat height = 0;
        if (width > main_width - 20) {
            width = main_width - 20;
            height = [self stringText:message font:16 isHeightFixed:NO fixedValue:width];
        }else{
            height = 40;
        }
        
        CGRect labFrame;
        if (aLocationStr && [aLocationStr isEqualToString:@"top"]) {
            labFrame = CGRectMake((main_width-width)/2, main_height*0.15, width, 60+height);
        }else if (aLocationStr && [aLocationStr isEqualToString:@"bottom"]) {
            labFrame = CGRectMake((main_width-width)/2, main_height*0.85, width, 60+height);
        }else{
            //default-->center
            labFrame = CGRectMake((main_width-width)/2, main_height*0.5, width, 60+height);
        }
        toastViewLabel.frame = labFrame;
        toastViewLabel.alpha = 1;
        
        UIActivityIndicatorView *indicatorView = [toastViewLabel viewWithTag:10];
        indicatorView.center = CGPointMake(width/2, 70/2);
        [indicatorView startAnimating];
        
        UILabel *aLabel = [toastViewLabel viewWithTag:11];
        aLabel.frame = CGRectMake(0, 60, width, height);
        aLabel.text = message;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showIndicatorToast:message location:aLocationStr showTime:aShowTime];
        });
        return;
    }
}

//隐藏(带菊花的消息)
+ (void)hiddenIndicatorToastAction
{
    if (toastViewLabel) {
        UIActivityIndicatorView *indicatorView = [toastViewLabel viewWithTag:10];
        [indicatorView stopAnimating];
        toastViewLabel.alpha = 0;
        [toastViewLabel removeFromSuperview];
    }
}


//根据字符串长度获取对应的宽度或者高度
+ (CGFloat)stringText:(NSString *)aText font:(CGFloat)aFont isHeightFixed:(BOOL)isHeightFixed fixedValue:(CGFloat)fixedValue
{
    CGSize size;
    if (isHeightFixed) {
        size = CGSizeMake(MAXFLOAT, fixedValue);
    } else {
        size = CGSizeMake(fixedValue, MAXFLOAT);
    }
    
    CGSize resultSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        //返回计算出的size
        resultSize = [aText boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:aFont]} context:nil].size;
    }
    
    if (isHeightFixed) {
        return resultSize.width + 20; //增加左右20间隔
    } else {
        return resultSize.height + 20; //增加上下20间隔
    }
}
@end
