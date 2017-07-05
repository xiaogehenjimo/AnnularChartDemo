//
//  KDS_ArcTranslucenceLayer.h
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/6/28.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface KDS_ArcTranslucenceLayer : CAShapeLayer

+ (instancetype)layerWithArcCenter:(CGPoint)center
                            radius:(CGFloat)radius
                        startAngle:(CGFloat)startAngle
                          endAngle:(CGFloat)endAngle
                         clockwise:(BOOL)clockwise;

- (instancetype)initWithArcCenter:(CGPoint)center
                           radius:(CGFloat)radius
                       startAngle:(CGFloat)startAngle
                         endAngle:(CGFloat)endAngle
                        clockwise:(BOOL)clockwise;

@end
