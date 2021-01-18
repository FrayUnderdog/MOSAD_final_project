//
//  Suggestion.m
//
//  Created by Hsy on 2019/12/28.
//  Copyright © 2019 Hsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Suggestion.h"

@interface Suggestion() <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic)UITextView* textView;
@property (strong, nonatomic)UIButton* button;
@property (strong, nonatomic)UILabel* tips;
@end

@implementation Suggestion

- (void)viewDidLoad{
    [self.navigationItem setTitle:@"Suggestion"];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.button];
    [self.view addSubview:self.tips];
}


-(UITextView*)textView{
    if (_textView == nil) {
        float len = self.view.frame.size.width - 50;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(25, 100, len, 400)];
        [_textView setFont:[UIFont systemFontOfSize:20]];
        _textView.delegate = self;
        [_textView.layer setBorderWidth:2];
        [_textView.layer setCornerRadius:5];
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

-(UIButton*)button {
    if (_button == nil) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(50, self.textView.frame.origin.y + 420, self.view.frame.size.width-100, 50)];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 25;
        [_button setBackgroundColor:[UIColor blueColor]];
        [_button setTitle:@"Submit" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(UILabel*) tips{
    if (_tips == nil) {
        float len = self.view.frame.size.width - 60;
        _tips = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, len, 45)];
        [_tips setText:@"Give us some suggestion~~"];
        [_tips setTextColor:[UIColor lightGrayColor]];
        [_tips setFont:[UIFont systemFontOfSize:19]];
    }
    return _tips;
}

-(NSString*) username{
    if (_username == nil) {
        _username = @"anonymous";
    }
    return _username;
}

-(void)submit:(UIButton*)button{
    NSLog(@"%@", _textView.text);
    if(_textView.text.length == 0){
        [self shakeAnimationForView:self.button];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        NSURLSessionConfiguration * defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession * delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURL * url = [NSURL URLWithString:@"http://172.18.176.201:3000/sendSug"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        
        // 设置请求体为JSON
        if ([self.username isEqualToString:@"Username"]) {
            self.username = @"anonymous";
        }
        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.username,@"name",self.textView.text,@"suggestion", nil];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse * response, NSError * error){
            if(error == nil) {
                NSLog(@"user %@", self.username);
            }
            else {
                NSLog(@"err %@", error);
            }
            dispatch_group_leave(group);
        }];
        [dataTask resume];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
        });
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _tips.text = @"Give us some suggestion~~";
    } else {
        _tips.text = @"";
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
