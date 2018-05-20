//
//  HomeCell.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/19.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "HomeCell.h"
#import "BaseVO.h"
#import "BookVO.h"

@interface HomeCell()
    @property (nonatomic , strong) UIImageView * imageV;//图片小点
    @property (nonatomic , retain) UILabel * timeLab;//时间
    @property (nonatomic , retain) UILabel * titleLab;//文章名称
    @property (nonatomic , retain) UILabel * whiteLab;//作者
@end


@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self zq_initSubviews];
    }
    return self;
}

- (void) zq_initSubviews {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 95)];
    int LEFT_CP = 30;
    _imageV =[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 12, 12)];
    _imageV.image = [UIImage imageNamed:@"end_dot"];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_CP, 4, view.frame.size.width-LEFT_CP, 30)];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_CP, 30, view.frame.size.width-LEFT_CP*2, 35)];
    _whiteLab = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_CP, 60, view.frame.size.width-LEFT_CP, 20)];
    
    _timeLab.textColor = [UIColor grayColor];
    _timeLab.font = [UIFont systemFontOfSize:14];
    
    _titleLab.font = [UIFont systemFontOfSize:16];
    
    _whiteLab.textColor = [UIColor lightGrayColor];
    _whiteLab.font = [UIFont systemFontOfSize:12];
    [view addSubview:_imageV];
    [view addSubview:_timeLab];
    [view addSubview:_whiteLab];
    [view addSubview:_titleLab];
    [self.contentView addSubview:view];
}

-(void)setHomeData:(BookVO *)homeData{
    _homeData = homeData;
    _timeLab.text = homeData.publishedAt;
    _titleLab.text = homeData.desc;
    _whiteLab.text = homeData.who;
}
@end
