//
//  MineViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/10.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "MineViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "PushGankViewController.h"
#import "WYWebController.h"
#import "CategoryListViewController.h"
#import "CategoryWelfareViewController.h"
#import "SearchController.h"
#import "BuildUpdateViewController.h"
#import "ShareMenuView.h"
#import "Masonry.h"
#import "UserInfoHeaderView.h"
#import "FeedBackViewController.h"


#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"

#define XBMakeColorWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *apps;
@property(nonatomic,strong)NSArray *ts;
@property(nonatomic,strong) NSArray<NSString *> *pictures;
@property(nonatomic,strong) NSArray<NSString *> *titlePic;
@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/

@property (nonatomic,strong) UserInfoHeaderView * headerView;
@property (nonatomic,strong) UIButton * settingBtn;
@end

static NSString* const cellID = @"cellID";

@implementation MineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self setupSections];
    [self setUpSubViews];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self showTabBar];
}

-  (void)setUpSubViews{
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.settingBtn];
}

#pragma - mark setup
- (void)setupSections{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"GitHub登录";
    item1.executeCode = ^{
        LoginViewController *loginConteroller = [[LoginViewController alloc]init];
        [self.view.window.layer addAnimation:[self getTranstion] forKey:nil];
        [self presentViewController:loginConteroller animated:NO completion:nil];
    };
    item1.detailText = @"登录后可提交干货";
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"修改密码";
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 0.01f;
    section1.itemArray = @[item1,item2];
    
    //************************************section2
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"推送提醒";
    item3.accessoryType = XBSettingAccessoryTypeSwitch;

    item3.switchValueChanged = ^(BOOL isOn){
        NSLog(@"推送提醒开关状态===%@",isOn?@"open":@"close");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送提醒" message:isOn?@"已打开":@"已关闭" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    };
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"版本更新";
    item4.executeCode = ^{
        BuildUpdateViewController *updateBd = [[BuildUpdateViewController alloc]init];
        updateBd.mTitle = @"版本更新";
        [self.navigationController pushViewController:updateBd animated:YES];
    };
    item4.detailImage = [UIImage imageNamed:@"icon-new"];
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"意见反馈";
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item5.executeCode = ^{
        FeedBackViewController *feedBack = [[FeedBackViewController alloc]init];
        feedBack.mTitle = @"版本更新";
        [self.navigationController pushViewController:feedBack animated:YES];
    };
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 0.01f;
    section2.itemArray = @[item3,item4,item5];
    
    //************************************section3
    XBSettingItemModel *item6 = [[XBSettingItemModel alloc]init];
    item6.funcName = @"关于作者";
    item6.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item6.executeCode = ^{
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"https://www.jianshu.com/u/9681f3bbb8c2";
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    XBSettingItemModel *item7 = [[XBSettingItemModel alloc]init];
    item7.funcName = @"感谢编辑";
    item7.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item7.executeCode = ^{
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"http://gank.io";
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    XBSettingItemModel *item8 = [[XBSettingItemModel alloc]init];
    item8.funcName = @"干货推荐";
    item8.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item8.executeCode = ^{
        PushGankViewController *pg = [[PushGankViewController alloc]init];
        pg.mTitle = @"干货推荐";
        [self.navigationController pushViewController:pg animated:YES];
    };
    
    XBSettingItemModel *item9 = [[XBSettingItemModel alloc]init];
    item9.funcName = @"清除缓存";
    item9.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section3 = [[XBSettingSectionModel alloc]init];
    section3.sectionHeaderHeight = 0.01f;
    section3.itemArray = @[item6,item7,item8,item9];
    
    self.sectionArray = @[section1,section2,section3];
}


#pragma mark - ******************** delegate *********************
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat headH = - offsetY;
    if (headH <= 64 ) {
        headH = 64;
    }
    
    [self.headerView alphaWithHeight:headH orignHeight:kHeaderViewHeight];
}



//#pragma mark 设置表
- (void)setTableView{
    self.mainTableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
}

- (void) initView{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
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


- (UserInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[UserInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderViewHeight)];
        _headerView.checkUserInfomationBlock = ^{
            NSLog(@"点击了头像！！！");
        };
    }
    return _headerView;
}

- (UIButton *)settingBtn{
    
    if (!_settingBtn) {
        _settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 44, 20, 44, 44)];
        _settingBtn.imageView.contentMode = UIViewContentModeCenter;
        [_settingBtn setImage:[UIImage imageNamed:@"Setting"]  forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(toSet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

-(CATransition *) getTranstion{
    CATransition *animation =[[CATransition alloc]init];
    animation.duration = 0.5;
    //animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    return animation;
}

-(void) toSet{
    AboutViewController *pg = [[AboutViewController alloc]init];
    pg.mTitle = @"设置";
    [self.navigationController pushViewController:pg animated:YES];
}

@end
