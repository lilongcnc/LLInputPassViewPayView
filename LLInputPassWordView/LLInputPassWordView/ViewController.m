//
//  ViewController.m
//  LLInputPassWordView
//
//  Created by 李龙 on 15/5/17.
//  Copyright (c) 2015年 Lauren. All rights reserved.
//

#import "ViewController.h"
#import "LLINputPassWordView.h"

@interface ViewController ()<LLINputPassWordViewDelegate>{
     LLINputPassWordView *inputPWView;
}
@end


@implementation ViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //初始ihuamima输入框
    LLINputPassWordView *inputView = [LLINputPassWordView intputPassWordView];
    inputView.deleagte = self;
    inputPWView = inputView;
}


- (IBAction)submitBtnonClick:(id)sender {
    [inputPWView show];
}

#pragma mark LLINputPassWordViewDelegate方法
/**
 取消当前view
 */
-(void)cannelInputPassWordView{

    [inputPWView dismiss];
}

/**
 获取INputPassWordView的输入
 */
-(void)inputPassWordViewWith:(LLINputPassWordView *)dateView didSelectedPassWordString:(NSString *)dateStrig{
    
        
        //记录用户传入的密码
        NSString *passwordString = dateStrig;
        NSLog(@"您输入的密码是:%@",passwordString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
