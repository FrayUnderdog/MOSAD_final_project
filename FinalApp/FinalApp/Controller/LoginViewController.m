//
//  LoginViewController.m
//  Setting
//
//  Created by Hsy on 2019/12/26.
//  Copyright © 2019 Hsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "SignupViewController.h"
@interface LoginViewController() <UITextFieldDelegate>
@property (nonatomic, strong) UITextField* username;
@property (nonatomic, strong) UITextField* password;
@property (nonatomic, strong) UILabel* user;
@property (nonatomic, strong) UILabel* pass;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UIButton* button2;
@property (nonatomic, strong) SignupViewController * singnUp;
@end


@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationItem setTitle:@"Login"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:97.0/255 green:127.0/255 blue:222.0/255 alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    float itemSize = 90;
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-itemSize/2, 95, itemSize, itemSize)];
    [img setImage:[UIImage imageNamed:@"unLogin.png"]];
    [img.layer setMasksToBounds:YES];
    [img.layer setCornerRadius:20];
    
    _user = [[UILabel alloc]initWithFrame:CGRectMake(30, 200, 100, 25)];
    [_user setText:@"Username"];
    
    _pass = [[UILabel alloc]initWithFrame:CGRectMake(30, 300, 100, 25)];
    [_pass setText:@"Password"];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:img];
    [self.view addSubview:self.username];
    [self.view addSubview:self.password];
    [self.view addSubview:_user];
    [self.view addSubview:_pass];
    [self.view addSubview:self.button];
    [self.view addSubview:self.button2];
}



-(UITextField*)username{
    if (_username == nil) {
        float len = self.view.frame.size.width - 50;
        _username = [[UITextField alloc] initWithFrame:CGRectMake(25, 230, len, 50)];
        _username.font = [UIFont systemFontOfSize:20];
        _username.placeholder = @"Username";
        _username.borderStyle = UITextBorderStyleRoundedRect;
        _username.delegate =self;
        [_username resignFirstResponder];
    }
    return _username;
}

-(UITextField*)password{
    if (_password == nil) {
        float len = self.view.frame.size.width - 50;
        _password = [[UITextField alloc] initWithFrame:CGRectMake(25, 330, len, 50)];
        _password.font = [UIFont systemFontOfSize:20];
        _password.placeholder = @"Password";
        _password.borderStyle = UITextBorderStyleRoundedRect;
        _password.secureTextEntry=YES;
        _password.delegate = self;
        [_password resignFirstResponder];
    }
    return _password;
}

-(UIButton*)button {
    if (_button == nil) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(50, self.password.frame.origin.y + 80, self.view.frame.size.width-100, 50)];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 25;
        [_button setBackgroundColor:[UIColor blueColor]];
        [_button setTitle:@"Login" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton*)button2 {
    if (_button2 == nil) {
        _button2 = [[UIButton alloc] initWithFrame:CGRectMake(50, self.button.frame.origin.y + 60, self.view.frame.size.width-100, 25)];
        _button2.layer.masksToBounds = YES;
        _button2.layer.cornerRadius = 25;
        [_button2 setBackgroundColor:[UIColor clearColor]];
//        [_button2 setTitle:@"Register" forState:UIControlStateNormal];
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"Sign up"];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]  range:NSMakeRange(0,[tncString length])];
        
        //设置下划线颜色
        [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor blueColor] range:(NSRange){0,[tncString length]}];
        [_button2 setAttributedTitle:tncString forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

-(void)login:(UIButton*)button{
    self.activity = @"";
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    NSURLSessionConfiguration * defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:@"http://172.18.176.201:3000/login"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    // 设置请求体为JSON
    
    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.username.text,@"name",self.password.text,@"pwd", nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse * response, NSError * error){
        if(error == nil) {
            self.activity = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"ssss %@",self.activity);
            
        }
        dispatch_group_leave(group);
    }];
    [dataTask resume];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if([self.activity isEqualToString:@"failed"]){
            [self shakeAnimationForView:self.button];
        }
        else {
            self.name = self.username.text;
            self.pwd = self.password.text;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    });
    
}

-(void)registerClick:(UIButton*)btn{
//    [self.navigationController popViewControllerAnimated:YES];
    self.singnUp = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:self.singnUp animated:YES];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        CGRect rect = CGRectMake(0, 64, width, height);
        self.view.frame = rect;
    }];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        float width = self.view.frame.size.width;
        float hight = self.view.frame.size.height;
        
        CGRect rect = CGRectMake(0, 64, width, hight);
        self.view.frame = rect;
    }];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect textFieldFrame = textField.frame;
    //当前输入框的Y
    CGFloat textField_Y = textFieldFrame.origin.y;
    //当前输入框的高度
    CGFloat textFieldHight = textFieldFrame.size.height;
    //屏幕高度
    CGFloat screenHight = self.view.frame.size.height;
    //键盘高度
    CGFloat keyBordHight = 216;
    //键盘tabbar高度
    CGFloat keyBordTabbarHight = 35;
    //计算输入框向上移动的偏移量
    int offset = textField_Y + textFieldHight - (screenHight - keyBordHight - keyBordTabbarHight);
    
    //根据键盘遮挡的高度开始移动动画
    [UIView animateWithDuration:0.3 animations:^{
        if (offset > 0) {
            
            float width = self.view.frame.size.width;
            float hight = self.view.frame.size.height;
            
            CGRect rect = CGRectMake(0, -offset, width, hight);
            self.view.frame = rect;
        }
    }];
}

- (void)shakeAnimationForView:(UIView *) view

{
    
    // 获取到当前的View
    
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    
    CGPoint x = CGPointMake(position.x + 10, position.y);
    
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    
    [animation setAutoreverses:YES];
    
    // 设置时间
    
    [animation setDuration:.06];
    
    // 设置次数
    
    [animation setRepeatCount:3];
    
    // 添加上动画
    
    [viewLayer addAnimation:animation forKey:nil];
}

@end
