//
//  ViewController.h
//  vPlexViewer
//
//  Created by Bischoff Tobias on 24.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *usernameField;
@property (retain, nonatomic) IBOutlet UITextField *passwdField;
@property (retain, nonatomic) IBOutlet UITextField *ipField;
- (IBAction)loginButton:(id)sender;
@property (retain, nonatomic) IBOutlet UISwitch *rememberbtn;

@end
