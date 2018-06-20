//
//  LoginViewController.m
//  登录界面
//
//  Created by 周琼 on 2018/5/12.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameFiele;
@property (strong, nonatomic) IBOutlet UITextField *passField;
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
    _nameFiele = [[UITextField alloc]initWithFrame:CGRectMake(30, 210, self.view.frame.size.width-60, 55)];

    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 70, 30)];
    nameLab.text = @"账号";
    _nameFiele.placeholder = @"请输入用户名/邮箱地址";
    _nameFiele.leftView = nameLab;
    _nameFiele.leftViewMode = UITextFieldViewModeAlways;

    /************下划线*********************/
    UIView * nameLine = [[UIView alloc]initWithFrame:CGRectMake(0,_nameFiele.frame.size.height-1,_nameFiele.frame.size.width,1)];
    nameLine.backgroundColor = LineColor;
    //添加下划线
    [_nameFiele addSubview:nameLine];
    /*****************密码******************/
    _passField = [[UITextField alloc]initWithFrame:CGRectMake(30, 210+_nameFiele.frame.size.height, self.view.frame.size.width - 60, 55)];
    UILabel *pwLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 210+_nameFiele.frame.size.height, 70, 30)];
    pwLab.text = @"密码";
    _passField.placeholder = @"请输入密码";
    _passField.leftView = pwLab;
    _passField.leftViewMode = UITextFieldViewModeAlways;
    /************下划线*********************/
    UIView * pwLine = [[UIView alloc]initWithFrame:CGRectMake(0,_passField.frame.size.height-1,_passField.frame.size.width,1)];
    pwLine.backgroundColor = LineColor;
    //添加下划线
    [_passField addSubview:pwLine];
    /*************登录按钮*******************/
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(30, 370, self.view.frame.size.width - 60, 50);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = TintColor;
    loginButton.layer.cornerRadius = 5;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:loginButton];
    [self.view addSubview:_nameFiele];
    [self.view addSubview:_passField];
    [self.view addSubview:title];
    [self.view addSubview:cancelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录按钮点击事件
-(void)clickButton:(UIButton *) button{
    NSString *username = self.nameFiele.text;
    NSString *password = self.passField.text;
    NSLog(@"name:%@----pwd:%@",username,password);
    if ([username isEqualToString:@""]) {
        [self showAllTextDialog:@"用户名不能为空"];
        return;
    }
    
    if ([password isEqualToString:@""]) {
        [self showAllTextDialog:@"密码不能为空"];
        return;
    }
    
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password
                                 };
    
    [self showTextDialog:@""];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString: @"https://api.github.com"]];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"X-Accept"];
//    [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    [manager GET:@"/user" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前进去");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功数据=%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了=%@",error);
        [self hideTextDialog];
       [self showAllTextDialog:@"登录失败，稍后重试"];
    }];
}

/*
 *关闭当前界面
 */
- (void)finishController:(id) imageV{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
