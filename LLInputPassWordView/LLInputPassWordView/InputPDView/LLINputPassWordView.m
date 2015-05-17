//
//  LLINputPassWordView.m
//  BusinessAreaPlat
//
//  Created by 李龙 on 15/5/12.
//
//

#import "LLINputPassWordView.h"
#import "LLCover.h"

#define LLKeyWindow [UIApplication sharedApplication].keyWindow

@interface LLINputPassWordView ()<UITextFieldDelegate>{
   
    NSString *pwString;

    
    //记录点击的下标
    int count;
}

@property (weak, nonatomic) LLINputPassWordView *showPassWordView;
@property (weak, nonatomic) IBOutlet UIView *inputPWView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *pwView;

//textField密码输入框
@property (weak, nonatomic) IBOutlet UITextField *textFielld1;
@property (weak, nonatomic) IBOutlet UITextField *textFielld2;
@property (weak, nonatomic) IBOutlet UITextField *textFielld3;
@property (weak, nonatomic) IBOutlet UITextField *textFielld4;
@property (weak, nonatomic) IBOutlet UITextField *textFielld5;
@property (weak, nonatomic) IBOutlet UITextField *textFielld6;

@property (strong, nonatomic) NSArray *textFieldArray;

@end


@implementation LLINputPassWordView

/**
 *  显示这儿view
 */
-(void)show{
    [LLCover show];
    [UIView animateWithDuration:0.3 animations:^{
        _showPassWordView.hidden = NO;
        [_showPassWordView.myPassWordTF becomeFirstResponder];
        [LLKeyWindow bringSubviewToFront:_showPassWordView];
    }];
}
/**
 *  隐藏这个view
 */
-(void)dismiss{
    [LLCover dismiss];
    [UIView animateWithDuration:0.3 animations:^{
        _showPassWordView.hidden = YES;
        [_showPassWordView.myPassWordTF endEditing:NO];
    }];
    
    [self cleanView];
}



+(instancetype)intputPassWordView{
    LLINputPassWordView *view = [[NSBundle mainBundle] loadNibNamed:@"LLINputPassWordView" owner:nil options:nil][0];
    
    view.showPassWordView = view;
    
    view.inputPWView.layer.cornerRadius = 5;
    view.inputPWView.layer.masksToBounds = YES;
    
    view.pwView.layer.borderWidth = 1.0;
    view.pwView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    //初始化内部接收密码输入框
     UITextField *tx =[[UITextField alloc] initWithFrame:CGRectMake(0, -100, 100, 100)];
    tx.text = @"";
    tx.keyboardType = UIKeyboardTypeNumberPad;
    tx.delegate = view;
    view.myPassWordTF = tx;
    [view.myPassWordTF addTarget:view action:@selector(pwTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];//添加键盘监听
    [view addSubview:tx];
    
    //存取所有的输入框
    NSArray *array = [NSArray arrayWithObjects:view.textFielld1,view.textFielld2,view.textFielld3,view.textFielld4,view.textFielld5,view.textFielld6, nil];
    view.textFieldArray = array;
    
    CGRect myRect = view.frame;
    myRect.origin.y = 120;
    myRect.origin.x = (LLKeyWindow.frame.size.width - view.frame.size.width) * 0.5;
    view.frame = myRect;
    
    //设置圆角
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    
    [LLKeyWindow addSubview:view];
    return view;
}

-(void)pwTextFieldDidChange:(UITextField *)sender
{
    if(sender.text.length < 7){
        //记录六位密码
        pwString = sender.text;
    }
}

-(void)changePWTextFielShow{
    if(count == 0){
        //清空输入框重新开始
        self.myPassWordTF.text = @"";
        //清空用于记录上传的密码
        pwString = @"";
        
        //确定按钮
        self.submitBtn.enabled = NO;
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    }
    for (int i = 0; i < 6; i++) {
        UITextField *pwTF = self.textFieldArray[i];
        pwTF.text = @"";
    }
    for (int i = 0; i < count; i++) {
        UITextField *pwTF = self.textFieldArray[i];
        pwTF.text = @"•";
    }
}



#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        int stringLength = (int)textField.text.length + 1;
        if([string length] != 0)
        {
            NSLog(@"点击了非删除键");
            if(stringLength > 0 && stringLength < 7){
                count++;
                [self changePWTextFielShow];
                //确定按钮
                self.submitBtn.enabled = YES;
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"submit_1"] forState:UIControlStateNormal];
            }
        }
        else
        {
            NSLog(@"点击了删除键");
            if (count > 0) {
                count--;
                //清空用于记录上传的密码
                pwString = @"";
                [self changePWTextFielShow];
            }
        }
    return YES;
}

- (IBAction)cannelBtnOnClick:(id)sender {
    //执行代理方法
    if ([self.deleagte respondsToSelector:@selector(cannelInputPassWordView)]) {
        [self.deleagte cannelInputPassWordView];
    }
}

- (IBAction)submitBtnOnClick:(id)sender {
    NSLog(@"获取用户输入密码:%@",pwString);
    if (pwString.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入密码长度不够,请输入六位数字支付密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }else{
        //退下键盘
        [self.myPassWordTF endEditing:YES];
        if ([self.deleagte respondsToSelector:@selector(inputPassWordViewWith:didSelectedPassWordString:)]) {
            [self.deleagte inputPassWordViewWith:self didSelectedPassWordString:pwString];
        }
        //隐藏当前view
        [self dismiss];
        [self cleanView];
    }
}

/**清空所有重新开始*/
-(void)cleanView{
    //清空输入框重新开始
    self.myPassWordTF.text = @"";
    //清空用于记录上传的密码
    pwString = @"";
    count = 0;
    
    //清空输入框
    for (int i = 0; i < 6; i++) {
        UITextField *pwTF = self.textFieldArray[i];
        pwTF.text = @"";
    }
    //销毁创建的view
//    [_showPassWordView removeFromSuperview];
}


@end
