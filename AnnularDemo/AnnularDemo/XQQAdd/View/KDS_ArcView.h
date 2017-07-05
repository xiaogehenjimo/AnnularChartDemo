//
//  KDS_ArcView.h
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/6/28.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KDS_PercentType){
    KDS_PercentTypeDecimal = 0, //保留2位小数形式(默认)
    KDS_PercentTypeInteger      //取整数形式(四舍五入)
};

@interface KDS_ArcView : UIView

/** 取值类型 */
@property (nonatomic, assign)  KDS_PercentType   percentType;



/**
 设置数据

 @param valueArr 要显示的值
 @param titleArr 标题
 @param colorArr 颜色
 */
- (void)kds_setValueArr:(NSArray*)valueArr
               titleArr:(NSArray*)titleArr
               colorArr:(NSArray*)colorArr;


@end
