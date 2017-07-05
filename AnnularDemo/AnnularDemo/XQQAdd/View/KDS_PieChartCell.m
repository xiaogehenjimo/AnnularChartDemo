//
//  KDS_PieChartCell.m
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/7/4.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import "KDS_PieChartCell.h"
#import "UIView+KDS_FrameHelper.h"
#import "XQQModel.h"
#import <Masonry.h>
#import "UIColor+KDS_HexToUIColor.h"

@interface KDS_PieChartCell ()

/** 左侧类型的View */
@property (nonatomic, strong)  UIView  *  typeView;
/** 名字label */
@property (nonatomic, strong)  UILabel  *  nameLabel;
/** 数值label */
@property (nonatomic, strong)  UILabel  *  countLabel;
/** 右侧箭头 */
@property (nonatomic, strong)  UIImageView  *  rightImageView;

@end

@implementation KDS_PieChartCell

+ (instancetype)kds_cellWithTableView:(UITableView*)tableView
                            indexPath:(NSIndexPath*)indexPath{
    
    static NSString * kds_pieCellStr = @"kds_pieCellID";
    KDS_PieChartCell * cell = [tableView dequeueReusableCellWithIdentifier:kds_pieCellStr];
    if (!cell) {
        cell = [[KDS_PieChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kds_pieCellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _typeView = [[UIView alloc]init];
        _typeView.layer.cornerRadius = 4;
        _typeView.layer.masksToBounds = YES;
        
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.text = @"heheda";
        [_nameLabel sizeToFit];
        
        _countLabel = [[UILabel alloc]init];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.font = [UIFont systemFontOfSize:16];
        _countLabel.text = @"fggggggeerggg";
        
        
        _rightImageView = [[UIImageView alloc]init];
        
        _rightImageView.image = [[UIImage imageNamed:@"YKFX_Arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        [self.contentView addSubview:_typeView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_countLabel];
        [self.contentView addSubview:_rightImageView];
        [self setAutoLayout];
        
//        _rightImageView.backgroundColor = [UIColor greenColor];
//        _countLabel.backgroundColor = [UIColor blueColor];
//        _nameLabel.backgroundColor = [UIColor yellowColor];
//        _typeView.backgroundColor = [UIColor orangeColor];
        
    }
    return self;
}


- (void)setAutoLayout{
    CGFloat leftPanding = 20;
    //49高度
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(leftPanding);
        make.top.equalTo(self).mas_offset(15);
        make.bottom.equalTo(self).mas_offset(-15);
        make.width.mas_equalTo(20);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeView.mas_right).mas_offset(5);
        make.top.equalTo(self).mas_offset(5);
        make.bottom.equalTo(self).mas_offset(-5);
    }];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(17);
        make.bottom.equalTo(self).mas_offset(-17);
        make.right.equalTo(self).mas_offset(-5);
        make.width.mas_offset(10);
    }];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(5);
        make.bottom.equalTo(self).mas_offset(-5);
        make.right.equalTo(self.rightImageView.mas_left).mas_offset(-5);
        make.left.equalTo(self.nameLabel.mas_right).mas_offset(5);
    }];
}


#pragma mark - set

- (void)setDataModel:(XQQModel *)dataModel{
    _dataModel = dataModel;
    
    _typeView.layer.backgroundColor = [UIColor kds_colorWithHexString:dataModel.colorStr andAlpha:.5].CGColor;
    
    _nameLabel.text = dataModel.typeStr;
    
    _countLabel.text = [NSString stringWithFormat:@"%.2f(%@)",dataModel.value,dataModel.percentStr];
    
}

#pragma mark - get




@end
