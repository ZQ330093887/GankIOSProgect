//
//  UIView+fm.h
//  GankIOS
//
//  Created by 周琼 on 2018/11/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SKOscillatoryAnimationToBigger,
    SKOscillatoryAnimationToSmaller,
} SKOscillatoryAnimationType;
@interface UIView (fm)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic, readonly) CGFloat screenX;
@property (nonatomic, readonly) CGFloat screenY;

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer
                                     type:(SKOscillatoryAnimationType)type;
@end

NS_ASSUME_NONNULL_END
