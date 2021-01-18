//
//  TutorialViewController.m
//  FinalApp
//
//  Created by Hsy on 2019/12/27.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TutorialViewController.h"

@interface TutorialViewController() <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UILabel *label;
@end

@implementation TutorialViewController

- (void)viewDidLoad{
    [self.navigationItem setTitle:@"Tutorial"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    //ScrollView的真实大小 count指滑动的页数
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 4, 400);
    //整页滑动
    self.scrollView.pagingEnabled = YES;
    //可弹性
    self.scrollView.bounces = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    float imgWidth = width - 60;
    float imgHeight = height - 134;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, _scrollView.frame.size.width, 20)];
    [_label setText:@"Step1: Login or Register"];
    [_label setTextAlignment:NSTextAlignmentCenter];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-imgWidth/2 , 35, imgWidth, imgHeight)];
    [img setImage:[UIImage imageNamed:@"step1.png"]];
    [_scrollView addSubview:img];
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(width+width/2-imgWidth/2 , 35, imgWidth, imgHeight)];
    [img2 setImage:[UIImage imageNamed:@"step2.png"]];
    [_scrollView addSubview:img2];
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(width*2+width/2-imgWidth/2 , 35, imgWidth, imgHeight)];
    [img3 setImage:[UIImage imageNamed:@"step3.png"]];
    [_scrollView addSubview:img3];
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(width*3+width/2-imgWidth/2 , 35, imgWidth, imgHeight)];
    [img4 setImage:[UIImage imageNamed:@"step4.png"]];
    [_scrollView addSubview:img4];
    
    
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height - 10, self.scrollView.bounds.size.width, 80)];
    self.pageControl = pageControl;
    self.pageControl.numberOfPages = 4;//指定页面个数
    self.pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];// 设置非选中页的圆点颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.label];
}

//ScrollView滑动结束的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = (scrollView.contentOffset.x) / (self.view.bounds.size.width-10);
    self.pageControl.currentPage = currentPage;
    if (_pageControl.currentPage == 0) {
        [_label setText:@"Step1: Login or Register"];
    }
    else if (_pageControl.currentPage == 1){
        [_label setText:@"Step2: Add you todo list"];
    }
    else if (_pageControl.currentPage == 2) {
        [_label setText:@"Step3: Choose date and type something"];
    }
    else {
        [_label setText:@"Step4: View the whole list"];
    }
}

@end
