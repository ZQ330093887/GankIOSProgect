//
//  BuildUpdateCell.m
//  GankIOS
//
//  Created by 周琼 on 2018/6/14.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "BuildUpdateCell.h"
#import "BuildInfoVO.h"
#import "Masonry.h"

@implementation BuildUpdateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self zq_initSubviews];
    }
    return self;
}

- (void) zq_initSubviews {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 95)];
    int LEFT_CP = 30;
    //图标点
    _imageV =[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 12, 12)];
    _imageV.image = [UIImage imageNamed:@"end_dot"];
    //图标竖线
    _lineImage =[[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 1, 80)];
    _lineImage.image = [UIImage imageNamed:@"version_line"];
    
    _timeLab = [[UILabel alloc]init];
    _titleLab = [[UILabel alloc]init];
    _whiteLab = [[UILabel alloc]init];
    
    _timeLab.textColor = [UIColor grayColor];
    _timeLab.font = [UIFont systemFontOfSize:14];
    
    _titleLab.font = [UIFont systemFontOfSize:16];
    
    _whiteLab.font = [UIFont systemFontOfSize:12];
    _whiteLab.lineBreakMode = NSLineBreakByWordWrapping;
    _whiteLab.numberOfLines = 0;
    

    [view addSubview:_imageV];
    [view addSubview:_lineImage];
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

-(void)setUpdateInfo:(BuildInfoVO *)updateInfo{
    _updateInfo = updateInfo;
    _timeLab.text = updateInfo.versionTime;
    _titleLab.text = updateInfo.versionCode;
    _whiteLab.text = updateInfo.versionInfo;
}


@end
