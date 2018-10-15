//
//  HistoryViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/28.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "HistoryViewController.h"
#import "FSCalendar.h"
#import "FSCalendarExtensions.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"

@interface HistoryViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (weak, nonatomic) FSCalendar *calendar;

@property (weak, nonatomic) UILabel *eventLabel;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property(strong,nonatomic)NSMutableArray*dataArr;

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarItem];
    [self addLeftButton];
    [self hideTabBar];
    
    [self initCalendar];
    //加载进度条
    [self showTextDialog:@"加载中..."];
    [self getNetworkData];
    // Do any additional setup after loading the view.
}

//顶部导航栏
-(void) initBarItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_search"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    //设置导航栏的背景
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //修改标题的字体大小和颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = TintColor;
}

//初始化日历
-(void)initCalendar{
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    
    UILabel *subLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 100, 30)];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"有干货"];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"has_gank"];
    attch.bounds = CGRectMake(-2, 0, 10, 10);
    
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri insertAttributedString:string atIndex:0];
    
    subLab.attributedText = attri;

    subLab.textColor = [UIColor grayColor];
    subLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:subLab];
}

- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0,  SafeAreaTopHeight, self.view.frame.size.width, 450)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.allowsMultipleSelection = YES;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    calendar.appearance.weekdayTextColor = TintColor;
    calendar.appearance.headerTitleFont  = [UIFont systemFontOfSize:23];
    calendar.appearance.headerTitleColor = TintColor;
    calendar.appearance.headerDateFormat = @"yyyy MMMM";
    
    calendar.calendarWeekdayView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    calendar.calendarHeaderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    //设置选中数据的背景色
    calendar.appearance.selectionColor = TintColor;
    calendar.appearance.eventOffset = CGPointMake(0, -7);
    calendar.today = nil; // Hide the today circle
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    calendar.locale = locale;  // 设置周次是中文显示
//    calendar.headerHeight = 0.0f; // 当不显示头的时候设置
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.headerHeight = 100;
    calendar.weekdayHeight = 50;
    calendar.backgroundColor = [UIColor whiteColor];
    
}


//设置最小日期
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [self.dateFormatter dateFromString:@"2015-05-18"];
}
//最大
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:0 toDate:[NSDate date] options:-10];
}

//选中数据的点击事件
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    // 在页面跳转前将参数传出去
    if ([self.delegate respondsToSelector:@selector(showViewGiveValue:)]) {
        [self.delegate showViewGiveValue:[self.dateFormatter stringFromDate:date]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

//未选中数据的点击事件
#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    return NO;
}

//加载数据
-(void) getNetworkData{
    NSString * baseUrl = @"http://gank.io/api/day/history";
    
    __weak typeof(self) WeakSelf = self;
    [super GetRequsetDataUrlString:baseUrl Parameters:nil];
    self.GetSuccess = ^(id responseObject) {
        NSDictionary *dict = (NSDictionary*)responseObject;
        WeakSelf.dataArr = dict[@"results"];
        WeakSelf.dataArr = (NSMutableArray *)[[WeakSelf.dataArr reverseObjectEnumerator] allObjects];
        
        for (NSString* str in WeakSelf.dataArr) {
            [WeakSelf.calendar selectDate:[WeakSelf.dateFormatter dateFromString:str] scrollToDate:YES];
        }
        
        [WeakSelf.calendar reloadData];
        [WeakSelf hideTextDialog];
    };
}

@end
