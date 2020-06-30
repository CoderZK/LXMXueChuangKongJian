//
//  LxmCommentView.m
//  OneYuanTuan
//
//  Created by 李晓满 on 15/12/9.
//  Copyright © 2015年 heJevon. All rights reserved.
//

#import "LxmCommentView.h"
#import "IQKeyboardManager.h"

@interface LxmCommentView ()<UITextFieldDelegate>
{
    void(^_okBlock)(NSString *str);
    UITextField * _tf;
    UIView * _toolBar;
    
    BOOL _isFaBiao;
}
@end

@implementation LxmCommentView

+(void)showWithOkBlock:(void(^)(NSString *str))okBlock
{
    LxmCommentView * view = [[LxmCommentView alloc] initWithOkBlock:okBlock];
    [view show];
}
-(instancetype)initWithOkBlock:(void(^)(NSString *str))okBlock
{
    if (self=[super initWithFrame:[UIScreen mainScreen].bounds])
    {
        
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        scrollView.scrollEnabled=NO;
        _okBlock = okBlock;
        
        UIButton * btn = [[UIButton alloc] initWithFrame:self.bounds];
        btn.tag=0;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        
        UIView * toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-60, self.bounds.size.width, 60)];
        _toolBar = toolBar;
        toolBar.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:toolBar];
        
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, self.bounds.size.width-70-15, 30)];
        _tf.placeholder=@"写下你的留言";
        _tf.text = [LxmTool ShareTool].commentStr;
        _tf.borderStyle = UITextBorderStyleRoundedRect;
        _tf.backgroundColor = [UIColor whiteColor];
        _tf.textColor=[UIColor darkGrayColor];
        _tf.returnKeyType = UIReturnKeySend;
        _tf.font = [UIFont systemFontOfSize:14];
        _tf.delegate=self;
        [toolBar addSubview:_tf];
        
        UIButton * sendbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-70, 0, 70, 60)];
        [sendbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sendbtn setTitle:@"发表" forState:UIControlStateNormal];
        sendbtn.tag=1;
        [sendbtn setBackgroundColor:[UIColor whiteColor]];
        [sendbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:sendbtn];
    }
    return self;
}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==1)
    {
        _isFaBiao = YES;
        if (_tf.text.length>0)
        {
            if (_okBlock)
            {
                _okBlock(_tf.text);
            }
            [_tf endEditing:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有输入留言内容!"];
        }
        
    }
    else if (btn.tag==0)
    {
       [_tf endEditing:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_tf.text.length>0)
    {
        if (_okBlock)
        {
            _okBlock(_tf.text);
            [LxmTool ShareTool].commentStr = _tf.text;
        }
        [_tf endEditing:YES];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self dismiss];
}
-(void)show
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [_tf becomeFirstResponder];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _toolBar.frame = CGRectMake(0, self.bounds.size.height-60-height, self.bounds.size.width, 60);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (_isFaBiao) {
        [LxmTool ShareTool].commentStr = @"";
    }else{
        [LxmTool ShareTool].commentStr = _tf.text;
    }
    
}

-(void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}
@end
