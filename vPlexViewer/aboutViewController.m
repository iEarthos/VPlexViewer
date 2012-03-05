//
//  aboutViewController.m
//  vPlexViewer
//
//  Created by Bischoff Tobias on 26.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()

@end

@implementation aboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
    }
    return self;
}

- (IBAction)done:(id)sender

{
    [self dismissModalViewControllerAnimated:YES];
    
    //if ([delegate respondsToSelector:@selector(itemDetailViewControllerWillDismiss:)]) [delegate itemDetailViewControllerWillDismiss:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)contactme:(id)sender {
    
    NSString *mailString = [NSString stringWithFormat:@"mailto:tobias.bischoff@gmail.com"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
    NSLog(@"mailto angeklickt");
}
@end
