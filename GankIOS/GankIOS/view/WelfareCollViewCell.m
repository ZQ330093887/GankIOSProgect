//
//  WelfareCollViewCell.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/17.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "WelfareCollViewCell.h"
#import "BaseVO.h"
#import "BookVO.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface WelfareCollViewCell()
@property (nonatomic , strong) UIImageView * rightImageView;
@property (nonatomic , retain) UILabel * rightLable;

@end

@implementation WelfareCollViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUpAllChildView];
    }
    return self;
}

- (void) setUpAllChildView {
    
    //右侧列的视图

    
    //右侧列的图片视图
    //CGRect rightImageViewRect = CGRectMake(0, 0, rightViewRect.size.width, rightViewRect.size.height -30);
    _rightImageView = [[UIImageView alloc] init];
    //设置图片剧中
    _rightImageView.contentMode =  UIViewContentModeScaleAspectFill;
    //如果不希望超过frame的区域显示在屏幕上要设置
    _rightImageView.clipsToBounds  = YES;
    _rightImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_rightImageView];
    

    //右侧列的文字视图
    _rightLable = [[UILabel alloc] init];
    //设置文字剧中
    _rightLable.textAlignment  = NSTextAlignmentCenter;
    [self.contentView addSubview:_rightLable];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
        
    }];
    
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightImageView.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

-(void)setPicBook:(BookVO *)picBook{
    _picBook = picBook;
   
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:picBook.url] placeholderImage:[UIImage imageNamed:@"logo"]];
    _rightLable.text = picBook.desc;
    //    //_leftImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picBook.url]]];
    //    _rightImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picBook.url]]];
}
@end
