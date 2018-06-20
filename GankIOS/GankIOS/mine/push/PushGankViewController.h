//
//  PushGankViewController.h
//  GankIOS
//
//  Created by 周琼 on 2018/6/11.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PushGankViewController : BaseViewController


@property(nonatomic,retain) UILabel     *titleLable;//头部title
@property(nonatomic,retain) UILabel     *contentLabel;//头部content
@property(nonatomic,retain) UIImageView *headImage;//头部bg
@property(nonatomic,retain) UIView      *titleView;//头部view
@property(nonatomic,retain) UISwitch    *pushSwitch;//推送开关

@property(nonatomic,retain) UILabel     *textLable;//正文Lable
@property(nonatomic,retain) UILabel     *nextLable;//步骤Lable



@end
