//
//  Task.h
//  FinalApp
//
//  Created by 祥哥 on 2019/12/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#ifndef Setting_h
#define Setting_h
#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * pwd;
@property(nonatomic, assign) BOOL signIn;
@property (nonatomic,strong) NSString * activity;
@end

#endif /* Setting_h */
