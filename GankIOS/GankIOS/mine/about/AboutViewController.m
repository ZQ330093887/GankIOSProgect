//
//  AboutViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/10.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@end
NSArray * aboutList;
@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self hideTabBar];
    [self initTabView];
    
}

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ){
         contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }else{
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) addLeftButton{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
}

- (void)selectRightAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initTabView{
    aboutList = @[@"关于作者",@"作者Github",@"致谢干货集中营",@"开源组件"];
    UIView *aboutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    //设置图片属性
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    logoImg.center = CGPointMake(aboutView.frame.size.width/2 , aboutView.frame.size.height/2 - logoImg.frame.size.height/4);
    UITableView *aboutTab = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    
    //设置字体属性
    UILabel *aboutLab = [[UILabel alloc]initWithFrame:CGRectMake(0, aboutView.frame.size.height/2-logoImg.frame.size.height/3+logoImg.frame.size.height/2+10, self.view.frame.size.width, 32)];
    aboutLab.text = @"干活集中营";
    aboutLab.font =  [UIFont systemFontOfSize:14];
    aboutLab.textColor= [UIColor blackColor];
    aboutLab.textAlignment  = NSTextAlignmentCenter;
    
    //设置字体属性
    UILabel *sunLab = [[UILabel alloc]initWithFrame:CGRectMake(0, aboutView.frame.size.height/2-logoImg.frame.size.height/3+logoImg.frame.size.height/2+37, self.view.frame.size.width, 22)];
    sunLab.text = @"v1.1.0 (23)";
    sunLab.font =  [UIFont systemFontOfSize:12];
    sunLab.textColor= [UIColor grayColor];
    sunLab.textAlignment  = NSTextAlignmentCenter;
    
    aboutTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    aboutTab.rowHeight = 50;
    aboutTab.delegate = self;
    aboutTab.dataSource = self;
    
    [aboutView addSubview:logoImg];
    [aboutView addSubview:sunLab];
    [aboutView addSubview:aboutLab];
    aboutTab.tableHeaderView = aboutView;
    [self.view addSubview:aboutTab];
}

//返回表格分区数，默认返回1
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
// 提供tableView中的分区中的数据的数量
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aboutList.count;
}
static const NSString* cellID = @"cellID";
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    // 如果取出的表格行为nil
    if (cell ==nil) {
        //创建一个UITableViewCell对象，并绑定到cellID
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSUInteger index = indexPath.row;
    cell.textLabel.text = [aboutList objectAtIndex:index];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
/**
 *点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger rowNo = indexPath.row;
    NSString *title = [aboutList objectAtIndex:rowNo];
    if ([title isEqual:@"关于作者"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.jianshu.com/u/9681f3bbb8c2"]];
    }else if ([title isEqual:@"作者Github"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ZQ330093887"]];
    }else if ([title isEqual:@"致谢干货集中营"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://gank.io"]];
    }else{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[aboutList objectAtIndex:rowNo]  delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
    //item 按下抬起的时候返回正常背景
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}
@end
