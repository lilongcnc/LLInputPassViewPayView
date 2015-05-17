//
//  LLINputPassWordView.h
//  BusinessAreaPlat
//
//  Created by 李龙 on 15/5/12.
//
//

#import <UIKit/UIKit.h>
@class LLINputPassWordView;

@protocol LLINputPassWordViewDelegate <NSObject>

/**
 取消当前view
 */
-(void)cannelInputPassWordView;
/**
 获取INputPassWordView的输入
 */
-(void)inputPassWordViewWith:(LLINputPassWordView *)dateView didSelectedPassWordString:(NSString *)dateStrig;

@end


@interface LLINputPassWordView : UIView

@property (weak, nonatomic) UITextField *myPassWordTF;

//代理
@property (nonatomic,assign) id<LLINputPassWordViewDelegate> deleagte;

/**
 *  快速构造方法
 *
 *  @return LLINputPassWordView
 */
+(instancetype)intputPassWordView;
/**
 *  显示这儿view
 */
-(void)show;
/**
 *  隐藏这个view
 */
-(void)dismiss;

@end
