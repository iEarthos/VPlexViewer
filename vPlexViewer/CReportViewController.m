//
//  CReportViewController.m
//  vPlexViewer
//
//  Created by Bischoff Tobias on 01.03.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import "CReportViewController.h"
#import "ASIHTTPRequest.h"


@interface CReportViewController ()

@end

@implementation CReportViewController
@synthesize printButton;
@synthesize progressLabel;
@synthesize activity;
@synthesize contentTView;
@synthesize sendButton;
@synthesize genButton;
@synthesize dr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
        [[self navigationItem] setTitle:@"Generate Configuration Report"]; 
        [sendButton setEnabled:NO];
        [printButton setEnabled:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setGenButton:nil];
    [self setActivity:nil];
    [self setProgressLabel:nil];
    [self setContentTView:nil];
    [self setSendButton:nil];
    [self setPrintButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}



- (IBAction)genButton:(id)sender {
    
    [activity startAnimating];
    [progressLabel setText:@"generating Report.."];
    [genButton setEnabled:NO];
    
    
    NSArray *cnames = [dr getClusternames];
    
    [contentTView setText:[NSString stringWithFormat:@"Configuration Report for Clusters %@ & %@", [cnames objectAtIndex:0], [cnames objectAtIndex:1]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    [contentTView setText:[[contentTView text] stringByAppendingString:[NSString stringWithFormat:@"\nGenerated on: %@", strDate]]];
    
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/ls", [dr ipaddress]];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:[dr username]];
    [request addRequestHeader:@"password" value:[dr password]];
    [request setValidatesSecureCertificate:NO];
    [request setRequestMethod:@"POST"];
    NSLog(@"start request");
    NSString *argsstring = [NSString stringWithFormat:@"{\"args\" : \"-l /**/**\"}"];

    [request appendPostData:[argsstring dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    

}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [activity stopAnimating];
    [progressLabel setText:@"Done."];
    [genButton setEnabled:YES];
    [sendButton setEnabled:YES];
    [printButton setEnabled:YES];
    
    NSError * error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[request responseData] 
                          
                          options:kNilOptions 
                          error:&error];

    
    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
    
    
    NSNull * n0 = [[NSNull alloc] init];
    
    if ([jsonresponse objectForKey:@"custom-data"] == n0){
         [contentTView setText:[[contentTView text] stringByAppendingString:[jsonresponse objectForKey:@"exception"]]];
    }
    
    if ([jsonresponse objectForKey:@"exception"] == n0){
         [contentTView setText:[[contentTView text] stringByAppendingString:[jsonresponse objectForKey:@"custom-data"]]];
    }
    
    
}



- (void)dealloc {
    [genButton release];
    [activity release];
    [progressLabel release];
    [contentTView release];
    [sendButton release];
    [printButton release];
    [super dealloc];
}
- (IBAction)sendButton:(id)sender {
    
    NSError * error = nil;
    NSArray       *myPathList        =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString      *myPath            =  [myPathList  objectAtIndex:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    NSString * filename = [NSString stringWithFormat:@"vplexconfig%@.txt", strDate]; 
    myPath = [myPath stringByAppendingPathComponent:filename];
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:myPath])
        
    {
        [[NSFileManager defaultManager] createFileAtPath:myPath contents:nil attributes:nil];
        [[contentTView text] writeToFile:myPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
                
    }
    else
        
    {
        NSLog(@"saved file already present");        
    }
    
    NSData* data=[[contentTView text] dataUsingEncoding:NSUTF8StringEncoding];
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate =self;
        [mailController setSubject:@"VPlex Configuration"];
        [mailController setMessageBody:@"" isHTML:YES];
        [mailController addAttachmentData:data mimeType:@"MIME" fileName:filename];
        [self presentModalViewController:mailController animated:YES];
        [mailController release];
    } else {
        //Pop up a notification
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not send email. Verify Internet conneciton and try again." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
    
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
    
}
     
- (IBAction)printButton:(id)sender {
    
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"VPlexConfig";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    UIViewPrintFormatter *formatter = [self.contentTView viewPrintFormatter];
    pc.printFormatter = formatter;
    
    UIPrintInteractionCompletionHandler completionHandler = 
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain, error.code); 
        }
    };
    [pc presentFromRect:CGRectZero inView:printButton animated:YES completionHandler:completionHandler];
    
}
@end
