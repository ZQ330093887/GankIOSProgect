//
//  PushGankViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/6/11.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "PushGankViewController.h"
#import "Masonry.h"

@interface PushGankViewController ()

@end

@implementation PushGankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self hideTabBar];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    _titleView = [[UIView alloc]init];
    //头部背景
    _headImage = [[UIImageView alloc]init];
    _headImage.image = [UIImage imageNamed:@"notification_bg"];
    [_titleView addSubview:_headImage];
    //头部title
    _titleLable = [[UILabel alloc]init];
    _titleLable.text = @"干货推送";
    _titleLable.font = [UIFont systemFontOfSize:21];
    //头部content
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.text = @"有新干货会第一时间推送给你～";
    _contentLabel.font = Font_14;
    _contentLabel.textColor = [UIColor grayColor];
    //是否推送开关
    _pushSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 50, 0, 0)];
    _pushSwitch.onTintColor = TintColor;
    _pushSwitch.on = YES;
    //添加事件监听
    [_pushSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    _textLable = [[UILabel alloc]init];
    _textLable.font = [UIFont systemFontOfSize:14];
    _textLable.text = @"干货推送是利用系统特性解决第三方干货集中营客户端无法拥有原生推送的方案，你可以在这里选择开启或者关闭。你的 iOS 设备可以根据你使用干货集中营的频率和时间智能的安排干货集中营来获取每日更新的干货，并显示在应用图标上。你需要确保以下设置均为正确状态：";
    CGSize titleSize = [_textLable.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:22] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 200)];
    //设置frame
    _textLable.frame = CGRectMake(20, 135, SCREEN_WIDTH-40, titleSize.height);
    _textLable.numberOfLines = 0;
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_textLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_textLable.text length])];
    [_textLable setAttributedText:attributedString];
    
    _nextLable = [[UILabel alloc]init];
    _nextLable.text = @"1. 【设置】-【干货集中营】-【通知】权限为允许状态；\n2. 【设置】-【干货集中营】-【后台应用刷新】权限为允许状态；\n3. 如果上述权限都为允许状态，开启干货推送，enjoy it ！";
    _nextLable.font = [UIFont systemFontOfSize:14];
    CGSize size = [_nextLable.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24] constrainedToSize:CGSizeMake(SCREEN_WIDTH-40, 200)];
    //设置frame
    _nextLable.frame = CGRectMake(20, _textLable.frame.size.height+110, SCREEN_WIDTH-40, size.height);
    _nextLable.numberOfLines = 0;
   
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_nextLable.text];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:8];
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [_nextLable.text length])];
    [_nextLable setAttributedText:attributed];
    
    
    [self.view addSubview:_titleView];
    [self.view addSubview:_titleLable];
    [self.view addSubview:_contentLabel];
    [self.view addSubview:_pushSwitch];
    [self.view addSubview:_textLable];
    [self.view addSubview:_nextLable];

    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_top).offset(130);
    }];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_top).offset(130);
    }];

    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-80);
        make.bottom.mas_equalTo(self.view.mas_top).offset(70);
    }];

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(40);
        make.top.mas_equalTo(_titleLable.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right).offset(-80);
        make.bottom.mas_equalTo(_titleLable.mas_bottom).offset(30);
    }];
    
    
}

//开关监听事件
- (void)switchAction:(UISwitch*)pushSwitch{
    //判断开关的状态
    if (pushSwitch.on) {
        NSLog(@"switch is on");
    } else {
        NSLog(@"switch is off");
    }

}

@end
