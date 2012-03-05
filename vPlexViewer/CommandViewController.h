//
//  CommandViewController.h
//  vPlexViewer
//
//  Created by Bischoff Tobias on 26.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataRequestor.h"

@interface CommandViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) dataRequestor * dr;
@property (retain, nonatomic) IBOutlet UITextField *cmdField;
@property (retain, nonatomic) IBOutlet UITextField *argsField;
- (IBAction)sendButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *sendButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UITextView *output;

@end
