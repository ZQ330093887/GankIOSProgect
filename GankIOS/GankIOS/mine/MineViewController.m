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

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@end
NSArray* item1;
NSArray* item2;
NSArray* item3;
@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarItem];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTabBar {
    if (self.tabBarController.tabBar.hidden == NO){
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]){
         contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }else{
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    }
    self.tabBarController.tabBar.hidden = NO;
}

/**********导航部分***********/
-(void) initBarItem{
    //导航栏右边添加图片
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_search"] style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_add"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    //设置导航栏的背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //修改标题的字体大小和颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
/*************正文****************/
- (void) initView{
    //创建一个数组，存储需要显示的数据
    item1 = @[@"干货推荐",@"感谢编辑们"];
    item2 = @[@"关于",@"版本更新"];
    item3 = @[@"推荐给朋友",@"给干货集中营评分"];
    //创建一个UITabView对象
    UITableView* tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    
    //创建一个脚Label
    UILabel * footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    footerLabel.text = @"v1.1.0（build 23）";
    footerLabel.font =  [UIFont systemFontOfSize:12];
    footerLabel.textColor= [UIColor blackColor];
    footerLabel.textAlignment  = NSTextAlignmentCenter;
    
    //设置行cell高（默认44px）
    tableView.rowHeight = 48;
    //设置分割线颜色
    //tableView.separatorColor = [UIColor grayColor];
    //设置分割线风格
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * titleV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    titleV.backgroundColor = [UIColor whiteColor];
    //头部view添加点击事件
    UITapGestureRecognizer *gRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [titleV addGestureRecognizer:gRecognizer];
    UILabel *  _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 30)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"用 Github登录";
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:21];
    titleV.backgroundColor = [UIColor whiteColor];
    
    UILabel *  _titleContent = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 30)];
    _titleContent.textAlignment = NSTextAlignmentLeft;
    _titleContent.textColor = [UIColor grayColor];
    _titleContent.text = @"登录后可提交干货";
    _titleContent.numberOfLines = 0;
    _titleContent.font = [UIFont systemFontOfSize:14];
    
    //设置UITableView的页眉控件
    tableView.tableHeaderView = titleV;
    //设置UITableView的页脚控件
    tableView.tableFooterView = footerLabel;
    //设置数据源代理，必须实现协议UITableViewDataSource中的相关方法
    tableView.delegate = self;
    tableView.dataSource = self;
   
    [titleV addSubview:_titleContent];
    [titleV addSubview:_titleLabel];
    [tableView addSubview:titleV];
    [self.view addSubview:tableView];
}

//头部点击事件方法
-(void)tapAction:(id)tap{
    LoginViewController *loginConteroller = [[LoginViewController alloc]init];
   
    [self.view.window.layer addAnimation:[self getTranstion] forKey:nil];
    [self presentViewController:loginConteroller animated:NO completion:nil];
}

-(CATransition *) getTranstion{
    CATransition *animation =[[CATransition alloc]init];
    animation.duration = 0.5;
    //animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    return animation;
}

-(void)selectRightAction:(id)sender{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加功能正在开发中" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
}
//返回表格分区数，默认返回1
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
// 提供tableView中的分区中的数据的数量
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count;
    for (int i=0; i<3; i++) {
        if (i==0) {
           count = item1.count;
        }else if (i==1){
            count = item2.count;
        }else if (i==2){
            count = item3.count;
        }
    }
    return count;
}
// 为表格行定义一个静态字符串作为可重用标识符，在UITableView的cell缓存池当中所有的cell的标示符都是刚定义的cellID，因为重用时无所谓获取哪一个cell，只要是cell就可以
static const NSString* cellID = @"cellID";
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 根据cellID从可重用表格行的队列中取出可重用的一个表格行UITableViewCell对象
    UITableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    // 如果取出的表格行为nil
    if (tableViewCell ==nil) {
        //创建一个UITableViewCell对象，并绑定到cellID
        tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    // 将单元格的边框设置为圆角
    //    tableViewCell.layer.cornerRadius =12;
    //    tableViewCell.layer.masksToBounds = YES;
    //UITableView声明了一个NSIndexPath的类别，主要用 来标识当前cell的在tableView中的位置，该类别有section和row两个属性，
    //section标识当前cell处于第几个section中，row代表在该section中的第几行。
    // 从IndexPath参数获取当前行的行号
 
    NSUInteger rowNo = indexPath.row;
    NSUInteger section = indexPath.section;
    NSString * str = @"";
    if (section==0) {
        str = [item1 objectAtIndex:rowNo];
    }else if (section==1){
        str = [item2 objectAtIndex:rowNo];
    }else if (section==2){
         str = [item3 objectAtIndex:rowNo];
    }
    // 取出cityList中索引为rowNo的元素作为UITableViewCell的文本标题
    tableViewCell.textLabel.text = str;
    // 设置UITableViewCell附加按钮的样式
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleGray;
    return tableViewCell;
}
/**
 *点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger rowNo = indexPath.row;
    NSUInteger section = indexPath.section;
    NSString * str = @"";
    if (section==0) {
        str = [item1 objectAtIndex:rowNo];
    }else if (section==1){
        str = [item2 objectAtIndex:rowNo];
    }else if (section==2){
        str = [item3 objectAtIndex:rowNo];
    }
    //点击关于跳转
    if ([str isEqual:@"关于"]) {
        AboutViewController *about = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
    //item 按下抬起的时候返回正常背景
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
@end
