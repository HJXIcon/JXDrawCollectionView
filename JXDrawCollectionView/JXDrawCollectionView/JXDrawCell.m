//
//  JXDrawCell.m
//  JXDrawCollectionView
//
//  Created by mac on 17/4/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXDrawCell.h"

@interface JXDrawCell ()


@end
@implementation JXDrawCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.label = [[UILabel alloc]init];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.label];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat labelH = 40;
    
    self.label.frame = CGRectMake(0, (self.frame.size.height - labelH) * 0.5, self.frame.size.width, labelH);
    
}

@end
