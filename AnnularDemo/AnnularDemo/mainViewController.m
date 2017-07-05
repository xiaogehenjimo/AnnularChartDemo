//
//  mainViewController.m
//  AnnularDemo
//
//  Created by xuqinqiang on 2017/7/5.
//  Copyright © 2017年 Camelot.com. All rights reserved.
//

#import "mainViewController.h"
#import "ViewController.h"


@interface mainViewController ()

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 44)];
    button.backgroundColor = [UIColor yellowColor];
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)buttonAction{
    ViewController * vc = [[ViewController alloc]init];
    
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
