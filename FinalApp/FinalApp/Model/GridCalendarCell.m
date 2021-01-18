//
//  GridCalendarCell.m
//  FinalApp
//
//  Created by 祥哥 on 2019/12/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridCalendarCell.h"

@implementation GridCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blueColor];
        [self setupUI];
    }
    return self;
}

-(void) setupUI{
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.textLabel];
}

@end
