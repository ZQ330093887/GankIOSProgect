//
//  PGIndexBannerSubiew.h
//  GankIOS
//
//  Created by 周琼 on 2019/7/8.
//  Copyright © 2019年 周琼. All rights reserved.
//

/******************************
 
 可以根据自己的需要继承PGIndexBannerSubiew
 
 ******************************/

#import <UIKit/UIKit.h>

@interface PGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, copy) void (^didSelectCellBlock)(NSInteger tag, PGIndexBannerSubiew *cell);

/**
 设置子控件frame,继承后要重写

 @param superViewBounds <#superViewBounds description#>
 */
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;

@end
