//
//  BuildUpdateCell.h
//  GankIOS
//
//  Created by 周琼 on 2018/6/14.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BuildInfoVO;

@interface BuildUpdateCell : UITableViewCell

@property (nonatomic , strong) UIImageView * imageV;//图片小点
@property (nonatomic , strong) UIImageView * lineImage;//图片竖线
@property (nonatomic , retain) UILabel * timeLab;//时间
@property (nonatomic , retain) UILabel * titleLab;//版本号
@property (nonatomic , retain) UILabel * whiteLab;//更新内容


@property (nonatomic , strong) BuildInfoVO * updateInfo;//更新数据


@end
