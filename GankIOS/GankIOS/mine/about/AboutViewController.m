//
//  AboutViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/10.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "AboutViewController.h"
#import "WYWebController.h"

#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#include "ShareMenuView.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self hideTabBar];
    [self setupSections];
    [self initTabView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = TintColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)setupSections{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"简书";
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item1.executeCode = ^{
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"https://www.jianshu.com/u/9681f3bbb8c2";
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"分享";
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^{
        ShareMenuView *mv = [[ShareMenuView alloc]init];
        [mv setShareButtonClickBlock:^(NSInteger index) {
            NSLog(@"第%ld",index);
        }];
        [mv show];
    };
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 0.01f;
    section1.itemArray = @[item1,item2];
    //************************************section2
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"作者GitHub 仓库地址";

    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 0.01f;
    section2.itemArray = @[item3];
    
    
    //************************************section3
    XBSettingItemModel *item6 = [[XBSettingItemModel alloc]init];
    item6.funcName = @"IOS 版";
    item6.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item6.executeCode = ^{
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"https://github.com/ZQ330093887/GankIOSProgect";
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    XBSettingItemModel *item7 = [[XBSettingItemModel alloc]init];
    item7.funcName = @"Flutter 版";
    item7.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item7.executeCode = ^{
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"https://github.com/ZQ330093887/GankFlutter";
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    XBSettingItemModel *item8 = [[XBSettingItemModel alloc]init];
    item8.funcName = @"Android 版";
    item8.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item8.executeCode = ^{
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"https://github.com/ZQ330093887/ConurbationsAndroid";
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    XBSettingItemModel *item9 = [[XBSettingItemModel alloc]init];
    item9.funcName = @"小程序 版";
    item9.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item9.executeCode = ^{
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"https://github.com/ZQ330093887/GankWX";
        [self.navigationController pushViewController:webVC animated:YES];
    };
   
    XBSettingSectionModel *section3 = [[XBSettingSectionModel alloc]init];
    section3.sectionHeaderHeight = 0.01f;
    section3.itemArray = @[item6,item7,item8,item9];
    
    self.sectionArray = @[section1,section2,section3];
}

- (void) initTabView{

    UIView *aboutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    //设置图片属性
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    logoImg.center = CGPointMake(aboutView.frame.size.width/2 , aboutView.frame.size.height/2 - logoImg.frame.size.height/4);
    
    //设置字体属性
    UILabel *aboutLab = [[UILabel alloc]initWithFrame:CGRectMake(0, aboutView.frame.size.height/2-logoImg.frame.size.height/3+logoImg.frame.size.height/2+10, SCREEN_WIDTH, 32)];
    aboutLab.text = @"干货集中营";
    aboutLab.font =  [UIFont systemFontOfSize:14];
    aboutLab.textColor= [UIColor blackColor];
    aboutLab.textAlignment  = NSTextAlignmentCenter;
    
    //设置字体属性
    UILabel *sunLab = [[UILabel alloc]initWithFrame:CGRectMake(0, aboutView.frame.size.height/2-logoImg.frame.size.height/3+logoImg.frame.size.height/2+37, SCREEN_WIDTH, 22)];
    sunLab.text = @"v1.1.0 (23)";
    sunLab.font =  [UIFont systemFontOfSize:12];
    sunLab.textColor= [UIColor grayColor];
    sunLab.textAlignment  = NSTextAlignmentCenter;

    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    
    [aboutView addSubview:logoImg];
    [aboutView addSubview:sunLab];
    [aboutView addSubview:aboutLab];
    self.mainTableView.tableHeaderView = aboutView;
    [self.view addSubview:self.mainTableView];
}

//返回表格分区数，默认返回1
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}
// 提供tableView中的分区中的数据的数量
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;//section头部高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    return line;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"setting";
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = itemModel;
    return cell;
}
/**
 *点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}
@end
