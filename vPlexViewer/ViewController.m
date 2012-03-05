//
//  ViewController.m
//  vPlexViewer
//
//  Created by Bischoff Tobias on 24.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import "ViewController.h"
#import "OverViewController.h"
#import "dataRequestor.h"
#import "aboutViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize rememberbtn;
@synthesize usernameField;
@synthesize passwdField;
@synthesize ipField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
      [[self navigationItem] setTitle:@"Login"];
    
    UIBarButtonItem *aboutItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(about:)];
    [[self navigationItem] setLeftBarButtonItem:aboutItem];
    
    
}

- (IBAction)about:(id)sender
{
    aboutViewController *avc = [[aboutViewController alloc] init];

    [avc setTitle:@"About"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:avc];
    [avc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
}


- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswdField:nil];
    [self setIpField:nil];
    [self setRememberbtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewDidAppear:(BOOL)animated    
{
    [super viewDidAppear:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs objectForKey:@"username"]) [usernameField setText:[prefs objectForKey:@"username"]];
    if ([prefs objectForKey:@"host"]) [ipField setText:[prefs objectForKey:@"host"]];
    
    
    if ([[prefs objectForKey:@"remstate"] isEqualToString:@"YES"]) {
        [passwdField setText:[prefs objectForKey:@"passwd"]];
        [rememberbtn setOn:YES]; 
       
    }
    
    [usernameField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)loginButton:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[usernameField text] forKey:@"username"];
    [prefs setObject:[ipField text] forKey:@"host"];
    
    if ([rememberbtn isOn]) {
        [prefs setObject:[passwdField text] forKey:@"passwd"];
        [prefs setObject:@"YES" forKey:@"remstate"];
    }
    
    
    dataRequestor *newdr = [[dataRequestor alloc] init];
    [newdr setUsername:[usernameField text]];
    [newdr setPassword:[passwdField text]];
    [newdr setIpaddress:[ipField text]];
    NSLog(@"user %@ passwd %@", [usernameField text], [passwdField text]);
    if (![newdr isReachable]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not good." message:@"I can't connect to your System."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
        [alert release];

        
    } else {
        
        OverViewController *ovc = [[OverViewController alloc] init];
        [ovc setDr:newdr];
        [[self navigationController] pushViewController:ovc animated:YES];

        
    }
    
}
- (void)dealloc {
    [rememberbtn release];
    [super dealloc];
}
@end
