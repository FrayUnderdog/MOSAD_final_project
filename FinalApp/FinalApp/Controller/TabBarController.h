//
//  TabBarController.h
//  FinalApp
//
//  Created by 祥哥 on 2019/12/20.
//  Copyright © 2019年 apple. All rights reserved.
//

#ifndef TabBarController_h
#define TabBarController_h
#import <UIKit/UIKit.h>
@interface TabBarController : UITabBarController<UITabBarDelegate>
@property(nonatomic, strong) NSMutableDictionary * activityDic;
@end
#endif /* TabBarController_h */
