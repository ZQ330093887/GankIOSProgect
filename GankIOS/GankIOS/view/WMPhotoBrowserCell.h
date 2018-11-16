//
//  WMPhotoBrowserCell.h
//  GankIOS
//
//  Created by 周琼 on 2018/11/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WMFrame.h"

@interface WMPhotoBrowserCell : UICollectionViewCell
@property (nonatomic, copy)NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, retain)id model;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^longPressGestureBlock)(WMPhotoBrowserCell *cell);

@end
