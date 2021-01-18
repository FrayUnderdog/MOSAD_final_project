//
//  TabBarController.m
//  FinalApp
//
//  Created by 祥哥 on 2019/12/20.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabBarController.h"
#import "Calendar.h"
#import "MyCalendar.h"
#import "SettingViewController.h"
#import "inBox.h"
@interface TabBarController()
@property(nonatomic, strong) Calendar * calendar;
@property(nonatomic, strong) inBox * inbox;
@property(nonatomic, strong) SettingViewController * setting;
@property(nonatomic, strong) NSArray * weekArr;
@property(nonatomic, strong) UIColor * lightgray;
@property(nonatomic, strong) UIColor * blue;
@property(nonatomic, strong) MyCalendar * myCalendar;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Inbox";
    self.inbox = [[inBox alloc] init];
    self.inbox.tabBarItem.title = @"task";
    self.inbox.tabBarItem.image = [[UIImage imageNamed:@"task.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.inbox.tabBarItem.selectedImage =[[UIImage imageNamed:@"task1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:self.inbox];
    
    self.calendar = [[Calendar alloc] init];
    self.calendar.tabBarItem.title = @"calendar";
    self.calendar.tabBarItem.image = [[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.calendar.tabBarItem.selectedImage =[[UIImage imageNamed:@"calendar1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:self.calendar];
    
    self.setting = [[SettingViewController alloc] init];
    self.setting.tabBarItem.title = @"settings";
    self.setting.tabBarItem.image = [[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.setting.tabBarItem.selectedImage =[[UIImage imageNamed:@"settings1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:self.setting];

}

-(NSMutableDictionary*)splitActivity:(NSString *)string{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    if(string.length == 0) return dic;
//    NSDictionary * dic = [[NSDictionary alloc] init];
    NSArray * arr = [string componentsSeparatedByString:@"\n"];
    for(NSInteger i = 0; i < arr.count; ++ i) {
        NSArray * temp = [arr[i] componentsSeparatedByString:@":"];
        NSArray * temp1 = [temp[1] componentsSeparatedByString:@","];
        [dic setObject:temp1 forKey:temp[0]];
    }
    return dic;
}

//点击后不能直接改变selectedIndex
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //更新数据
    NSString* a = self.setting.name.copy;
    NSString* b = self.calendar.name.copy;
    NSString* c = self.inbox.name.copy;
    if(self.setting.signIn && (a!=b || a!=c))
    {
        self.activityDic = [self splitActivity:self.setting.activity.copy];
        self.calendar.name = self.setting.name;
        self.calendar.pwd = self.setting.pwd;
        self.inbox.activity = self.activityDic;
        self.calendar.activity = self.activityDic;
        self.inbox.pwd = self.setting.pwd;
        self.inbox.name = self.setting.name;
    }
    else if(!self.setting.signIn)
    {
        self.activityDic = [[NSMutableDictionary alloc] init];
        self.calendar.name = @"UserName";
        self.calendar.pwd = nil;
        self.inbox.activity = nil;
        self.calendar.activity = nil;
        self.inbox.pwd = nil;
        self.inbox.name = @"UserName";
    }
    if([tabBar.selectedItem.title  isEqual: @"task"]) {
        self.title = @"Inbox";
    }
    else if([tabBar.selectedItem.title  isEqual: @"calendar"]) {
        self.title = @"Today";
    }
    else if([tabBar.selectedItem.title  isEqual: @"settings"]) {
        self.title = @"Settings";
    }
}



@end
