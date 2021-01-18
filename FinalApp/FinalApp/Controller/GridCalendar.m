//
//  GridCalendar.m
//  FinalApp
//
//  Created by 祥哥 on 2019/12/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridCalendar.h"
#import "MyCalendar.h"
#import "GridCalendarCell.h"
@interface GridCalendar() <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UIButton * nextMonth;
@property(nonatomic, strong) UIButton * lastMonth;
@property(nonatomic, strong) UILabel * label;
@property(nonatomic, strong) MyCalendar * myCalendar;
@property(nonatomic, strong) NSArray * weekArr;
@property(nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic, strong) NSArray * dateArr; //存放需要的日期
@property(nonatomic, strong) UIColor * lightblue;
@property(nonatomic, assign) NSInteger index;   //用来控制日历选中
@property(nonatomic, strong) NSString * selectedDate;   //日历选中的日期

@end

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation GridCalendar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lightblue = [UIColor colorWithRed:222.0/255 green:229.0/255 blue:251.0/255 alpha:1.0];
        self.weekArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        self.index = -1;
        self.selectedDate = @"";
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.9;
        
        [self addSubview:self.nextMonth];
        [self addSubview:self.lastMonth];
        
        self.myCalendar = [[MyCalendar alloc] init];
        
        self.dateArr = [self.myCalendar setArray];
        
        [self addSubview:self.label];
        
        [self setupWeek];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

#pragma mark lazy loading
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout * flowout = [[UICollectionViewFlowLayout alloc] init];
        flowout.minimumLineSpacing = 4;
        flowout.minimumInteritemSpacing = 10;
        
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 133, WIDTH-40, 210) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GridCalendarCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = _lightblue;
        _collectionView.alpha = 0.9;
    }
    return _collectionView;
}

- (UIButton *)nextMonth{
    if(!_nextMonth){
        _nextMonth = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 80 - 30, 70, 80, 30)];
        _nextMonth.alpha = 1.0;
        [_nextMonth setTitle:@"下个月" forState:UIControlStateNormal];
        [_nextMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _nextMonth.titleLabel.textColor = [UIColor lightGrayColor];
//        _nextMonth.backgroundColor = [UIColor whiteColor];
        _nextMonth.layer.cornerRadius = 10.0;
        _nextMonth.layer.borderWidth = 1.0;
        _nextMonth.layer.borderColor = [UIColor blueColor].CGColor;
        [_nextMonth addTarget:self action:@selector(next_month:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextMonth;
}

- (UIButton *)lastMonth{
    if(!_lastMonth){
        _lastMonth = [[UIButton alloc] initWithFrame:CGRectMake(30, 70, 80, 30)];
        [_lastMonth setTitle:@"上个月" forState:UIControlStateNormal];
        [_lastMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _lastMonth.layer.cornerRadius = 10.0;
        _lastMonth.layer.borderWidth = 1.0;
        _lastMonth.layer.borderColor = [UIColor blueColor].CGColor;
        [_lastMonth addTarget:self action:@selector(last_month:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastMonth;
}

- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 - 65, 60, 130, 50)];
        NSString * string = [NSString stringWithFormat:@"%ld年%ld月",self.myCalendar.year,self.myCalendar.month];
        _label.text = string;
        _label.textColor = [UIColor blueColor];
        _label.font = [UIFont systemFontOfSize:20];
        _label.textAlignment = NSTextAlignmentCenter;
//        _label.backgroundColor = [UIColor blackColor];
    }
    return _label;
}

#pragma mark 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"test  %ld",self.dateArr.count);
    return self.dateArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((WIDTH-40)/7.0 - 15, (WIDTH-40)/7.0 - 15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GridCalendarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dateArr[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.borderWidth  = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.alpha = 1.0;
    if([self.dateArr[indexPath.row] isEqualToString:@""]) {
        cell.textLabel.backgroundColor = _lightblue;
    }
    else if(self.index == indexPath.row){
        self.selectedDate = self.dateArr[indexPath.row];
        cell.textLabel.layer.cornerRadius = cell.textLabel.frame.size.height/2.0;
        cell.textLabel.layer.borderWidth = 1.0;
        cell.textLabel.clipsToBounds = YES;
        cell.textLabel.backgroundColor = [UIColor blueColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.alpha = 0.5;
    }
    else {
        //确定哪个是今天
        if(self.myCalendar.year == self.myCalendar.nowTime.year && self.myCalendar.month == self.myCalendar.nowTime.month && indexPath.row+1 == self.myCalendar.nowTime.day){
            cell.textLabel.backgroundColor = [UIColor orangeColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.layer.cornerRadius = cell.textLabel.frame.size.height/2.0;
            cell.textLabel.layer.borderWidth = 1.0;
            cell.textLabel.clipsToBounds = YES;
        }
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GridCalendarCell * cell = (GridCalendarCell*) [collectionView cellForItemAtIndexPath:indexPath];
    if([cell.textLabel.text isEqualToString:@""]) return;
    self.index = indexPath.row;
    [self.collectionView reloadData];
}

#pragma mark 自定义UIk函数
-(void) setupWeek{
    UIView * tempView = [[UIView alloc] initWithFrame:CGRectMake(20, 115, WIDTH - 40, 10)];
//    tempView.layer.cornerRadius = 10.0;
    for(int i = 0; i < self.weekArr.count; ++ i) {
        UILabel * temp = [[UILabel alloc] initWithFrame:CGRectMake((tempView.frame.size.width/7)*i, 0, tempView.frame.size.width/7, 10)];
        temp.text = self.weekArr[i];
        temp.textAlignment = NSTextAlignmentCenter;
        temp.textColor = [UIColor blackColor];
        temp.font = [UIFont systemFontOfSize:14];
        [tempView addSubview:temp];
    }
    [self addSubview:tempView];
    
}

#pragma mark next month
-(void) next_month:(UIButton*)button{
    NSLog(@"next month");
    
    self.dateArr = [self.myCalendar getNextMonth];
    self.index = -1;
    [self.collectionView reloadData];
    
    self.label.text = [NSString stringWithFormat:@"%ld年%ld月",self.myCalendar.year,self.myCalendar.month];
}

#pragma mark last month
-(void)last_month:(UIButton*)button{
    NSLog(@"last month");
    self.index = -1;
    self.dateArr = [self.myCalendar getLastMonth];
    [self.collectionView reloadData];
    self.label.text = [NSString stringWithFormat:@"%ld年%ld月",self.myCalendar.year,self.myCalendar.month];
}

- (NSArray *)getSelectedDate{
    NSString * year1 = [NSString stringWithFormat:@"%ld",self.myCalendar.year];
    NSString * month1 = [NSString stringWithFormat:@"%ld",self.myCalendar.month];
    if(self.selectedDate.length == 1){
        NSString * string = [NSString stringWithFormat:@"0%@",self.selectedDate];
        self.selectedDate = string;
    }
    if(month1.length == 1){
        NSString * string = [NSString stringWithFormat:@"0%@",month1];
        month1 = string;
    }
    NSArray * temp = @[year1,month1, self.selectedDate];
    return temp;
}
@end
