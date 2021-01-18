//
//  inBox.m
//  FinalApp
//
//  Created by a wd on 2019/12/25.
//  Copyright © 2019 apple. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "inBox.h"
@interface inBox()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) UIColor * blue;
@property(nonatomic, strong) UIColor * lightgray;
@property(nonatomic, strong) UIColor * lightblue;
@property(nonatomic, strong) NSArray * plans;
@property(nonatomic, strong) NSArray * dates;
@property(nonatomic, strong) UILabel * delLabel;
@property(nonatomic, assign) NSInteger num;
@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, assign) BOOL flag;
@property(nonatomic, strong) NSString * response;
@end

@implementation inBox

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flag = YES;
    self.activity = [[NSMutableDictionary alloc] init];
    self.blue = [UIColor colorWithRed:86.0/255 green:129.0/255 blue:236.0/255 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = self.blue;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.lightgray = [UIColor colorWithRed:245.0/255 green:246.0/255 blue:247.0/255 alpha:1.0];
    self.lightblue = [UIColor colorWithRed:222.0/255 green:229.0/255 blue:251.0/255 alpha:1.0];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.imageView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *unLogin = @"UserName";
    NSLog(@"%@",self.name);
    if(self.name == unLogin)
    {
        self.flag = NO;
    }
    if(self.name.length != 0) {
        
        NSArray *arr = [self.activity allKeys];
        
        self.dates = [arr sortedArrayWithOptions:NSSortStable usingComparator:
        ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    int value1 = [obj1 intValue];
                    int value2 = [obj2 intValue];
                    if (value1 > value2) {
                        return NSOrderedDescending;
                    }
                    else{
                        return NSOrderedAscending;
                    }
        }];

        
        [self.imageView removeFromSuperview];
        [self.tableView reloadData];
        if(!self.flag){
            [self.view addSubview:self.imageView];
            self.flag = YES;
        }
    }
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"test.png"];
    }
    return _imageView;
}

- (UITableView *)tableView{
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dates.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSString * year = [self.dates[section] substringToIndex:4];
    NSString * temp = [self.dates[section] substringFromIndex:4];
    NSString * month = [temp substringToIndex:2];
    NSString * day = [temp substringFromIndex:2];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 20)];
    label.text = [NSString stringWithFormat:@"  %@年%@月%@日",year,month,day];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:17];
    
                                                                
    label.backgroundColor = self.lightblue;
    return label;
}

//是否允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//编辑样式(删除)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//测滑出现删除按钮
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //1.更新数据
        NSMutableArray * arr = [self.activity objectForKey:self.dates[indexPath.section]];
        NSString * ac = arr[indexPath.row];
        if(arr.count > 1)
        {
            [arr removeObjectAtIndex:indexPath.row];
        }
        else
        {
            arr = [[NSMutableArray alloc]init];
        }
        [self.activity setObject:arr forKey:self.dates[indexPath.section]];
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //3.更新后端
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        NSURLSessionConfiguration * defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession * delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURL * url = [NSURL URLWithString:@"http://172.18.176.201:3000/delActivity"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        
        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.name,@"name",self.pwd,@"pwd",self.dates[indexPath.section],@"date", ac,@"activity", nil];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse * response, NSError * error){
            if(error == nil) {
                self.response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"response %@",self.response);
            }
            dispatch_group_leave(group);
        }];
        [dataTask resume];
        
    }];
    return @[deleteRowAction];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.dates[section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * keyArr = [self.activity objectForKey:self.dates[section]];
    return keyArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray * arr = [self.activity objectForKey:self.dates[indexPath.section]];
    cell.textLabel.text = arr[indexPath.row];
    
    return cell;
}


@end
