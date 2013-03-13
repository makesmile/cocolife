//
//  ContactViewController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "ContactViewController.h"
#import "Mediator.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

@synthesize onSendContact;

-(void) initialize{
    [self setNaviTitle];
    [self setViews];
}

-(void) setNaviTitle{
    UIImageView* titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contactTitle"]];
    self.navigationItem.titleView = titleImage;
}

-(void) setViews{
    sv = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    NSLog(@"windowHeight:%f", windowHeight);
    
    float topMargin = (windowHeight > 480) ? 50 : 0;
    sv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:sv];
    
    // スクリーンサイズで切り替え
    UIImageView* contactBgView;
    float nameTFY;
    float mailTFY;
    float contentTFY;
    float sendButtonY;
    float contentTFHeight;
    if(windowHeight > 480){
        contactBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contactBg-568h"]];
        contactBgView.frame = CGRectMake(0, 0, 320, 481.0f);
        nameTFY = 104;
        mailTFY = 147;
        contentTFY = 215;
        contentTFHeight = 120;
        sendButtonY =360;
    }else{
        contactBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contactBg"]];
        contactBgView.frame = CGRectMake(0, 0, 320, 419);
        nameTFY = 96.0f;
        mailTFY = 135.0f;
        contentTFY = 195;
        contentTFHeight = 70;
        sendButtonY =283;
    }
    
    [sv addSubview:contactBgView];
    
    float currentY = 30.5f;
    
    //    UIColor* inputBgColor = UIColorFromHex(0xFFE2CA);
    UIColor* inputBgColor = [UIColor clearColor];
    UIFont* inputFont = [UIFont boldSystemFontOfSize:12.0f];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(85, nameTFY, 210, 18)];
    nameField.textColor = UIColorFromHex(0x331300);
    nameField.backgroundColor = inputBgColor;
    nameField.delegate = self;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.font = inputFont;
    [sv addSubview:nameField];
    currentY += 10;
    
    mailField = [[UITextField alloc] initWithFrame:CGRectMake(85, mailTFY, 210, 18)];
    mailField.textColor = UIColorFromHex(0x331300);
    mailField.backgroundColor = inputBgColor;
    mailField.delegate = self;
    mailField.returnKeyType = UIReturnKeyDone;
    mailField.font = inputFont;
    [sv addSubview:mailField];
    //    currentY += mailLabel.frame.size.height;
    currentY += 10;

    contentField = [[UITextView alloc] initWithFrame:CGRectMake(20, contentTFY, 280, contentTFHeight)];
    [sv addSubview:contentField];
    contentField.textColor = UIColorFromHex(0x331300);
    contentField.delegate = self;
    contentField.font = inputFont;
    contentField.backgroundColor = inputBgColor;
    UIView* accessoryView =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
    UIView* accessoryViewContents = [[UIView alloc] initWithFrame:CGRectMake(320-120,0,120,50)];
    accessoryView.backgroundColor= [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    // ボタンを作成する。
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10,10,110,30);
    [closeButton setTitle:@"完了" forState:UIControlStateNormal];
    // ボタンを押したときによばれる動作を設定する。
    [closeButton addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    // ボタンをViewに貼る
    [accessoryViewContents addSubview:closeButton];
    [accessoryView addSubview:accessoryViewContents];
    contentField.inputAccessoryView = accessoryView;
    currentY += contentField.frame.size.height;
    currentY += 10;
    
    // 送信ボタン
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(windowHeight > 480){
        sendButton.frame = CGRectMake(104, sendButtonY, 116,62.5f);
        [sendButton setImage:[UIImage imageNamed:@"contactSendButton-568h"] forState:UIControlStateNormal];
    }else{
        sendButton.frame = CGRectMake(97, sendButtonY, 116,62.5f);
        [sendButton setImage:[UIImage imageNamed:@"contactSendButton"] forState:UIControlStateNormal];
    }
    [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:sendButton];
    currentY += sendButton.frame.size.height;
    
    // 背景フレーム調整
    //    bg.frame = CGRectMake(7, 25, 306, currentY);
    
    sv.contentSize = CGSizeMake(320, currentY+40);
}

-(void)closeKeyboard{
    [contentField resignFirstResponder];
}

-(void) onSend{
    if([nameField.text length] == 0){
        [mediator showToast:@"お名前は必須です"];
        return;
    }else if([mailField.text length] == 0){
        [mediator showToast:@"メールアドレスは必須です"];
        return;
    }else if([contentField.text length] == 0){
        [mediator showToast:@"内容は必須です"];
        return;
    }
    
    if(onSendContact)
        onSendContact(nameField.text, mailField.text, contentField.text);
//    [callbackObject onContactSend:nameField.text mailAddress:mailField.text content:contentField.text];
}

// ▼ UITextFieldDelegate =====================================

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    sv.scrollEnabled = NO;
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = -50 + sv.contentOffset.y;
    self.view.frame = currentFrame;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    sv.scrollEnabled = YES;
    [textField resignFirstResponder];
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = 0;
    self.view.frame = currentFrame;
    return YES;
}

// ▼ UITextViewDelegate =======================================

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    sv.scrollEnabled = NO;
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = (windowHeight > 480) ? -110 : -150;
    self.view.frame = currentFrame;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    sv.scrollEnabled = YES;
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = 0;
    self.view.frame = currentFrame;
    
    return YES;
}

// ▼ public ========================================

-(void) resetForm{
    nameField.text = @"";
    mailField.text = @"";
    contentField.text = @"";
}

@end
