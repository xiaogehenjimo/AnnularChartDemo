//
//  KDS_PieChartCell.h
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/7/4.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XQQModel;

@interface KDS_PieChartCell : UITableViewCell

/** 数据模型 */
@property (nonatomic, strong)  XQQModel  *  dataModel;


+ (instancetype)kds_cellWithTableView:(UITableView*)tableView
                            indexPath:(NSIndexPath*)indexPath;

@end
