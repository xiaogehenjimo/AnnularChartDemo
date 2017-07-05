//
//  XQQModel.h
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/7/3.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XQQModel : NSObject
/** 起点弧度 */
@property (nonatomic, assign)  CGFloat   startAngle;
/** 终点弧度 */
@property (nonatomic, assign)  CGFloat   endAngle;
/** 显示的数字 */
@property (nonatomic, copy)    NSString  *  countStr;
/** 颜色 */
@property (nonatomic, copy)    NSString  *  colorStr;
/** 数值 */
@property (nonatomic, assign)  CGFloat   value;
/** 类型 */
@property (nonatomic, copy)    NSString  *  typeStr;
/** 每一个弧线中心点 */
@property (nonatomic, assign)  CGPoint   centerPoint;
/** 所占百分比 */
@property (nonatomic, copy)    NSString  *  percentStr;

@end
