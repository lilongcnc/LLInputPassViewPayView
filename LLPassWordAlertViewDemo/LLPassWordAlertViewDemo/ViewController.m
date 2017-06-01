//
//  ViewController.m
//  LLPassWordAlertViewDemo
//
//  Created by 李龙 on 2017/5/31.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "LLPassWordAlertView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //_isVisual:  set if the backgroundView is visual,default is visual.
    [LLPassWordAlertView showWithTitle:@"验证密码" desStr:@"请输入支付密码" finish:^(NSString *pwStr) {
        
        NSLog(@"输入密码完成:%@",pwStr);
        
    }];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [LLPassWordAlertView showWithTitle:@"验证密码" desStr:@"请输入支付密码请输入支付密码请输入支付密码请输入支付密码请输入支付密码请输入支付密码请输入支付密码请输入支付密码请输入支付密码请输入支付密码" finish:^(NSString *pwStr) {
        
        NSLog(@"输入密码完成:%@",pwStr);
        
    }];
}



@end
