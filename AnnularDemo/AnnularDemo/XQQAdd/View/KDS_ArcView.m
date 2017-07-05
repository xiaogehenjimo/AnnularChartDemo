//
//  KDS_ArcView.m
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/6/28.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import "KDS_ArcView.h"
#import "KDS_ArcTranslucenceLayer.h"
#import "XQQModel.h"
#import "UIColor+KDS_HexToUIColor.h"
#import "KDS_CenterLabel.h"
#import "KDS_PieChartCell.h"
#import "UIView+KDS_FrameHelper.h"

/**
 *  角度求三角函数sin值
 *  @param a 角度
 */
#define KDS_Sin(a) sin(a / 180.f * M_PI)
/**
 *  角度转弧度
 *  @param angle 角度
 */
#define KDS_Radian(angle) (angle / 180.f * M_PI)
/**
 *  角度求三角函数cos值
 *  @param a 角度
 */
#define KDS_Cos(a) cos(a / 180.f * M_PI)

/**
 *  角度求三角函数tan值
 *  @param a 角度
 */
#define KDS_Tan(a) tan(a / 180.f * M_PI)

/**
 *  弧度转角度
 *  @param radian 弧度
 */
#define KDS_Angle(radian) (radian / M_PI * 180.f)

#define iPhoneWidth  [UIScreen mainScreen].bounds.size.width
#define iPhoneHeight [UIScreen mainScreen].bounds.size.height

@interface KDS_ArcView ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>

/** 总数 */
@property (nonatomic, assign)  CGFloat   totalValue;
/** 半径 */
@property (nonatomic, assign)  CGFloat radius;
/** 记录每个圆弧开始的角度 */
@property (nonatomic, assign)  CGFloat startAngle;
/** 圆环线宽 */
@property (nonatomic, assign)  CGFloat lineWidth;
/** 记录圆环中心 */
@property (nonatomic, assign)  CGPoint pieCenter;
/** 动画执行的时间 */
@property (nonatomic, assign)  NSInteger   animationTimeLength;

/** 存储数据model的数组 */
@property (nonatomic, strong)  NSMutableArray<XQQModel*>  *  dataArr;
/** 存储layer的数组 */
@property (nonatomic, strong)  NSMutableArray<KDS_ArcTranslucenceLayer*>  *  layerArr;
/** 存放当前点击的layer */
@property (nonatomic, strong)  NSMutableArray<KDS_ArcTranslucenceLayer*> *  removeArr;

/** 当前选中的色块index */
@property (nonatomic, assign)  NSInteger   selectedIndex;
/** 选中的layer */
@property (nonatomic, strong)  KDS_ArcTranslucenceLayer * big;
/** 中间的数值label */
@property (nonatomic, strong)  KDS_CenterLabel  *  centerLabel;



/** 列表 */
@property (nonatomic, strong)  UITableView  *  listView;

/** 动画执行的索引 */
@property (nonatomic, assign)  NSInteger   animationIndex;

@end

@implementation KDS_ArcView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
       
        //初始化参数
        
        _radius = 100;
        
        _lineWidth = 30;
        
        _animationTimeLength = 2;
        
        //中心点
        _pieCenter = CGPointMake(self.bounds.origin.x + self.bounds.size.width *.5, self.bounds.origin.y + _radius + _lineWidth);
        
        _startAngle = KDS_Radian(-90);
        
        _selectedIndex = -1;
        
        _centerLabel = [[KDS_CenterLabel alloc]initWithFrame:CGRectMake(0, 0, _radius * 2 - _lineWidth, 80)];
        
        [self addSubview:_centerLabel];
        
        _centerLabel.center = _pieCenter;
        
        [self addSubview:self.listView];
    }
    return self;
}


#pragma mark - activity

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self];

    //判断点击的是否在大圆
    BOOL isInBig = [self point:point inCircleRect:CGRectMake(_pieCenter.x - _radius - _lineWidth*.5, _pieCenter.y - _radius - _lineWidth*.5, _radius * 2 + _lineWidth, _radius * 2 + _lineWidth)];
    
    //判断是否在小圆
    BOOL isInSmall = [self point:point inCircleRect:CGRectMake(_pieCenter.x - _radius + _lineWidth*.5, _pieCenter.y - _radius + _lineWidth*.5, _radius*2 - _lineWidth, _radius*2 - _lineWidth)];
    
    //求弧度
    CGFloat x = (point.x - _pieCenter.x);
    CGFloat y = (point.y - _pieCenter.y);
    CGFloat radian = atan2(y, x);
    //当超过180度时，要加2π
    if (y < 0 && x < 0) {
        radian = radian + KDS_Radian(360);
    }
    
    //判断点击位置的角度在哪个path范围上
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        @autoreleasepool {
            XQQModel * model = [self.dataArr objectAtIndex:i];
            
            CGFloat startAngle = model.startAngle;
            
            CGFloat endAngle = model.endAngle;
            
            if (radian >= startAngle && radian < endAngle) {
                //点击的区域 在大圆里 不在小圆内  即 点击的是色块
                if (isInBig&&!isInSmall) {
                    //处理点击事件
                    [self kds_disportClickedWithIndex:i];
                    
                }
                return;
            }
        }
    }
}


/**
 处理点击事件

 @param index 点击的色块索引
 */
- (void)kds_disportClickedWithIndex:(NSInteger)index{
    
    XQQModel * model = [self.dataArr objectAtIndex:index];
    
    if (_selectedIndex == index){
        [self.big removeFromSuperlayer];
        [self.layer addSublayer:self.removeArr.firstObject];
        [self.removeArr removeAllObjects];
        _selectedIndex = -1;
        return;
    };
    //点击了别处的 恢复上一次点击的layer
    [self.layer addSublayer:self.removeArr.firstObject];
    
    [self.removeArr removeAllObjects];
    
    //如果存在点击的layer 移除点击添加的layer
    if (_big) [_big removeFromSuperlayer];
    
    //找到当前点击的layer
    KDS_ArcTranslucenceLayer * layer = [self.layerArr objectAtIndex:index];
    
    //把当前的layer 从self中移动到 删除的数组中
    [self.removeArr addObject:layer];
    
    [layer removeFromSuperlayer];
    
    //同时添加一个 半径 大于 当前半径的 同样的颜色layer到self.layer上
    _big = [self kds_createSelectedLayerWithModel:model];
    
    //修改中间显示的标题
    _centerLabel.dataModel = model;
    
    [self.layer addSublayer:_big];
    
    _selectedIndex = index;
}

/**
 开始绘制环形图
 */
- (void)kds_stock{
    
    for (NSInteger i = 0; i < self.dataArr.count; i ++) {
        @autoreleasepool {
            XQQModel * model = [self.dataArr objectAtIndex:i];
            
            KDS_ArcTranslucenceLayer * layer = [KDS_ArcTranslucenceLayer layerWithArcCenter:_pieCenter radius:_radius startAngle:model.startAngle endAngle:model.endAngle clockwise:YES];
            
            layer.strokeColor = [UIColor kds_colorWithHexString:model.colorStr].CGColor;
            
            layer.lineWidth = _lineWidth;
            
            if (i == 0) {
                [layer addAnimation:[self kds_getAnimationWithDuration:[model.percentStr floatValue] * _animationTimeLength/100] forKey:nil];
                [self.layer addSublayer:layer];
                _animationIndex = 0;
            }
            
            [self.layerArr addObject:layer];
        }
    }
    
    self.listView.height = self.dataArr.count * 49.0f;
    
    self.height = self.listView.bottom;
    
    [self.listView reloadData];
    
}


#pragma mark - CAAnimationDelegate

/** 动画执行结束 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _animationIndex++;
    
    //动画的总时间为4s
    if (_animationIndex > self.layerArr.count - 1){
        [self kds_disportClickedWithIndex:1];
        return;
    }
    
    KDS_ArcTranslucenceLayer * layer = [self.layerArr objectAtIndex:_animationIndex];
    
    [layer addAnimation:[self kds_getAnimationWithDuration:[[self.dataArr[_animationIndex] percentStr] floatValue]*_animationTimeLength/100] forKey:nil];
    
    [self.layer addSublayer:layer];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KDS_PieChartCell * cell = [KDS_PieChartCell kds_cellWithTableView:tableView indexPath:indexPath];
    cell.dataModel = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.f;
}

#pragma mark - set


/**
 设置数据
 
 @param valueArr 要显示的值
 @param titleArr 标题
 @param colorArr 颜色
 */
- (void)kds_setValueArr:(NSArray*)valueArr
               titleArr:(NSArray*)titleArr
               colorArr:(NSArray*)colorArr{
    
    //求最大值
    NSNumber *sum = [valueArr valueForKeyPath:@"@sum.floatValue"];
    
    _totalValue = sum.floatValue;
    
    for (NSInteger i = 0; i <  valueArr.count; i ++) {
        
        @autoreleasepool {
            CGFloat subAngle = [self countAngle:[valueArr[i] floatValue]];
            
            XQQModel * model = [[XQQModel alloc]init];
            
            model.percentStr = [self getPercent:[valueArr[i] floatValue]];
            
            model.startAngle = _startAngle;
            
            model.endAngle = _startAngle + subAngle;
            
            model.countStr = [NSString stringWithFormat:@"%.2f",[valueArr[i] floatValue]];
            model.colorStr = colorArr[i];
            
            model.value = [valueArr[i] floatValue];
            
            model.typeStr = titleArr[i];
            
            model.centerPoint = [self getBezierPathCenterPointWithStartAngle:model.startAngle endAngle:model.endAngle];
            
            _startAngle = model.endAngle;
            
            [self.dataArr addObject:model];
        }
        
    }
    [self kds_stock];
}


/**
 根据动画时间获取动画

 @param duration 动画时间
 @return 动画
 */
- (CABasicAnimation*)kds_getAnimationWithDuration:(CGFloat)duration{
    
    CABasicAnimation * lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    lineAnimation.delegate = self;
    
    lineAnimation.duration = duration;
    
    lineAnimation.fromValue = [NSNumber numberWithFloat:0];
    
    lineAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    return lineAnimation;
}


#pragma mark - get


/**
 创建选中的layer

 @param model 选中的色块模型
 @return layer
 */
- (KDS_ArcTranslucenceLayer*)kds_createSelectedLayerWithModel:(XQQModel*)model{
    
    CGFloat offset = 10;//往圆外挪动的距离
    
    KDS_ArcTranslucenceLayer * layer = [KDS_ArcTranslucenceLayer layerWithArcCenter:_pieCenter radius:_radius + offset startAngle:model.startAngle endAngle:model.endAngle clockwise:YES];
    
    layer.strokeColor = [UIColor kds_colorWithHexString:model.colorStr].CGColor;
    
    layer.lineWidth = _lineWidth;
    
    return layer;
}


/**
 *  计算每个item所占角度大小
 *
 *  @param value 每个item的value
 *
 *  @return 返回角度大小
 */
- (CGFloat)countAngle:(CGFloat)value{
    //计算百分比
    CGFloat percent = value / _totalValue;
    //需要多少度的圆弧
    CGFloat angle = M_PI * 2 * percent;
    return angle;
}

/**
 *  计算百分比
 *
 *  @return NSString
 */
- (NSString *)getPercent:(CGFloat)value{
    CGFloat percent = value / _totalValue * 100;
    NSString * string;
    if (self.percentType == KDS_PercentTypeDecimal) {
        string = [NSString stringWithFormat:@"%.2f%%",percent];
    }else if (self.percentType == KDS_PercentTypeInteger){
        string = [NSString stringWithFormat:@"%d%%",(int)roundf(percent)];
    }
    return string;
}

/**
 *  获取每个path的中心点
 *
 *  @return CGFloat
 */
- (CGPoint)getBezierPathCenterPointWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle{
    //一半角度(弧度)
    CGFloat halfAngle = (endAngle - startAngle) *.5;
    //中心角度(弧度)
    CGFloat centerAngle = halfAngle + startAngle;
    //中心角度(角度)
    CGFloat realAngle = KDS_Angle(centerAngle);
    
    CGFloat center_xPos = KDS_Cos(realAngle) * _radius + _pieCenter.x;
    CGFloat center_yPos = KDS_Sin(realAngle) * _radius + _pieCenter.y;
    
    return CGPointMake(center_xPos, center_yPos);
}


/**
 判断点击的点是否在圆里

 @param point 点击的点
 @param rect 区域
 @return YES or NO
 */
- (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect {
    CGFloat radius = rect.size.width/2.0;
    CGPoint center = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double dis = hypot(dx, dy);
    return dis <= radius;
}

- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc]initWithFrame:CGRectMake(0, _pieCenter.y + _radius + _lineWidth, iPhoneWidth, 6 * 49) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.scrollEnabled = NO;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor yellowColor];
    }
    return _listView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (NSMutableArray *)layerArr{
    if (!_layerArr) {
        _layerArr = @[].mutableCopy;
    }
    return _layerArr;
}

- (NSMutableArray<KDS_ArcTranslucenceLayer *> *)removeArr{
    if (!_removeArr) {
        _removeArr = @[].mutableCopy;
    }
    return _removeArr;
}
- (void)dealloc{
    NSLog(@"销毁了");
}
@end
