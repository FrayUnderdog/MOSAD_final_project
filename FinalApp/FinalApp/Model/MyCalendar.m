//
//  MyCalendar.m
//  FinalApp
//
//  Created by 祥哥 on 2019/12/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCalendar.h"
@interface MyCalendar ()
@property(nonatomic, strong) NSCalendar * calendar;
@property(nonatomic, assign) NSInteger weekDay; //当前星期几
@property(nonatomic, strong) NSMutableArray * dayArray;


@end

@implementation MyCalendar

- (instancetype)init {
    if(self = [super init]) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents * components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
        self.nowTime = components;
        self.day = components.day;
        self.month = components.month;
        self.year = components.year;
        self.dayArray = [[NSMutableArray alloc] init];
        self.weekDay = components.weekday;
        NSLog(@"%ld",components.weekday);
    }
    return self;
}

-(NSArray*) setArray{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //当前的日期
    NSDate * nowDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",_year,_month,_day]];
    
    //本月的天数范围
    NSRange dayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nowDate];
    
    //本月第一天
    NSDate * monthFirstDay = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",_year,_month,1]];
    NSDateComponents * firstCom = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:monthFirstDay];
    
    //本月最后一天
    NSDate * monthLastDay = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",_year,_month,dayRange.length]];
    NSDateComponents * lastCom = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:monthLastDay];
    
    //上个月遗留天数
    for(int i = 1; i < firstCom.weekday; ++ i) {
        NSString * string = @"";
        [self.dayArray addObject:string];
    }
    
    //本月天数
    for(NSInteger i = firstCom.weekday; i < firstCom.weekday + dayRange.length; ++ i) {
        NSString * string = [NSString stringWithFormat:@"%ld",i-firstCom.weekday+1];
        [self.dayArray addObject:string];
    }
    
    return self.dayArray;
}

-(NSArray*)getLastMonth{
    [self.dayArray removeAllObjects];
    if(_month == 1){
        _month = 12;
        _year --;
    }
    else _month--;
    return [self setArray];
}

- (NSArray *)getNextMonth{
    [self.dayArray removeAllObjects];
    if(_month == 12){
        _month = 1;
        _year ++;
    }
    else _month++;
    return [self setArray];
}


#pragma mark 实现数据交流方法
- (NSArray *)getSingleCal{
    for(NSInteger i = 1; i < self.weekDay; ++ i) {
        NSInteger temp = self.weekDay - i;
        NSString * string  = [NSString stringWithFormat:@"%ld",self.day-temp];
        [self.dayArray addObject:string];
    }
    for(NSInteger i = _weekDay; i < 9; ++ i) {
        NSInteger temp = i - _weekDay;
        NSString * string  = [NSString stringWithFormat:@"%ld",self.day + temp];
        [_dayArray addObject:string];
    }
    return self.dayArray;
}
- (NSInteger)getNowWeek{
    return self.weekDay;
}
@end
