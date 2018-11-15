//
//  FeedBackViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/11/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "FeedBackViewController.h"
#import "PlaceholderTextView.h"

#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface FeedBackViewController ()<UITextViewDelegate>
@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UILabel *stringlenghtLab;

@property (nonatomic, strong) UIButton * sendButton;
@end

@implementation FeedBackViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = TintColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    [self hideTabBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f];
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.stringlenghtLab];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.sendButton];
   
}


-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(20, SafeAreaTopHeight+20, SCREEN_WIDTH - 40, 180)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = TintColor;
        _textView.placeholder = @"请输入您的宝贵意见，我们会尽快处理!";
    }
    
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([@"\n" isEqualToString:text] == YES){
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    self.sendButton.userInteractionEnabled = YES;
    //实时显示字数
    self.stringlenghtLab.text = [NSString stringWithFormat:@"%ld/100",(long)textView.text.length];
    
    //字数限制
    if (textView.text.length >= 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    
    //取消按钮点击权限，并显示文字
    if (textView.text.length == 0) {
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.backgroundColor = TintColor;
    }
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 2.0f;
        _sendButton.frame = CGRectMake(40, CGRectGetMaxY(self.textView.frame)+50, SCREEN_WIDTH - 80, 40);
        _sendButton.backgroundColor = [UIColor lightGrayColor];
        _sendButton.userInteractionEnabled = NO;
        [_sendButton setTitle:@"提交" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UILabel *)stringlenghtLab{
    if (!_stringlenghtLab) {
        _stringlenghtLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, CGRectGetMaxY(self.textView.frame), SCREEN_WIDTH - 80, 40)];
        _stringlenghtLab.text = @"0/100";
        _stringlenghtLab.textColor = TintColor;
    }
    
    return _stringlenghtLab;
}

- (void)sendFeedBack{
    
    NSLog(@"=======%@",self.textView.text);
    
}

- (UIColor *)colorWithRGBHex:(UInt32)hex{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
