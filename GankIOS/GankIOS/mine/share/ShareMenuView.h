//
//  ShareMenuView.h
//  GankIOS
//
//  Created by 周琼 on 2018/6/20.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareMenuView : UIView
{
    UIButton *_backView;
}

- (void)show;
- (void)hide;

@property(nonatomic,copy)void (^ shareButtonClickBlock)(NSInteger index);
@end
