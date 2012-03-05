//
//  CommandViewController.m
//  vPlexViewer
//
//  Created by Bischoff Tobias on 26.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import "CommandViewController.h"
#import "ASIHTTPRequest.h"


@interface CommandViewController ()

@end

@implementation CommandViewController
@synthesize sendButton;
@synthesize activity;
@synthesize output;
@synthesize cmdField;
@synthesize argsField,dr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
       [[self navigationItem] setTitle:@"Command Mode"]; 
        
        UIBarButtonItem *helpItem = [[UIBarButtonItem alloc] initWithTitle:@"Get help with CLI" style:UIBarButtonItemStylePlain target:self action:@selector(helpwithCLI:)];
        [[self navigationItem] setRightBarButtonItem:helpItem];
        [cmdField setDelegate:self];
        [argsField setDelegate:self];
    }
    return self;
}

- (IBAction)helpwithCLI:(id)sender
{
    NSString *webString = [NSString stringWithFormat:@"http://blog.scottlowe.org/2010/12/22/an-introduction-to-the-vplex-cli/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webString]];
    NSLog(@"help with CLI angeklickt");

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidUnload
{
    [self setCmdField:nil];
    [self setArgsField:nil];
    [self setSendButton:nil];
    [self setActivity:nil];
    [self setOutput:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [cmdField release];
    [argsField release];
    [sendButton release];
    [activity release];
    [output release];
    [super dealloc];
}
- (IBAction)sendButton:(id)sender {
    
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/%@", [dr ipaddress], [cmdField text]];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:[dr username]];
    [request addRequestHeader:@"password" value:[dr password]];
    [request setValidatesSecureCertificate:NO];
    [request setRequestMethod:@"POST"];
    NSLog(@"start request");
    NSString *argsstring = [NSString stringWithFormat:@"{\"args\" : \"%@\"}", [argsField text]];
    NSLog(@"arg: %@", argsstring);
    [request appendPostData:[argsstring dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    [activity startAnimating];
    [sendButton setEnabled:NO];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [activity stopAnimating];
    [sendButton setEnabled:YES];
    
    NSError * error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[request responseData] 
                          
                          options:kNilOptions 
                          error:&error];
    NSLog(@"%@", [request responseString]);
        
    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
   
    
    NSLog(@"custom data %@", [jsonresponse objectForKey:@"custom-data"]);
    NSLog(@"exception %@", [jsonresponse objectForKey:@"exception"]);
    

    NSNull * n0 = [[NSNull alloc] init];
    
    if ([jsonresponse objectForKey:@"custom-data"] == n0){
        [output setText:[jsonresponse objectForKey:@"exception"]];
    }
    
    if ([jsonresponse objectForKey:@"exception"] == n0){
        [output setText:[jsonresponse objectForKey:@"custom-data"]];
    }
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request failed%@", [request error]);
    [activity stopAnimating];
    [sendButton setEnabled:YES];
    [output setText:@"Cannot create that request"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [cmdField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self sendButton:nil];
    return NO;
}

@end
