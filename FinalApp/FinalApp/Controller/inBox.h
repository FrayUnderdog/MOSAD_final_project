//
//  inBox.h
//  FinalApp
//
//  Created by a wd on 2019/12/25.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef inBox_h
#define inBox_h

#import <UIKit/UIKit.h>

@interface inBox : UIViewController
@property(nonatomic, strong)NSMutableDictionary * activity;
@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * pwd;
@property(nonatomic, assign)BOOL del;
@end
#endif /* inBox_h */
