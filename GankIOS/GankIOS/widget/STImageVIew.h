//
//  STImageVIew.h
//  STPhotoBroeser
//
//  Created by StriEver on 16/3/15.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol STImageViewDelegate;
@interface STImageVIew : UIImageView
@property (nonatomic, weak)id<STImageViewDelegate>delegate;
- (void)resetView;
@end
@protocol STImageViewDelegate <NSObject>

- (void)stImageVIewSingleClick:(STImageVIew *)imageView;

@end