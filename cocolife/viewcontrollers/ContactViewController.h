//
//  ContactViewController.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCocoViewController.h"

typedef void(^onSendContact_t)(NSString* name, NSString* mailAddress, NSString* contact);

@interface ContactViewController : AbstractCocoViewController<
UITextFieldDelegate
, UITextViewDelegate
>{
    // callbacks
    onSendContact_t onSendContact;
    
    // views
    UIImageView* bg;
    UITextField* nameField;
    UITextField* mailField;
    UITextView* contentField;
    UIScrollView* sv;
}

@property (strong) onSendContact_t onSendContact;
-(void) resetForm;

@end
