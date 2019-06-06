//
//  MusicImageView.m
//  GankIOS
//
//  Created by 周琼 on 2019/5/21.
//  Copyright © 2019年 周琼. All rights reserved.
//

#import "MusicImageView.h"

@implementation MusicImageView

//开始旋转
-(void) startRotating{
    
    CABasicAnimation * rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    //旋转一周
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    //旋转时间
    rotateAnimation.duration = 20.0;
    //重复次数，这里用最大次数
    rotateAnimation.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:rotateAnimation forKey:nil];
}

//暂停旋转
-(void) stopRotating{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;                                          // 停止旋转
    self.layer.timeOffset = pausedTime;                              // 保存时间，恢复旋转需要用到
}

//恢复旋转
-(void) resumeRotate{
    if (self.layer.timeOffset == 0) {
        [self startRotating];
        return;
    }
    
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1.0;                                         // 开始旋转
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;                                             // 恢复时间
    self.layer.beginTime = timeSincePause;                          // 从暂停的时间点开始旋转
}

@end
