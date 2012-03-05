//
//  OverViewController.m
//  vPlexViewer
//
//  Created by Bischoff Tobias on 24.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import "OverViewController.h"
#import "ListViewController.h"
#import "CommandViewController.h"
#import "CReportViewController.h"

@interface OverViewController ()

@end

@implementation OverViewController

@synthesize dr;
@synthesize cluster1nameField;
@synthesize cluster2nameField;
@synthesize c1opstatLabel;
@synthesize c1healthLabel;
@synthesize c2opstatLabel;
@synthesize c2healthLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dr = [[dataRequestor alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [[self navigationItem] setTitle:@"System Status: EMC VPlex Metro"];
}

- (void)viewDidUnload
{
    [self setCluster1nameField:nil];
    [self setCluster2nameField:nil];
    [self setC1opstatLabel:nil];
    [self setC1healthLabel:nil];
    [self setC2opstatLabel:nil];
    [self setC2healthLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated  
{
    NSArray *cnames = [dr getClusternames];
    
    [cluster1nameField setText:[cnames objectAtIndex:0]];
    [cluster2nameField setText:[cnames objectAtIndex:1]];
    
    NSArray * c1stats = [dr getStatusForCluster:[cnames objectAtIndex:0]];
    
    [c1opstatLabel setText:[c1stats objectAtIndex:0]];
    [c1healthLabel setText:[c1stats objectAtIndex:1]];
    
    NSArray * c2stats = [dr getStatusForCluster:[cnames objectAtIndex:1]];
    
    [c2opstatLabel setText:[c2stats objectAtIndex:0]];
    [c2healthLabel setText:[c2stats objectAtIndex:1]];

    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [c1opstatLabel release];
    [c1healthLabel release];
    [c2opstatLabel release];
    [c2healthLabel release];
    [super dealloc];
}
- (IBAction)c1physVolButton:(id)sender {
    
    NSArray *cnames = [dr getClusternames];
    
    NSArray *physvols = [dr getPhysvolsForCluster:[cnames objectAtIndex:0]];
    
    ListViewController *lvc = [[ListViewController alloc] init];
    [lvc setInhalt:physvols];
    
    NSString * wintitle = [NSString stringWithFormat:@"%@ Physical Volume List", [cnames objectAtIndex:0]];
    [lvc setTitle:wintitle];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [lvc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
    
}

- (IBAction)c2physVolButton:(id)sender {
    
    NSArray *cnames = [dr getClusternames];
    
    NSArray *physvols = [dr getPhysvolsForCluster:[cnames objectAtIndex:1]];
    
    ListViewController *lvc = [[ListViewController alloc] init];
    [lvc setInhalt:physvols];
    
    NSString * wintitle = [NSString stringWithFormat:@"%@ Physical Volume List", [cnames objectAtIndex:1]];
    [lvc setTitle:wintitle];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [lvc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)c1extentsButton:(id)sender {
    NSArray *cnames = [dr getClusternames];
    
    NSArray *extents = [dr getExtentsForCluster:[cnames objectAtIndex:0]];
    
    ListViewController *lvc = [[ListViewController alloc] init];
    [lvc setInhalt:extents];
    
    NSString * wintitle = [NSString stringWithFormat:@"%@ Extent List", [cnames objectAtIndex:0]];
    [lvc setTitle:wintitle];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [lvc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)c2extentsButton:(id)sender {
    
    NSArray *cnames = [dr getClusternames];
    
    NSArray *extents = [dr getExtentsForCluster:[cnames objectAtIndex:1]];
    
    ListViewController *lvc = [[ListViewController alloc] init];
    [lvc setInhalt:extents];
    
    NSString * wintitle = [NSString stringWithFormat:@"%@ Extent List", [cnames objectAtIndex:1]];
    [lvc setTitle:wintitle];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [lvc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)c1vvButton:(id)sender {
    
    NSArray *cnames = [dr getClusternames];
    
    NSArray *vvs = [dr getVVForCluster:[cnames objectAtIndex:0]];
    
    ListViewController *lvc = [[ListViewController alloc] init];
    [lvc setInhalt:vvs];
    
    NSString * wintitle = [NSString stringWithFormat:@"%@ Virtual Volume List", [cnames objectAtIndex:0]];
    [lvc setTitle:wintitle];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [lvc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)c2vvButton:(id)sender {
    
    NSArray *cnames = [dr getClusternames];
    
    NSArray *vvs = [dr getVVForCluster:[cnames objectAtIndex:1]];
    
    ListViewController *lvc = [[ListViewController alloc] init];
    [lvc setInhalt:vvs];
    
    NSString * wintitle = [NSString stringWithFormat:@"%@ Virtual Volume List", [cnames objectAtIndex:1]];
    [lvc setTitle:wintitle];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [lvc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)distributedButton:(id)sender {
    
        
    NSArray *vvs = [dr getDistributedDevivces];
    
    ListViewController *lvc = [[ListViewController alloc] init];
    [lvc setInhalt:vvs];
    
    [lvc setTitle:@"Distributed Device List"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [lvc release];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)cliButton:(id)sender {
    
    CommandViewController  *cvc = [[CommandViewController alloc] init];
    [cvc setDr:dr];
    
    [[self navigationController] pushViewController:cvc animated:YES];
    
}

- (IBAction)CReportButton:(id)sender {
    
    CReportViewController * crvc = [[CReportViewController alloc] init];
    [crvc setDr:dr];
    
    [[self  navigationController] pushViewController:crvc animated:YES];
}
@end
