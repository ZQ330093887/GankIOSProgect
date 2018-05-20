//
//  HomeViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "HomeVO.h"
#import "BookVO.h"
#import "HomeBase.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>{
        NSInteger _page;
}

@property (nonatomic,strong) NSMutableArray *imag;//数据头部图片存储
@property (nonatomic,strong) NSMutableArray *categoryArray;//存储类别
@property (nonatomic,strong) NSMutableDictionary * dictionary;
@property (nonnull,strong) MBProgressHUD* proHUD;//加载进度条

//加载进度条
-(IBAction)showTextDialog:(NSString *)sender;
//获取当前年月日
-(NSString*)getDateToday;

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
    [self getNetworkData:YES];
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.

}

-(void) initView{
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getNetworkData:YES];
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HomeCell class] forCellReuseIdentifier:cellID];
        //头部view
        UIView *headerLable = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 520)];
         //头部福利图片view
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headerLable.frame.size.width, headerLable.frame.size.height)];
        //头部日期
        UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-95, 520-40, 74, 74)];
        dataView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"date_bg"]];
        
        _d = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 74, 30)];
        _d.font = [UIFont systemFontOfSize:24];
        _d.textAlignment  = NSTextAlignmentCenter;
        _m = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 74, 40)];
        _m.textAlignment  = NSTextAlignmentCenter;
        [dataView addSubview:_m];
        [dataView addSubview:_d];
        [headerLable addSubview:_imageView];
        [headerLable addSubview:dataView];
        _tableView.tableHeaderView = headerLable;
        
        //创建一个脚Label
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        _footerLabel.font =  [UIFont systemFontOfSize:12];
        _footerLabel.textColor= [UIColor grayColor];
        _footerLabel.textAlignment  = NSTextAlignmentCenter;
        _tableView.tableFooterView = _footerLabel;
    
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void) initBarItem{
    UIBarButtonItem *rightNew = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_new_normal"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    
    UIBarButtonItem *rightCalendar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_calendar"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    NSArray *arr = [[NSArray alloc]initWithObjects:rightCalendar, rightNew,nil];
    self.navigationItem.rightBarButtonItems = arr;
    //设置导航栏的背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //修改标题的字体大小和颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(NSString *) getMonthAndDay: (NSString*)timeStr :(NSInteger)type{

    NSString * time;
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(为了转换成功)
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [fmt dateFromString:timeStr];
    NSCalendar *caldendar = [NSCalendar currentCalendar];// 获取日历
    NSInteger month = [caldendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [caldendar component:NSCalendarUnitDay fromDate:date];
    NSArray *monthArr = [NSArray arrayWithArray:caldendar.shortMonthSymbols];  // 获取日历月数组

    if (type==0) {//返回月
        time =  monthArr[month - 1];
    }else if (type ==1){//返回日
        time =  [NSString stringWithFormat:@"%ld",day];;
    }
    return time;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSUInteger index = indexPath.row;
    
    for (NSString * key in self.dictionary) {
        if ([key isEqualToString:self.categoryArray[indexPath.section]]) {
            BookVO *book = (BookVO *)[self.dictionary[key] objectAtIndex:index];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.homeData =book;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
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
    footerLabel.textColor= [UIColor colorWithRed:212/255.0 green:158/255.0 blue:57/255.0 alpha:1];
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
-(void) getNetworkData:(BOOL)isRefresh{
    //设置url
    
    NSString * baseUrl = @"http://gank.io/api/day/";
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", baseUrl,[self getDateToday]];
    NSLog(@"我的URL:%@",urlStr);
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"这里可以在加载进度条中设置当前进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功数据=%@",responseObject);
        //成功获取数据之后停止刷新和加载
        [self endRefresh];

        HomeVO * homeData = [HomeBase mj_objectWithKeyValues:responseObject].results;
        self.categoryArray = [HomeBase mj_objectWithKeyValues:responseObject].category;
        if (self.categoryArray != nil && self.categoryArray.count>0) {
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
                }else if ([category isEqualToString:@"前端"]){
                    [self.dictionary setValue:homeData.html  forKey:category];
                }else if([category isEqualToString:@"福利"]){
                    for (BookVO *b in homeData.wetify) {
                        [_imageView sd_setImageWithURL:[NSURL URLWithString:b.url] placeholderImage:[UIImage imageNamed:@"logo"]];
                        self.m.text = [self getMonthAndDay:b.desc :0];
                        self.d.text = [self getMonthAndDay:b.desc :1];
                    }
                }
            }
        }else{
             _footerLabel.text = @"----感谢所有默认付出的编辑们，愿大家都有美好的一天----";
        }
        
        //刷新数据
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"失败了=%@",error);
        //[self.proHUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
    }];
}
//停止刷新
- (void) endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.proHUD hideAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//显示进度条
-(void)showTextDialog:(NSString *)sender{
    _proHUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:_proHUD];
    _proHUD.bezelView.color = [UIColor blackColor];
    _proHUD.bezelView.color = [_proHUD.bezelView.color colorWithAlphaComponent:1];
    //3,设置背景框的圆角值，默认是10
    _proHUD.bezelView.layer.cornerRadius = 10.0;
    //6，设置菊花颜色  只能设置菊花的颜色
    _proHUD.activityIndicatorColor = [UIColor whiteColor];
    _proHUD.margin = 15;
    _proHUD.label.text = sender;
    _proHUD.label.textColor = [UIColor whiteColor];
    //11，背景框的最小大小
    _proHUD.minSize = CGSizeMake(100, 100);
    //13,是否强制背景框宽高相等
    _proHUD.square = YES;
    //14,设置显示和隐藏动画类型  有三种动画效果，如下
    _proHUD.animationType = MBProgressHUDAnimationZoomOut; //HUD的整个view后退 然后逐渐的后退
    _proHUD.removeFromSuperViewOnHide = NO;
    [_proHUD showAnimated:YES];
}
-(void)selectRightAction:(id)sender{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了导航栏右按钮" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alter show];
    [self showTextDialog:@"更新中..."];
    [self getNetworkData:YES];
}

-(NSString *)getDateToday{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy/MM/dd"];//这里设置自己想要的时间
    NSString *dateStr = [forMatter stringFromDate:date];
    
    NSLog(@"当前年月日%@",dateStr);
    return dateStr;
}

@end
