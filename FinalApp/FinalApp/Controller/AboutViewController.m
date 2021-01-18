//
//  AboutViewController.m
//
//  Created by Hsy on 2019/12/28.
//  Copyright © 2019 Hsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AboutViewController.h"

@interface AboutViewController()
@property (nonatomic, strong) UILabel* classInfo;
@property (nonatomic, strong) UILabel* memberInfo;
@property (nonatomic, strong) UILabel* appInfo;
@end

@implementation AboutViewController

- (void)viewDidLoad{
    [self.navigationItem setTitle:@"About us"];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    _classInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, width, 120)];
    [_classInfo setFont:[UIFont systemFontOfSize:30 weight:5]];
    [_classInfo setTextAlignment:NSTextAlignmentCenter];
    [_classInfo setTextColor:[UIColor blackColor]];
    [_classInfo setNumberOfLines:0];
    [_classInfo setText:@"现代操作系统应用开发\nMOSAD期末项目"];
    
    _memberInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, width, 120)];
    [_memberInfo setFont:[UIFont systemFontOfSize:23]];
    [_memberInfo setTextAlignment:NSTextAlignmentCenter];
    [_memberInfo setNumberOfLines:0];
    [_memberInfo setText:@"小组信息：\n李赛尉：17343062\n李秀祥：17343065\n何思远：17343038"];
    
    _appInfo = [[UILabel alloc] initWithFrame:CGRectMake(40, 350, width-80, height - 400)];
    [_appInfo setFont:[UIFont systemFontOfSize:20]];
    [_appInfo setTextAlignment:NSTextAlignmentCenter];
    [_appInfo setNumberOfLines:0];
    [_appInfo setLineBreakMode:NSLineBreakByWordWrapping];
    [_appInfo setText:@"Planning APP\nHelp you plan your life and view them in the phone!\nJust use this app to markdowm the things you should do and choose dates of them, they will be uploaded to the server and download when you login next time.\nIt is easy to use and you can read the tutorial in the setting page\nNow just try it!"];
    
    [self.view addSubview:_classInfo];
    [self.view addSubview:_memberInfo];
    [self.view addSubview:_appInfo];
}

@end
