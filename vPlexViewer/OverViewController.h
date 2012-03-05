//
//  OverViewController.h
//  vPlexViewer
//
//  Created by Bischoff Tobias on 24.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataRequestor.h"

@interface OverViewController : UIViewController
@property (nonatomic, retain) dataRequestor *dr; 
@property (retain, nonatomic) IBOutlet UILabel *cluster1nameField;
@property (retain, nonatomic) IBOutlet UILabel *cluster2nameField;
@property (retain, nonatomic) IBOutlet UILabel *c1opstatLabel;
@property (retain, nonatomic) IBOutlet UILabel *c1healthLabel;
@property (retain, nonatomic) IBOutlet UILabel *c2opstatLabel;
@property (retain, nonatomic) IBOutlet UILabel *c2healthLabel;
- (IBAction)c1physVolButton:(id)sender;
- (IBAction)c2physVolButton:(id)sender;
- (IBAction)c1extentsButton:(id)sender;
- (IBAction)c2extentsButton:(id)sender;
- (IBAction)c1vvButton:(id)sender;
- (IBAction)c2vvButton:(id)sender;
- (IBAction)distributedButton:(id)sender;
- (IBAction)cliButton:(id)sender;
- (IBAction)CReportButton:(id)sender;
@end
