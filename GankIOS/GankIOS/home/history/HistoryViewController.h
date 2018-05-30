//
//  HistoryViewController.h
//  GankIOS
//
//  Created by 周琼 on 2018/5/28.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "BaseViewController.h"

//设置一个代理传递数据
@protocol SecondViewControllerDelegate <NSObject>

@optional
//代理方法
- (void)showViewGiveValue:(NSString *)text;
@end

@interface HistoryViewController : BaseViewController

@property (nonatomic,copy)NSString * text;
// 定义一个代理
@property (nonatomic,assign)id<SecondViewControllerDelegate> delegate;

@end
