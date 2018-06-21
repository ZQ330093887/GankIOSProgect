//
//  AboutViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/10.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "AboutViewController.h"
#import "WYWebController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@end
NSArray * aboutList;
static NSString* const cellID = @"cellID";
@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self hideTabBar];
    [self initTabView];
}

- (void) initTabView{
    aboutList = @[@"关于作者",@"作者Github",@"致谢干货集中营",@"Gank 的 github仓库"];
    UIView *aboutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    //设置图片属性
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    logoImg.center = CGPointMake(aboutView.frame.size.width/2 , aboutView.frame.size.height/2 - logoImg.frame.size.height/4);
    UITableView *aboutTab = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    
    //设置字体属性
    UILabel *aboutLab = [[UILabel alloc]initWithFrame:CGRectMake(0, aboutView.frame.size.height/2-logoImg.frame.size.height/3+logoImg.frame.size.height/2+10, SCREEN_WIDTH, 32)];
    aboutLab.text = @"干活集中营";
    aboutLab.font =  [UIFont systemFontOfSize:14];
    aboutLab.textColor= [UIColor blackColor];
    aboutLab.textAlignment  = NSTextAlignmentCenter;
    
    //设置字体属性
    UILabel *sunLab = [[UILabel alloc]initWithFrame:CGRectMake(0, aboutView.frame.size.height/2-logoImg.frame.size.height/3+logoImg.frame.size.height/2+37, SCREEN_WIDTH, 22)];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    // 如果取出的表格行为nil
    if (cell ==nil) {
        //创建一个UITableViewCell对象，并绑定到cellID
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    NSUInteger index = indexPath.row;
    cell.textLabel.text = [aboutList objectAtIndex:index];
    return cell;
}
/**
 *点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger rowNo = indexPath.row;
    NSString *title = [aboutList objectAtIndex:rowNo];
    WYWebController *webVC = [WYWebController new];
    if ([title isEqualToString:@"关于作者"]) {
        webVC.url = @"https://www.jianshu.com/u/9681f3bbb8c2";
    }else if ([title isEqualToString:@"作者Github"]){
        webVC.url = @"https://github.com/ZQ330093887";
    }else if ([title isEqualToString:@"致谢干货集中营"]){
        webVC.url = @"http://gank.io";
    }else{
        webVC.url = @"https://github.com/ZQ330093887/GankIOSProgect";
    }
    [self.navigationController pushViewController:webVC animated:YES];
    //item 按下抬起的时候返回正常背景
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}
@end
