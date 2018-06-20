//
//  ShareMenuView.m
//  GankIOS
//
//  Created by 周琼 on 2018/6/20.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "ShareMenuView.h"
#import "Masonry.h"

#define AnimateDuration     0.4

int ShareMenuHeight = 160;
@implementation ShareMenuView


- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    //弹出菜单，添加半透明背景
    _backView = [UIButton buttonWithType:UIButtonTypeCustom];
    _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _backView.alpha = 0.3;
    _backView.backgroundColor = [UIColor blackColor];
    [_backView addTarget:self action:@selector(backViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ShareMenuHeight);
    self.backgroundColor = [UIColor whiteColor];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    NSMutableArray *shareTitleArray = [[NSMutableArray alloc]initWithObjects:@"QQ",@"QQ空间",@"微信",@"微博",@"复制链接", nil];
    NSMutableArray *shareIconArray = [[NSMutableArray alloc]initWithObjects:@"QQ",@"QQZone",@"wechat",@"weibo",@"copy", nil];
    
    
    for (int i = 0; i < shareIconArray.count; i ++) {
        
        UIButton *itemView = [UIButton buttonWithType:UIButtonTypeCustom];
        itemView.backgroundColor = [UIColor clearColor];
        itemView.tag = i;
        [itemView addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemView];
        
        //图标
        UIImageView *icon = [[UIImageView alloc]init];
        icon.backgroundColor = [UIColor clearColor];
        icon.image = [UIImage imageNamed:shareIconArray[i]];
        [itemView addSubview:icon];
        
        //标题
        UILabel *title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:13.0f];
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        title.text = shareTitleArray[i];
        [itemView addSubview:title];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@70);
            make.width.equalTo(@(SCREEN_WIDTH*1/4));
            make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH*(i%4)/4));
            make.top.equalTo(self.mas_top).offset(70*(i/4));
        }];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@40);
            make.top.equalTo(itemView.mas_top).offset(10);
            make.centerX.equalTo(itemView.mas_centerX);
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView.mas_centerX);
            make.top.equalTo(icon.mas_bottom).offset(5);
            make.bottom.equalTo(itemView.mas_bottom);
        }];
        
    }
}

- (void)backViewClicked:(id)sender{
    [self hide];
}

- (void)show{
    [[[UIApplication sharedApplication] keyWindow] addSubview:_backView];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:self aboveSubview:_backView];
    
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - ShareMenuHeight, SCREEN_WIDTH, ShareMenuHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)hide{
    [_backView removeFromSuperview];
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ShareMenuHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)share:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (self.shareButtonClickBlock) {
        self.shareButtonClickBlock(button.tag);
    }
    //这里是否点击之后隐藏面板，根据需求定
    [self hide];
}

@end
