//
//  Calendar.m
//  FinalApp
//
//  Created by 祥哥 on 2019/12/20.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Calendar.h"
#import "MyCalendar.h"
#import "GridCalendar.h"
@interface Calendar()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property(nonatomic, strong)UIColor * blue;
@property(nonatomic, strong) NSArray * weekArr;
@property(nonatomic, strong) UIColor * lightgray;
@property(nonatomic, strong) UIColor * lightblue;

@property(nonatomic, strong) UIView * tipView;
@property(nonatomic, strong) MyCalendar * myCalendar;

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray * plans;
@property(nonatomic, strong) UILabel * today;
@property(nonatomic, strong) UIButton * plusButton;
@property(nonatomic, strong) UITextView * commentText;
@property(nonatomic, strong) UILabel * placeholder;
@property(nonatomic, strong) NSString * dateString;
//日历格子部分
@property(nonatomic, strong) GridCalendar * gridCalendar;
@property(nonatomic, strong) NSString * response;
@end
#define WIDTH self.view.frame.size.width
#define HIGHT self.view.frame.size.height
@implementation Calendar

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activity = [[NSMutableDictionary alloc] init];
    self.blue = [UIColor colorWithRed:86.0/255 green:129.0/255 blue:236.0/255 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = self.blue;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.lightgray = [UIColor colorWithRed:245.0/255 green:246.0/255 blue:247.0/255 alpha:1.0];
    self.lightblue = [UIColor colorWithRed:222.0/255 green:229.0/255 blue:251.0/255 alpha:1.0];
    self.view.backgroundColor = self.lightgray;
    self.weekArr = @[@"S",@"M",@"T",@"W",@"T",@"F",@"S"];
    self.plans = [[NSMutableArray alloc] init];
    
    self.myCalendar = [[MyCalendar alloc] init];
    //搭起UI
    [self setStableWeek];
    [self setMoveableWeek];
    [self setTips];
    [self todayLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.plusButton];
    [self.view addSubview:self.gridCalendar];
    //点击屏幕其他地方，隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated{
    //[self.plans removeAllObjects];
    self.plans = [[NSMutableArray alloc] init];
    self.dateString = [NSString stringWithFormat:@"%ld%ld%ld",self.myCalendar.nowTime.year,self.myCalendar.nowTime.month,self.myCalendar.nowTime.day];
    NSArray * keys = [self.activity allKeys];
    for(NSInteger i = 0; i < keys.count; ++ i) {
//
        if([keys[i] isEqualToString:self.dateString]){
//            NSLog(@"第二次 %@",self.activity);
            NSArray * temp = [self.activity objectForKey:keys[i]];
//            NSLog(@"temp %@",temp);
            for(NSInteger i = 0; i < temp.count; ++ i) {
                [self.plans addObject:temp[i]];
            }
        }
    }
    NSLog(@"plans %@",self.plans);
    [self.tableView reloadData];
}

#pragma mark 隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if(self.gridCalendar.frame.origin.y == -350){
        [_commentText resignFirstResponder];
        _commentText.text = @"";
    }
    NSLog(@"text  %@",_commentText.text);
    
}

#pragma mark lazy loading
- (GridCalendar *)gridCalendar{
    if(!_gridCalendar){
        _gridCalendar = [[GridCalendar alloc] initWithFrame:CGRectMake(0, -350, self.view.frame.size.width, 350)];
        _gridCalendar.backgroundColor = _lightblue;
    }
    return _gridCalendar;
}

- (UIButton *)plusButton{
    if(!_plusButton){
        _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(340, 620, 50, 50)];
        _plusButton.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imageView.image = [UIImage imageNamed:@"button.png"];
        imageView.backgroundColor = _lightgray;
        [_plusButton addSubview: imageView];
        [_plusButton addTarget:self action:@selector(keyboardAppear:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

- (UITableView *)tableView{
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 325, self.view.frame.size.width, 350) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        //允许编辑
        [_tableView setEditing:YES animated:YES];
        
        //多选
        _tableView.allowsSelectionDuringEditing = YES;
        
        _tableView.backgroundColor = _lightgray;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableView;
}

#pragma mark tableView的数据处理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _plans.count;
}

//编辑样式(删除)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//是否允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _plans[indexPath.row];

    //修改选中后的颜色
//    cell.selectedBackgroundView = [[UIView alloc] init];
//    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];

    return cell;
}
#pragma mark 自定义函数

//设置日历页面固定星期部分
-(void) setStableWeek{
    
    UIColor * gold = [UIColor colorWithRed:255.0/255 green:196.0/255 blue:40.0/255 alpha:1.0];
    for(int i = 0; i < _weekArr.count; ++ i) {
        
        UILabel * weeklabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/7)*i,60 , self.view.frame.size.width/7, 35)];
        weeklabel.text = _weekArr[i];
        weeklabel.font = [UIFont systemFontOfSize:14];
        [weeklabel setTextAlignment:NSTextAlignmentCenter];
        if(i == 0 || i == _weekArr.count-1) {
            weeklabel.textColor = gold;
        }
        else weeklabel.textColor = [UIColor grayColor];
        
        [self.view addSubview:weeklabel];
    }
}

//设置星期下面的日期
-(void) setMoveableWeek{
    NSArray * arr = [_myCalendar getSingleCal];
    NSLog(@"星期 %@",arr);
    NSInteger nowWeek = [_myCalendar getNowWeek];
    UIView * layer = [[UIView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 70)];
    layer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layer];
    for (int i = 0; i < arr.count; ++ i) {
        float wid = self.view.frame.size.width/7 - 16;
        UILabel * weeklabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/7)*i+8,95+(35 - wid/2) , wid, wid)];
        
        weeklabel.layer.cornerRadius = 21.0;
        weeklabel.clipsToBounds = YES;
        weeklabel.text = arr[i];
        if(i+1 == nowWeek) {
            weeklabel.backgroundColor = _blue;
            weeklabel.textColor = [UIColor whiteColor];
        }
        else weeklabel.textColor = [UIColor blackColor];
        //        weeklabel.font = [UIFont systemFontOfSize:14];
        [weeklabel setTextAlignment:NSTextAlignmentCenter];
        
        
        [self.view addSubview:weeklabel];
    }
}

//下方提示的UI
-(void) setTips {
    float y_begin = 95 + 70 + 20;
    float total_wid = self.view.frame.size.width;
    _tipView = [[UIView alloc] initWithFrame:CGRectMake(10, y_begin, total_wid - 20, 100)];
    _tipView.backgroundColor = _lightblue;
    _tipView.layer.cornerRadius = 5.0;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, _tipView.frame.size.width-120, 50)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.text = @"You can set dates for tasks and check what needs to do on each day in Calendar";
    label.font = [UIFont systemFontOfSize:14];
    
    //左侧画图片
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
//    imgView.backgroundColor = [UIColor redColor];
    imgView.image = [UIImage imageNamed:@"tips.png"];
    
    
    //右下角“got it” button
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(_tipView.frame.size.width - 100, _tipView.frame.size.height- 50, 80, 40)];
    [button setTitle:@"Got It" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:_blue forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(gone:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tipView addSubview:button];
    [_tipView addSubview:imgView];
//    UIButton * button
    [_tipView addSubview:label];
    [self.view addSubview:_tipView];
    
}

//tableView s上面的today字样
-(void) todayLabel {
    float y_begin = 95 + 70 + 20 + 100 + 10;
    self.today = [[UILabel alloc] initWithFrame:CGRectMake(0, y_begin, self.view.frame.size.width, 30)];
    self.today.backgroundColor = _lightblue;
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 30)];
//    textLabel.backgroundColor = [UIColor redColor];
    textLabel.text = @"TODAY";
    textLabel.textColor = [UIColor grayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.today addSubview:textLabel];
    
    [self.view addSubview:self.today];
}



#pragma mark tips 消失函数
-(void)gone:(UIButton*) button{
    NSLog(@"click!");
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tipView.alpha = 0.0;
        
        NSLog(@"开始动画");
    } completion:^(BOOL finished){
        self.tipView.hidden = YES;
        NSLog(@"动画结束");
    }];
    [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.today.transform = CGAffineTransformTranslate(self.today.transform, 0, -110);
        self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, 0, -110);
    } completion:^(BOOL finished){

        NSLog(@"动画结束");
    }];
}



#pragma mark 键盘显示函数
-(void)keyboardAppear:(UIButton*) button{
    [self createCommentsView];
    [self.commentText becomeFirstResponder];
    NSLog(@"plus button clicked");
}

#pragma mark 处理键盘上放的按钮
- (void)createCommentsView {
    
    UIView * commentsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    commentsView.backgroundColor = _lightgray;
    
//    self.commentText = [[UITextView alloc] initWithFrame:CGRectInset(commentsView.bounds, 5.0, 5.0)];
    _commentText = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, WIDTH-20, 40)];
    _commentText.backgroundColor = [UIColor whiteColor];
    _commentText.layer.borderColor   = [UIColor grayColor].CGColor;
    _commentText.layer.borderWidth   = 1.0;
    _commentText.layer.cornerRadius  = 2.0;
    _commentText.layer.masksToBounds = YES;
    
    _commentText.inputAccessoryView  = commentsView;
    _commentText.backgroundColor     = [UIColor clearColor];
    _commentText.returnKeyType       = UIReturnKeySend;
    _commentText.delegate            = self;
    _commentText.font                = [UIFont systemFontOfSize:15.0];
    [commentsView addSubview:_commentText];
    [self.view.window addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    
    //place holder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _commentText.frame.size.width, _commentText.frame.size.height)];
    _placeholder.text = @"What would you like to do?";
    _placeholder.textColor = [UIColor lightGrayColor];
//    _placeholder.backgroundColor = [UIColor whiteColor];
    [_commentText addSubview:_placeholder];
//    [_commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
    
    
    //右边的sendbutton
    UIButton * sendButton = [[UIButton alloc] initWithFrame:CGRectMake(350, 77.5, 25, 25)];
    sendButton.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView.image = [UIImage imageNamed:@"send.png"];
    [sendButton addSubview:imageView];
    [sendButton addTarget:self action:@selector(send_mes:) forControlEvents:UIControlEventTouchUpInside];
    [commentsView addSubview:sendButton];
    
    
    //左边的日历按钮
    UIButton * calendarButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 77.5, 25, 25)];
    calendarButton.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView2.image = [UIImage imageNamed:@"calendar_small.png"];
    [calendarButton addSubview:imageView2];
    [calendarButton addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [commentsView addSubview:calendarButton];
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length == 0) {
        _placeholder.text = @"What would you like to do?";
    }
    else _placeholder.text = @"";
}

#pragma mark 发送按钮函数
-(void)send_mes:(UIButton*)button{
    NSArray * res = _gridCalendar.getSelectedDate;
    NSLog(@"%ld",[res[0] integerValue]);
    NSLog(@"send mes %@  %@",_commentText.text,_gridCalendar.getSelectedDate);
    if(res[2] == 0) return;
    [_commentText resignFirstResponder];
    if(self.gridCalendar.frame.origin.y != -350){
        [UIView animateWithDuration:0.5 animations:^{
            self.gridCalendar.transform = CGAffineTransformTranslate(self.gridCalendar.transform, 0, -350);
        } completion:^(BOOL finished){
            NSLog(@"日历动画结束了");
            NSLog(@" %f", self.gridCalendar.frame.origin.y);
        }];
    }
    if(_commentText.text.length != 0){
        NSInteger int1 = [res[0] integerValue];
        NSInteger int2 = [res[1] integerValue];
        NSInteger int3 = [res[2] integerValue];

        //待哦用API将计划加入到后端
        NSString * date =[NSString stringWithFormat:@"%@%@%@",res[0],res[1],res[2]];
        NSString * name = self.name;
        NSString * pwd = self.pwd;
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);

        NSURLSessionConfiguration * defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession * delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURL * url = [NSURL URLWithString:@"http://172.18.176.201:3000/addActivity"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];

        // 设置请求体为JSON

        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",pwd,@"pwd",date,@"date",self.commentText.text,@"activity", nil];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse * response, NSError * error){
            if(error == nil) {
                self.response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"ssss %@",self.response);

            }
            dispatch_group_leave(group);
        }];
        [dataTask resume];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if(self.myCalendar.nowTime.year == int1 && self.myCalendar.nowTime.month == int2 && self.myCalendar.nowTime.day == int3){
                [self.plans addObject:self.commentText.text];
                [self.activity setObject:self.plans forKey:self.dateString];
                [self.tableView reloadData];
            }
            else
            {
                NSMutableArray *t = [[NSMutableArray alloc] init];
                NSArray * keys = [self.activity allKeys];
                for(NSInteger i = 0; i < keys.count; ++ i) {
                    if([keys[i] isEqualToString:date]){
                        NSArray * temp = [self.activity objectForKey:keys[i]];
                        for(NSInteger i = 0; i < temp.count; ++ i) {
                            [t addObject:temp[i]];
                        }
                    }
                }
                [t addObject:self.commentText.text];
                [self.activity setObject:t forKey:date];
            }
        });
    }
}
#pragma mark 打开日历
-(void)openCalendar:(UIButton *)button{
    NSLog(@"calendar open");
    NSLog(@" %f", self.gridCalendar.frame.origin.y);
    float temp_y = 0;
    if(self.gridCalendar.frame.origin.y == -350) {
        temp_y = 350;
    }
    else temp_y = -350;
    [UIView animateWithDuration:0.5 animations:^{
        self.gridCalendar.transform = CGAffineTransformTranslate(self.gridCalendar.transform, 0, temp_y);
    } completion:^(BOOL finished){
        NSLog(@"日历动画结束了");
        NSLog(@" %f", self.gridCalendar.frame.origin.y);
    }];
}

@end
