//
//  CReportViewController.h
//  vPlexViewer
//
//  Created by Bischoff Tobias on 01.03.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataRequestor.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface CReportViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UIButton *genButton;
@property (nonatomic, retain) dataRequestor * dr;
- (IBAction)genButton:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *progressLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UITextView *contentTView;
@property (retain, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *printButton;
- (IBAction)printButton:(id)sender;
@end
