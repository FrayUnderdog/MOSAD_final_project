//
//  MyCalendar.h
//  FinalApp
//
//  Created by 祥哥 on 2019/12/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#ifndef MyCalendar_h
#define MyCalendar_h
#import <Foundation/Foundation.h>
@interface MyCalendar : NSObject
@property(nonatomic, assign) NSInteger year;
@property(nonatomic, assign) NSInteger month;
@property(nonatomic, assign) NSInteger day;
@property(nonatomic, strong) NSDateComponents * nowTime;
-(NSArray *)getSingleCal;
-(NSInteger)getNowWeek;
-(NSArray*)setArray;
-(NSArray*)getLastMonth;
-(NSArray*)getNextMonth;
@end

#endif /* MyCalendar_h */
