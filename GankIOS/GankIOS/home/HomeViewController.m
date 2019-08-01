//
//  HomeViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "HomeViewController.h"
#import "CaneryCell.h"
#import "CommonUtils.h"
#import "HomeVO.h"
#import "BookVO.h"
#import "HomeBase.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "WMPhotoBrowser.h"
#import "WYWebController.h"
#import "HistoryViewController.h"
#import "PGCustomBannerView.h"
#import "NewPagedFlowView.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic,strong) NSMutableArray *imag;//数据头部图片存储
@property (nonatomic,strong) NSMutableArray *categoryArray;//存储类别
@property (nonatomic,strong) NSMutableDictionary * dictionary;

/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation HomeViewController
static NSString* const cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarItem];
    [self initView];
    //加载进度条
    [self showTextDialog:@"加载中..."];
    //加载数据
    [self getNetworkData:YES getDay:[CommonUtils getDataToday]];
//    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    UIColor *color = TintColor;
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = TintColor;
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

-(void) initView{
   
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[CaneryCell class] forCellReuseIdentifier:cellID];
    //头部view
    UIView *headerLable = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16)];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    
    #warning 假设产品需求左右卡片间距30,底部对齐
    pageFlowView.leftRightMargin = 30;
    pageFlowView.topBottomMargin = 0;
    
    pageFlowView.orginPageCount = self.imag.count;
    pageFlowView.isOpenAutoScroll = YES;
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, SCREEN_WIDTH, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView reloadData];
    [headerLable addSubview:pageFlowView];
    
    
    self.pageFlowView = pageFlowView;
    

    self.mainTableView.tableHeaderView = headerLable;
    
    //创建一个脚Label
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    _footerLabel.font =  [UIFont systemFontOfSize:12];
    _footerLabel.textColor= [UIColor grayColor];
    _footerLabel.textAlignment  = NSTextAlignmentCenter;
    self.mainTableView.tableFooterView = _footerLabel;
    [self.view addSubview:self.mainTableView];
}

-(void) initBarItem{
    UIBarButtonItem *rightNew = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_new_normal"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    
    UIBarButtonItem *rightCalendar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"new_calendar"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectCanendarAction:)];
    NSArray *arr = [[NSArray alloc]initWithObjects:rightCalendar, rightNew,nil];
    self.navigationItem.rightBarButtonItems = arr;
    //设置导航栏的背景
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //修改标题的字体大小和颜色
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(NSMutableArray *)categoryArray{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _categoryArray;
}

-(NSMutableDictionary *)dictionary{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dictionary;
}

-(NSMutableArray *)imag{
    if (!_imag) {
        _imag = [NSMutableArray arrayWithCapacity:0];
    }
    return _imag;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CaneryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSUInteger index = indexPath.row;
    
    for (NSString * key in self.dictionary) {
        if ([key isEqualToString:self.categoryArray[indexPath.section]]) {
            BookVO *book = (BookVO *)[self.dictionary[key] objectAtIndex:index];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.book =book;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

//返回表格分区数，默认返回1
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.categoryArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    NSString *category = self.categoryArray[section];
    if (![category isEqualToString:@"福利"]) {
        footerLabel.text = category;
    }
    
    footerLabel.font =  [UIFont systemFontOfSize:22];
    footerLabel.textColor= TintColor;
    footerLabel.textAlignment  = NSTextAlignmentCenter;
    return footerLabel;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     NSUInteger count = 0;
    for (NSString * key in self.dictionary) {
        if ([key isEqualToString:self.categoryArray[section]]) {
           NSArray *ar =  self.dictionary[key];
           count = ar.count;
        }
    }
    return count;
}

//加载数据
-(void) getNetworkData:(BOOL)isRefresh getDay:(NSString*) todayDate{
    //设置url
    
    NSString * baseUrl = @"http://gank.io/api/day/";
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", baseUrl,todayDate];
    NSString * todayUrl = @"http://gank.io/api/today";
    NSLog(@"我的URL:%@",urlStr);
    __weak typeof(self) WeakSelf = self;
    [super GetRequsetDataUrlString:isRefresh ? todayUrl: urlStr Parameters:nil];
    self.GetSuccess = ^(id responseObject) {
        //数据获取成功之后就跟新缓存
        NSData *mData= [NSJSONSerialization dataWithJSONObject:(NSDictionary *)responseObject options:NSJSONWritingPrettyPrinted error:nil];

        //成功获取数据之后停止刷新和加载
        [WeakSelf hideTextDialog];
        HomeVO *homeData = [HomeBase mj_objectWithKeyValues:responseObject].results;
        WeakSelf.categoryArray = [HomeBase mj_objectWithKeyValues:responseObject].category;
        
        if (self.categoryArray != nil && self.categoryArray.count >0) {
            //判断是否已经缓存过该数据，如果缓存过就不做任何操作如果没有则设置新缓存数据
            BOOL isDef = false;
            //读取缓存
            NSData *dataCache = [WeakSelf readLocalCacheDataWithKey:baseUrl];
            if (dataCache !=nil) {
                NSDictionary *jsonObject =[NSJSONSerialization JSONObjectWithData:dataCache options:NSJSONReadingMutableContainers error:nil];
                HomeVO *homeCache = [HomeBase mj_objectWithKeyValues:jsonObject].results;
                if (homeCache != nil) {
                    NSLog(@"开始*************");
                    isDef = [homeData.Android isEqual: homeCache.Android];
                }
                if (!isDef) {
                    [WeakSelf writeLocalCacheData:mData withKey:baseUrl];
                    NSLog(@"结束*************");
                }
            }else{
                [WeakSelf writeLocalCacheData:mData withKey:baseUrl];
            }
            //设置最新请求数据
            [WeakSelf setDataToView:homeData];
        }else{
            NSData *data = [WeakSelf readLocalCacheDataWithKey:baseUrl];
            if (data != nil) {
                NSDictionary *jsonObject =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"缓存数据=%@",jsonObject);
                HomeVO *homeData = [HomeBase mj_objectWithKeyValues:jsonObject].results;
                WeakSelf.categoryArray = [HomeBase mj_objectWithKeyValues:jsonObject].category;
                //设置缓存数据
                [WeakSelf setDataToView:homeData];
            }
            [WeakSelf showAllTextDialog:@"真的没有数据了"];
        }
        
        WeakSelf.footerLabel.text = @"----感谢所有默认付出的编辑们，愿大家都有美好的一天----";
        //刷新数据
        [WeakSelf.pageFlowView reloadData];
        [WeakSelf.mainTableView reloadData];
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//导航栏刷新点击事件
-(void)selectRightAction:(id)sender{
    [self showTextDialog:@"更新中..."];
    [self getNetworkData:YES getDay:[CommonUtils getDataToday]];
}
//导航栏日历点击事件
-(void)selectCanendarAction:(id)sender{
    [self pushViewConteroller];
}

// 实现协议里面的方法(返回值回调)
- (void)showViewGiveValue:(NSString *)text{
    [self getNetworkData:NO getDay:text];
}

//设置数据
- (void) setDataToView:(HomeVO *)homeData{
    //遍历数组按我规定的排序重新添加
    for (int j =0; j<self.categoryArray.count; j++) {
        //将福利提到最前面
        if ([self.categoryArray[j] isEqualToString:@"福利"]) {
            [self.categoryArray exchangeObjectAtIndex:j withObjectAtIndex:0];
        }
    }
    
    for (int j =0; j<self.categoryArray.count; j++) {
        //IOS 开发，所以IOS排第二
        if ([self.categoryArray[j] isEqualToString:@"iOS"]) {
            [self.categoryArray exchangeObjectAtIndex:j withObjectAtIndex:1];
        }
    }
    
    for (int j =0; j<self.categoryArray.count; j++) {
        //IOS 开发，所以IOS排第二
        if ([self.categoryArray[j] isEqualToString:@"Android"]) {
            [self.categoryArray exchangeObjectAtIndex:j withObjectAtIndex:2];
        }
    }
    
    for (NSString *category in self.categoryArray) {
        if ([category isEqualToString:@"iOS"]) {
            [self.dictionary setValue:homeData.iOS forKey:category];
        }else if ([category isEqualToString:@"Android"]){
            [self.dictionary setValue:homeData.Android forKey:category];
        }else if ([category isEqualToString:@"休息视频"]){
            [self.dictionary setValue:homeData.audio  forKey:category];
        }else if ([category isEqualToString:@"拓展资源"]){
            [self.dictionary setValue:homeData.resouse  forKey:category];
        }else if ([category isEqualToString:@"瞎推荐"]){
            [self.dictionary setValue:homeData.recommend forKey:category];
        }else if ([category isEqualToString:@"App"]){
            [self.dictionary setValue:homeData.App forKey:category];
        }else if ([category isEqualToString:@"前端"]){
            [self.dictionary setValue:homeData.html  forKey:category];
        }else if([category isEqualToString:@"福利"]){
            [self.imag addObjectsFromArray:homeData.wetify];
        }
    }
}

//item 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
    for (NSString * key in self.dictionary) {
        if ([key isEqualToString:self.categoryArray[indexPath.section]]) {
            BookVO *book = (BookVO *)[self.dictionary[key] objectAtIndex:indexPath.row];
            WYWebController *webVC = [WYWebController new];
            webVC.url = book.url;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

//头部右下方圆形白色日历点击事件
-(void)dataViewTop:(UITapGestureRecognizer *)gst{
    [self pushViewConteroller];
}

//跳转到日历界面
-(void) pushViewConteroller{
    HistoryViewController *hConteroller = [HistoryViewController new];
    // 将代理对象设置成SecondViewController
    hConteroller.delegate = self;
    hConteroller.mTitle = @"历史的车轮";
    [self.navigationController pushViewController:hConteroller animated:YES];
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    NSMutableArray *photoURLArray = [NSMutableArray array];
    
    for (BookVO *vo in self.imag) {
        [photoURLArray addObject:vo.url];
    }
    
    WMPhotoBrowser *browser = [WMPhotoBrowser new];
    browser.dataSource = photoURLArray;
    browser.downLoadNeeded = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
   
    NSLog(@"CustomViewController 滚动到了第%ld页",pageNumber);
}

#warning 假设产品需求左右中间页显示大小为 Width - 50, (Width - 50) * 9 / 16
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(SCREEN_WIDTH - 50, (SCREEN_WIDTH - 50) * 9 / 16);
}

#pragma mark --NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imag.count;
}


- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGCustomBannerView *bannerView = (PGCustomBannerView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGCustomBannerView alloc] init];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    BookVO *b =  self.imag[index];
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:b.url] placeholderImage:[UIImage imageNamed:@"logo"]];
    
//    bannerView.mainImageView.image = self.imag[index];
//    bannerView.indexLabel.text = [NSString stringWithFormat:@"第%ld张图",(long)index + 1];
    
    bannerView.indexLabel.hidden = YES;
    return bannerView;
}

#pragma mark --旋转屏幕改变newPageFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [coordinator animateAlongsideTransition:^(id context) {
            [self.pageFlowView reloadData];
        } completion:NULL];
    }
}

#pragma mark --滚动到指定的页数
- (void)gotoPage {
    
    //产生跳转的随机数
    int value = arc4random() % self.imag.count;
    NSLog(@"value~~%d",value);
    
    [self.pageFlowView scrollToPage:value];
}


@end
