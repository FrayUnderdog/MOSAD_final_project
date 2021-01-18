//
//  Task.m
//  FinalApp
//
//  Created by 祥哥 on 2019/12/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingViewController.h"
#import "TabBarController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "TutorialViewController.h"
#import "AboutViewController.h"
#import "Suggestion.h"
@interface SettingViewController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* userView;
@property (nonatomic, strong) LoginViewController * login;
@property (nonatomic, strong) SignupViewController * signup;
@property (nonatomic, strong) UILabel* username;
@property (nonatomic, strong) NSString * lastName;
@end

@implementation SettingViewController

- (void)viewDidLoad{
    [self settingNav];
//    [self.view addSubview:self.userView];
    
    self.signIn = NO;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
-(NSMutableDictionary*)splitActivity:(NSString *)string{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    if(string.length == 0) return dic;
    //    NSDictionary * dic = [[NSDictionary alloc] init];
    NSArray * arr = [string componentsSeparatedByString:@"\n"];
//    NSLog(@"arr %@",arr);
    for(NSInteger i = 0; i < arr.count; ++ i) {
        NSArray * temp = [arr[i] componentsSeparatedByString:@":"];
        NSArray * temp1 = [temp[1] componentsSeparatedByString:@","];
        [dic setObject:temp1 forKey:temp[0]];
    }
    return dic;
}
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"load view");
    if(self.login.name.length != 0) {
            if([self.username.text isEqualToString:self.login.name]){
//                self.signIn = NO;
            }
            else {
                self.username.text = self.login.name;
                self.signIn = YES;
                self.activity = self.login.activity;
                self.name = self.login.name;
                self.pwd = self.login.pwd;
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [cell.textLabel setText:@"Log out"];
                [cell.textLabel setTextColor:[UIColor redColor]];
            }
//        }
    }
    NSLog(@"current user:%@.", self.username.text);
    NSLog(@"signIn: %d", self.signIn);
    NSLog(@"%@",self.login.activity);
    
    
    
//    [self.userView addSubview:self.username];
}

- (void)settingNav{
    [self.navigationItem setTitle:@"Setting"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:97.0/255 green:127.0/255 blue:222.0/255 alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (UIView*)userView {
    if (_userView == nil) {
        _userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
        [_userView setBackgroundColor:[UIColor whiteColor]];
        
        float itemSize = 100;
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-itemSize/2, 50, itemSize, itemSize)];
        [img setImage:[UIImage imageNamed:@"loginIn.png"]];
        [img.layer setMasksToBounds:YES];
        [img.layer setCornerRadius:20];
        
        float len = 200;
        self.username = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-len/2, 80+itemSize, len, 25)];
        [self.username setTextAlignment:NSTextAlignmentCenter];
        [self.username setFont:[UIFont systemFontOfSize:18]];
        [self.username setText:@"Username"];
        
        [_userView addSubview:img];
        [_userView addSubview:_username];
    }
    if(self.login.name.length != 0) {
        self.username.text = self.login.name;
        [_username addSubview:_username];
    }
    return _userView;
}

- (UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.separatorInset = UIEdgeInsetsMake(0,20,0,20);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int i = 1;
    switch (section) {
        case 0:
            i = 2;
            break;
        case 1:
            i = 1;
            break;
        case 2:
            i = 3;
            break;
    }
    return i;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if ([self.username.text isEqualToString:@"Username"]) {
            NSLog(@"login");
            self.login = [[LoginViewController alloc] init];
            self.signup = [[SignupViewController alloc] init];
            [self.navigationController pushViewController:self.login animated:YES];
        }
        else {
            [self.username setText:@"Username"];
            NSLog(@"logout");
            self.signIn = NO;
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell.textLabel setText:@"Login"];
            [cell.textLabel setTextColor:[UIColor blueColor]];
            self.login.name = @"Username";
        }
    }
    else if (indexPath.section == 1){
        [self.tabBarController tabBar:self.tabBarController.tabBar didSelectItem:self.tabBarController.tabBar.items.firstObject];
        [self.tabBarController setSelectedIndex:0];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TutorialViewController* tu = [[TutorialViewController alloc] init];
            [self.navigationController pushViewController:tu animated:YES];
        }
        else if (indexPath.row == 2) {
            AboutViewController* about = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
        else {
            Suggestion* sug = [[Suggestion alloc] init];
            sug.username = self.username.text;
            [self.navigationController pushViewController:sug animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 220;
    }
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.userView];
        }
        else {
            [cell.textLabel setFont:[UIFont systemFontOfSize:21]];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            if ([self.username.text isEqualToString:@"Username"]) {
                [cell.textLabel setText:@"Log in"];
                [cell.textLabel setTextColor:[UIColor blueColor]];
            }
            else {
                [cell.textLabel setText:@"Log out"];
                [cell.textLabel setTextColor:[UIColor redColor]];
            }
        }
        return cell;
    }
    
    if (indexPath.section == 1) {
        switch(indexPath.row) {
            case 0:
                [cell.imageView setImage:[UIImage imageNamed:@"list.png"]];
                [cell.textLabel setText:@"MyList"];
                break;
        }
    }
    else if (indexPath.section == 2) {
        switch(indexPath.row) {
            case 0:
                [cell.imageView setImage:[UIImage imageNamed:@"plane.png"]];
                [cell.textLabel setText:@"Tutorial"];
                break;
            case 1:
                [cell.imageView setImage:[UIImage imageNamed:@"document.png"]];
                [cell.textLabel setText:@"Feedback & Suggestion"];
                break;
            case 2:
                [cell.imageView setImage:[UIImage imageNamed:@"book.png"]];
                [cell.textLabel setText:@"About"];
                break;
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    CGSize itemSize = CGSizeMake(45, 45);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [cell.textLabel setFont:[UIFont systemFontOfSize:22]];
    
    return cell;
}

@end
