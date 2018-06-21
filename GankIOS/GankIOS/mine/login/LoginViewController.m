//
//  LoginViewController.m
//  登录界面
//
//  Created by 周琼 on 2018/5/12.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "Masonry.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameFiele;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
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
    UILabel *title = [[UILabel alloc]init];
    title.text = @"Github 账号登录";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:title];
    /***********用户名******************/
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 70, 30)];
    nameLab.text = @"账号";
    _nameFiele = [[UITextField alloc]init];
    _nameFiele.placeholder = @"请输入用户名/邮箱地址";
    _nameFiele.leftView = nameLab;
    _nameFiele.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_nameFiele];
    /************下划线*********************/
    UIView * nameLine = [[UIView alloc]init];
    nameLine.backgroundColor = LineColor;
    //添加下划线
    [_nameFiele addSubview:nameLine];
    /*****************密码******************/
    UILabel *pwLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 210+_nameFiele.frame.size.height, 70, 30)];
    pwLab.text = @"密码";
    _passField = [[UITextField alloc]init];
    _passField.placeholder = @"请输入密码";
    _passField.leftView = pwLab;
    _passField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_passField];
    /************下划线*********************/
    UIView * pwLine = [[UIView alloc]init];
    pwLine.backgroundColor = LineColor;
    //添加下划线
    [_passField addSubview:pwLine];
    /*************登录按钮*******************/
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = TintColor;
    loginButton.layer.cornerRadius = 5;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:loginButton];
    
    [self.view addSubview:cancelView];
    int FLOCT_X_Y = 30;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(FLOCT_X_Y);
        make.right.mas_equalTo(self.view).offset(-FLOCT_X_Y);
        make.top.mas_equalTo(self.view.mas_top).offset(130);
        make.bottom.mas_equalTo(self.view.mas_top).offset(160);
    }];

    [_nameFiele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(FLOCT_X_Y);
        make.right.mas_equalTo(self.view).offset(-FLOCT_X_Y);
        make.top.mas_equalTo(title.mas_bottom).offset(50);
        make.bottom.mas_equalTo(title.mas_bottom).offset(105);
    }];
    
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(FLOCT_X_Y);
        make.right.mas_equalTo(self.view).offset(-FLOCT_X_Y);
        make.top.mas_equalTo(_nameFiele.mas_bottom);
        make.bottom.mas_equalTo(_nameFiele.mas_bottom).offset(1);
    }];
    
    [_passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(FLOCT_X_Y);
        make.right.mas_equalTo(self.view).offset(-FLOCT_X_Y);
        make.top.mas_equalTo(_nameFiele.mas_bottom);
        make.bottom.mas_equalTo(_nameFiele.mas_bottom).offset(55);
    }];
    
    [pwLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(FLOCT_X_Y);
        make.right.mas_equalTo(self.view).offset(-FLOCT_X_Y);
        make.top.mas_equalTo(_passField.mas_bottom);
        make.bottom.mas_equalTo(_passField.mas_bottom).offset(1);
    }];

    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(FLOCT_X_Y);
        make.right.mas_equalTo(self.view).offset(-FLOCT_X_Y);
        make.top.mas_equalTo(_passField.mas_bottom).offset(FLOCT_X_Y*2);
        make.bottom.mas_equalTo(_passField.mas_bottom).offset(110);
    }];

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
