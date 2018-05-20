//
//  LoginViewController.m
//  登录界面
//
//  Created by 周琼 on 2018/5/12.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.view.backgroundColor =[UIColor whiteColor];
    // Do any additional setup after loading the view.
}


-(void) initView{
    /**********删除按钮*************/
    UIImage *img = [UIImage imageNamed:@"nav_close_black"];
    UIImageView *cancelView = [[UIImageView alloc]initWithImage:img];
    cancelView.frame = CGRectMake(22, 36, img.size.width, img.size.height);
    cancelView.userInteractionEnabled = YES;//默认值NO
    //初始化手势
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishController:)];
    [cancelView addGestureRecognizer:gr];
    
    /**********title***************/
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30, 140, self.view.frame.size.width, 30)];
    title.text = @"Github 账号登录";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:25];
    /***********用户名******************/
    UITextField * nameFiele = [[UITextField alloc]initWithFrame:CGRectMake(30, 210, self.view.frame.size.width-60, 55)];
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 70, 30)];
    nameLab.text = @"账号";
    nameFiele.placeholder = @"请输入用户名/邮箱地址";
    nameFiele.leftView = nameLab;
    nameFiele.leftViewMode = UITextFieldViewModeAlways;

    /************下划线*********************/
    UIView * nameLine = [[UIView alloc]initWithFrame:CGRectMake(0,nameFiele.frame.size.height-1,nameFiele.frame.size.width,1)];
    nameLine.backgroundColor = [UIColor colorWithRed: 240/255.0  green: 240/255.0 blue: 240/255.0 alpha: 1.0];
    //添加下划线
    [nameFiele addSubview:nameLine];
    /*****************密码******************/
    UITextField *passField = [[UITextField alloc]initWithFrame:CGRectMake(30, 210+nameFiele.frame.size.height, self.view.frame.size.width - 60, 55)];
    UILabel *pwLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 210+nameFiele.frame.size.height, 70, 30)];
    pwLab.text = @"密码";
    passField.placeholder = @"请输入密码";
    passField.leftView = pwLab;
    passField.leftViewMode = UITextFieldViewModeAlways;
    /************下划线*********************/
    UIView * pwLine = [[UIView alloc]initWithFrame:CGRectMake(0,passField.frame.size.height-1,passField.frame.size.width,1)];
    pwLine.backgroundColor = [UIColor colorWithRed: 240/255.0  green: 240/255.0 blue: 240/255.0 alpha: 1.0];
    //添加下划线
    [passField addSubview:pwLine];
    /*************登录按钮*******************/
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(30, 370, self.view.frame.size.width - 60, 50);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed: 212/255.0  green: 158/255.0 blue: 57/255.0 alpha: 0.5];
    loginButton.layer.cornerRadius = 5;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [self.view addSubview:loginButton];
    [self.view addSubview:nameFiele];
    [self.view addSubview:passField];
    [self.view addSubview:title];
    [self.view addSubview:cancelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) addAlertView{
}
/*
 *关闭当前界面
 */
- (void)finishController:(id) imageV{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
