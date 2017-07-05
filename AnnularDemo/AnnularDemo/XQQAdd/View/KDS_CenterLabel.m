//
//  KDS_CenterLabel.m
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/7/3.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import "KDS_CenterLabel.h"
#import "UIView+KDS_FrameHelper.h"
#import "UIColor+KDS_HexToUIColor.h"

@interface KDS_CenterLabel ()

/** 中间类型label */
@property (nonatomic, strong)  UILabel  *  typeLabel;
/** 中间的数值label */
@property (nonatomic, strong)  UILabel  *  countLabel;


@end


@implementation KDS_CenterLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*.5)];
//        _typeLabel.backgroundColor = [UIColor orangeColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont boldSystemFontOfSize:17];
        _typeLabel.textColor = [UIColor blackColor];
        
        
        _countLabel = [[UILabel alloc]initWithFrame:_typeLabel.frame];
//        _countLabel.backgroundColor = [UIColor yellowColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.y = _typeLabel.bottom;
        
        [self addSubview:_typeLabel];
        [self addSubview:_countLabel];
        
        
    }
    return self;
}


- (void)setDataModel:(XQQModel *)dataModel{
    _dataModel = dataModel;
    _typeLabel.text = dataModel.typeStr;
    _typeLabel.textColor = [UIColor kds_colorWithHexString:dataModel.colorStr andAlpha:.5];
    _countLabel.text = [NSString stringWithFormat:@"%.2f(%@)",dataModel.value,dataModel.percentStr];
}

@end
