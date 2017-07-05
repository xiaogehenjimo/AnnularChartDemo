//
//  KDS_ArcTranslucenceLayer.m
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/6/28.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import "KDS_ArcTranslucenceLayer.h"

@implementation KDS_ArcTranslucenceLayer

+ (instancetype)layerWithArcCenter:(CGPoint)center
                            radius:(CGFloat)radius
                        startAngle:(CGFloat)startAngle
                          endAngle:(CGFloat)endAngle
                         clockwise:(BOOL)clockwise{
    
    return [[KDS_ArcTranslucenceLayer alloc] initWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:clockwise];
}

- (instancetype)initWithArcCenter:(CGPoint)center
                           radius:(CGFloat)radius
                       startAngle:(CGFloat)startAngle
                         endAngle:(CGFloat)endAngle
                        clockwise:(BOOL)clockwise{
    self = [super init];
    if (self) {
        self.fillColor = nil;
        self.opacity = 0.5f;
        self.path = [self translucencePathWithArcCenter:center
                                                 radius:radius
                                             startAngle:startAngle
                                               endAngle:endAngle
                                              clockwise:clockwise].CGPath;
    }
    return self;
}

- (UIBezierPath *)translucencePathWithArcCenter:(CGPoint)center
                                         radius:(CGFloat)radius
                                     startAngle:(CGFloat)startAngle
                                       endAngle:(CGFloat)endAngle
                                      clockwise:(BOOL)clockwise{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return bezierPath;
}

@end
