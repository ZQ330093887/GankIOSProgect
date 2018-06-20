//
//  BuildUpdateViewController.m
//  版本更新
//  GankIOS
//
//  Created by 周琼 on 2018/6/14.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "BuildUpdateViewController.h"
#import "BuildUpdateCell.h"
#import "BuildInfoVO.h"
#import "MJExtension.h"
#import "BaseVO.h"
#import "Masonry.h"

@interface BuildUpdateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *updateArray;//数据存储
@end
static NSString* const cellID = @"cellID";

@implementation BuildUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self hideTabBar];
    [self initView];
}

/*
 *初始化view
 */
- (void)initView{
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.scrollEnabled = NO;
    [self.mainTableView registerClass:[BuildUpdateCell class] forCellReuseIdentifier:cellID];
    //创建一个footerview
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 300)];
//    footView.backgroundColor = [UIColor greenColor];
    UIImageView *footImage = [[UIImageView alloc]init];
    footImage.image = [UIImage imageNamed:@"smile"];
    //创建一个脚Label
    UILabel * footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"感谢你对我的关注,\n希望这些更新能给你带来帮助";
    footerLabel.font =  Font_14;
    footerLabel.textColor= TintColor;
//    footerLabel.textAlignment  = NSTextAlignmentCenter;
    footerLabel.numberOfLines = 0;

    [footView addSubview:footImage];
    [footView addSubview:footerLabel];
    
//    footerLabel.backgroundColor = [UIColor redColor];
    
    [footImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView.mas_left).offset(90);
        make.right.equalTo(footerLabel.mas_left).offset(-10);
        make.centerY.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(footView);
        make.right.equalTo(footView.mas_right).offset(-30);
    }];
    
    self.mainTableView.tableFooterView = footView;
    [self.view addSubview:self.mainTableView];
    
    //从plist中读取数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"updateBuild" ofType:@"plist"];
    NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableArray *response = [BaseVO mj_objectWithKeyValues:updateDic].updateInfo;
    _updateArray = [NSMutableArray arrayWithArray:response];
    [self.mainTableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updateArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuildUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSUInteger index = indexPath.row;
    BuildInfoVO *info = (BuildInfoVO *)[self.updateArray objectAtIndex:index];
    cell.updateInfo =info;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(NSMutableArray *)bookArray{
    if (!_updateArray) {
        _updateArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _updateArray;
}

@end
