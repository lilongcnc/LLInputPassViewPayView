//
//  LLPassWordAlertView.m
//  LLPassWordInsertView
//
//  Created by 李龙 on 2017/5/26.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLPassWordAlertView.h"
#import "SLPasswordInputView.h"


#define LLColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


@interface LLPassWordAlertView ()<SLPasswordInputViewDelegate>

@property(nonatomic, assign, readonly)CGFloat screenW;
@property(nonatomic, assign, readonly)CGFloat screenH;
@property(nonatomic, assign, readonly)CGFloat contentW;
@property(nonatomic, assign, readonly)CGFloat contentH;


@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desStr;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIVisualEffectView *effectView;


@property (nonatomic,strong) UIButton *canelBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *topLineView;
@property (nonatomic,strong) UIImageView *bottomLineView;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) SLPasswordInputView *pwView;


@property (nonatomic,copy) FinishedBlock finish;

@property (nonatomic,assign) BOOL isVisual;

@end

@implementation LLPassWordAlertView


//-----------------------------------------------------------------------------------------------------------
#pragma mark attributes of frame
//-----------------------------------------------------------------------------------------------------------
static CGFloat const titleLabelTBMargin = 14;
static CGFloat const titleabelLTMargin = 16;

static CGFloat const desLabelTBMargin = 28;
static CGFloat const desLabelLTMargin = 16;

static CGFloat const pwViewMargin = 15;
static CGFloat const pwViewLTMargin = 16;
static CGFloat const bottomLineLTMargin = 10;


//-----------------------------------------------------------------------------------------------------------
#pragma mark init Views
//-----------------------------------------------------------------------------------------------------------
+ (void)showWithTitle:(NSString *)title desStr:(NSString *)desStr finish:(FinishedBlock)finish
{
    LLPassWordAlertView *pdView = [[LLPassWordAlertView alloc] initViewWithTitle:title desStr:desStr];
    pdView.finish = finish;
    [pdView show];
}

- (instancetype)initViewWithTitle:(NSString *)title desStr:(NSString *)desStr
{
    
    self = [super init];
    if (self) {
        
        self.title = title;
        self.desStr = desStr;
        
        self.frame = CGRectMake(0, 0, self.screenW, self.screenH);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        //is blur
        _isVisual = YES;

        [self setupCover];
        [self setupContent];
        [self modifyFrame];
    }

    
    return self;
}





//-----------------------------------------------------------------------------------------------------------
#pragma mark add Views
//-----------------------------------------------------------------------------------------------------------
- (void)setupCover
{
    [self addSubview:self.effectView];
}


- (void)setupContent
{
    //add contentView
    [self addSubview:self.contentView];
    
    //and subViews of contentView
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.canelBtn];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.pwView];
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc]init];
        _effectView.effect = nil;
        _effectView.frame = self.frame;
        _effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _effectView;
}


- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.contentW,self.contentH}];
        _contentView.center = self.center;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
    }
    
    return _contentView;
}



-(void)setIsVisual:(BOOL)isVisual
{
    _isVisual = isVisual;
    if (isVisual) {
        self.effectView.backgroundColor = [UIColor clearColor];
    }else {
//        self.effectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
        self.effectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
}


-(void)setTitle:(NSString *)title{
    
    _title = title;
    self.titleLabel.text = title;
    
    CGFloat labelX = 16;
    CGFloat labelY = titleLabelTBMargin;
    CGFloat labelW = self.contentW - 2*labelX;
    
    [self.titleLabel sizeToFit];
    CGSize size = self.titleLabel.frame.size;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, size.height);
}

-(void)setDesStr:(NSString *)desStr
{
    _desStr = desStr;
    
    CGFloat labelX = 16;
    CGFloat labelW = self.contentW - 2*labelX;
    
    self.desLabel.text = desStr;
    [self.desLabel sizeToFit];
    CGSize sizeMessage = self.desLabel.frame.size;
    self.desLabel.frame = CGRectMake(labelX, CGRectGetMaxY(self.titleLabel.frame) + titleLabelTBMargin + desLabelLTMargin, labelW, sizeMessage.height);
}



- (UILabel *)titleLabel
{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(titleabelLTMargin, titleLabelTBMargin, self.contentW-titleabelLTMargin*2, 0);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.backgroundColor = [UIColor blueColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        //高度为0,line=0,提前text赋值,则直接调用self.label.frame.size.height拿到当前height高度
        _desLabel.frame = CGRectMake(desLabelLTMargin, desLabelTBMargin, self.contentW-desLabelLTMargin*2, 0);
        _desLabel.numberOfLines = 2;
        _desLabel.textColor = [UIColor blackColor];
        _desLabel.textAlignment = NSTextAlignmentCenter;
//        _desLabel.backgroundColor = [UIColor cyanColor];
        _desLabel.font = [UIFont systemFontOfSize:23];
    }
    return _desLabel;
}


- (SLPasswordInputView *)pwView
{
    if (!_pwView) {
        
        CGFloat pwViewWidth = self.contentW - pwViewLTMargin*2;
        CGFloat pwViewWH = (pwViewWidth-2)/6;
        
        SLPasswordInputView *inputView = [[SLPasswordInputView alloc]
                                           initWithFrame:CGRectMake(pwViewLTMargin, CGRectGetMaxY(self.bottomLineView.frame)+pwViewMargin, pwViewWidth, pwViewWH)];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.delegate = self;
        inputView.passwordLength = 6;
        _pwView = inputView;
        
        [_pwView becomeFirstResponder];
    }
    return _pwView;
}


- (UIButton *)canelBtn
{
    if (!_canelBtn) {
        CGFloat cnacelWH = self.titleLabel.frame.size.height+titleLabelTBMargin*2;
        _canelBtn = [[UIButton alloc] initWithFrame:(CGRect){-5, 0, cnacelWH,cnacelWH }];
        [_canelBtn addTarget:self action:@selector(canelBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_canelBtn setImage:[UIImage imageNamed:@"LLPassWordAlertView.bundle/cancel"] forState:UIControlStateNormal];
    }
    return _canelBtn;
}


- (UIImageView *)topLineView
{
    if (!_topLineView) {
        
        _topLineView = [self setupLineIconView:(CGRect){0, CGRectGetMaxY(self.titleLabel.frame)+titleLabelTBMargin, self.contentW, 0.5} color:LLColor(117,202,119)];
        
    }
    return _topLineView;
}


- (UIImageView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [self setupLineIconView:(CGRect){bottomLineLTMargin, CGRectGetMaxY(self.desLabel.frame)+desLabelLTMargin, self.contentW-bottomLineLTMargin*2, 0.5} color:LLColor(171,171,171)];
    }
    return _bottomLineView;
}




//-----------------------------------------------------------------------------------------------------------
#pragma mark private methods
//-----------------------------------------------------------------------------------------------------------
- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.contentView.alpha = 0.0;
    [UIView animateWithDuration:0.34 animations:^{
        if (self.isVisual) {
            self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        }
        self.contentView.alpha = 1.0;
    }];
}

- (void)dismiss {

    [UIView animateWithDuration:0.3f animations:^{
        if (self.isVisual) {
            self.effectView.effect = nil;
        }
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (UIImageView *)setupLineIconView:(CGRect)rect color:(UIColor *)color
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [self imageWithColor:color];
    return imageView;
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark about frame
//-----------------------------------------------------------------------------------------------------------
- (void)modifyFrame
{
    [self setHeight:CGRectGetMaxY(self.pwView.frame) + 20 inView:self.contentView];
}


- (CGFloat)screenW{
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenH{
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGFloat)contentW{
    return 270;
}

- (CGFloat)contentH{
    return 88;
}



-(void)setHeight:(CGFloat)height inView:(UIView *)view
{
    CGRect changeRect = view.frame;
    changeRect.size.height = height;
    view.frame = changeRect;
}

-(void)setY:(CGFloat)y inView:(UIView *)view
{
    CGRect changeRect = view.frame;
    changeRect.origin.y = y;
    view.frame = changeRect;
}


//---------------------------------------------------------------------------------------------------------
#pragma mark  notification of keyboard
//---------------------------------------------------------------------------------------------------------
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")
- (void)TPKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification {
    //    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    
    NSLog(@"%@",NSStringFromCGRect(keyboardRect) );
    
    CGFloat newY = self.screenH - keyboardRect.size.height - CGRectGetHeight(self.contentView.frame) - 50;
    [self setY:newY inView:self.contentView];
    
}


//---------------------------------------------------------------------------------------------------------
#pragma mark  SLPasswordInputViewDelegate
//---------------------------------------------------------------------------------------------------------

- (void)passwordInputView:(SLPasswordInputView *)inputView willBeginInputWithPassword:(NSString *)password{
    NSLog(@"%s",__FUNCTION__);
    
}


- (void)passwordInputView:(SLPasswordInputView *)inputView didFinishInputWithPassword:(NSString *)password{
    NSLog(@"%s",__FUNCTION__);
    
    if (self.finish) {
        self.finish(password);
    }
    
    [inputView resignFirstResponder];
    
    [self dismiss];
    
}


//---------------------------------------------------------------------------------------------------------
#pragma mark  listener of canelBtn
//---------------------------------------------------------------------------------------------------------
- (void)canelBtnOnClick:(UIButton *)btn
{
    [self.pwView resignFirstResponder];
    
    [self dismiss];
}




-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


@end
