//
//  ViewController.m
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/6/28.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import "ViewController.h"
#import "KDS_ArcView.h"
#import "UIView+KDS_FrameHelper.h"

#define iPhoneWidth  [UIScreen mainScreen].bounds.size.width
#define iPhoneHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

/** 背部滑动视图 */
@property (nonatomic, strong)  UIScrollView  *  backScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

- (void)initUI{
    
    self.navigationItem.title = @"我的资产";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight - 64)];
    _backScrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:245/255.0 blue:248/255.0 alpha:1];
    _backScrollView.contentSize = CGSizeMake(iPhoneWidth, 1000);
    
    [self.view addSubview:_backScrollView];
    
//    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, iPhoneWidth, 80)];
//    topView.backgroundColor = [UIColor yellowColor];
    
//    [_backScrollView addSubview:topView];
    
    /** 环形图 */
    KDS_ArcView * arcView = [[KDS_ArcView alloc]initWithFrame:CGRectMake(0, 10, iPhoneWidth, 560)];
    
    [_backScrollView addSubview:arcView];
    
    NSArray * colorArr = @[@"ff0066",@"9900ff",@"330033",@"33ff99",@"cc6600",@"#EEB422"];
    
    NSArray * titleArr = @[@"股票",@"债券",@"基金",@"理财",@"现金余额",@"其他"];
    
    [arcView kds_setValueArr:@[@2398,@2123,@3423,@1298,@4323]
                    titleArr:titleArr
                    colorArr:colorArr];
    
}


#pragma mark - UITableViewDelegate






@end
