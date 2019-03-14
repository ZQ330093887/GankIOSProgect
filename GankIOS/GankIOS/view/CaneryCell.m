//
//  CaneryCell.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/16.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "CaneryCell.h"
#import "BaseVO.h"
#import "BookVO.h"
#import "Masonry.h"
#import "CommonUtils.h"

@interface CaneryCell ()
@property (nonatomic , strong) UIImageView * imageV;
@property (nonatomic , retain) UILabel * timeLab;
@property (nonatomic , retain) UILabel * titleLab;
@property (nonatomic , retain) UILabel * whiteLab;

@end
@implementation CaneryCell

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
    
    _timeLab = [[UILabel alloc]init];
    _titleLab = [[UILabel alloc]init];
    _whiteLab = [[UILabel alloc]init];
    
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
    
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.updateExisting = YES;
        make.left.equalTo(self.contentView.mas_left).offset(LEFT_CP);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-LEFT_CP);
        make.bottom.equalTo(self.contentView.mas_top).offset(LEFT_CP);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.updateExisting = YES;
        make.left.equalTo(self.contentView.mas_left).offset(LEFT_CP);
        make.top.equalTo(self.contentView.mas_top).offset(LEFT_CP);
        make.right.equalTo(self.contentView.mas_right).offset(-LEFT_CP);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-LEFT_CP);
    }];
    
    [_whiteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.updateExisting = YES;
        make.left.equalTo(self.contentView.mas_left).offset(LEFT_CP);
        make.top.equalTo(_titleLab.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-LEFT_CP);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}


-(void) setBook:(BookVO *)book{
    _book = book;

    //格式化一些时间戳
    NSString * dataStr = [CommonUtils getDataString:book.publishedAt];
    if (dataStr !=nil) {
        //格式化成功的情况下将格式的d数据赋值
        _timeLab.text =dataStr;
    }else{
        //格式化失败的情况下将没有格式化的数据赋值
        _timeLab.text =book.publishedAt;
    }
    
    _titleLab.text = book.desc;
    _whiteLab.text = book.who;
    
    [self resetTitleHight];
   
}

-(void) resetTitleHight{
    //获得当前cell高度
    CGRect frame = [self frame];
    //设置label的最大行数
    _titleLab.numberOfLines = 2;
    
    CGSize labelSize = [_titleLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _titleLab.font}  context:nil].size;
    
    _titleLab.frame = CGRectMake(_titleLab.frame.origin.x, _titleLab.frame.origin.y, labelSize.width, labelSize.height);
    //计算出自适应的高度
    frame.size.height = labelSize.height+50;
}

@end
