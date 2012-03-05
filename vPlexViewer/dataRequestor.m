//
//  dataRequestor.m
//  vPlexViewer
//
//  Created by Bischoff Tobias on 24.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import "dataRequestor.h"
#import "ASIHTTPRequest.h"

@implementation dataRequestor
@synthesize username,password,ipaddress;

- (NSArray *)getClusternames
{
    
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/clusters", ipaddress];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:username];
    [request addRequestHeader:@"password" value:password];
    [request setValidatesSecureCertificate:NO];
    NSLog(@"start request");
    [request startSynchronous];
    NSError *error = [request error];
   
    if (error) {
        NSArray * errnames = [NSArray arrayWithObjects:@"no connection",@"no connection", nil];
        NSLog(@"could not connect");
        return errnames;
    }
    
    NSDictionary* json = [NSJSONSerialization 
                            JSONObjectWithData:[request responseData] 
                              
                            options:kNilOptions 
                            error:&error];
        
    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
    NSArray * context = [jsonresponse objectForKey:@"context"];
    NSDictionary * nextlevel = [context objectAtIndex:0];
    NSArray *children = [nextlevel objectForKey:@"children"];
    NSDictionary * clustername1 = [children objectAtIndex:0];
    NSDictionary * clustername2 = [children objectAtIndex:1];
        
    NSLog(@"cluster1: %@", [clustername1 objectForKey:@"name"]);
    NSLog(@"cluster2: %@", [clustername2 objectForKey:@"name"]);
        
    NSArray * clusternames = [NSArray arrayWithObjects:[clustername1 objectForKey:@"name"],[clustername2 objectForKey:@"name"], nil];
    
    
    return clusternames;
}

- (NSArray *)getStatusForCluster: (NSString *)cn
{
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/clusters/%@/", ipaddress,cn];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:username];
    [request addRequestHeader:@"password" value:password];
    [request setValidatesSecureCertificate:NO];
    NSLog(@"start request");
    [request startSynchronous];
    NSError *error = [request error];
    
    if (error) {
        NSArray * errnames = [NSArray arrayWithObjects:@"--",@"--", nil];
        NSLog(@"could not connect");
        return errnames;
    }
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[request responseData] 
                          
                          options:kNilOptions 
                          error:&error];

    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
    NSArray * context = [jsonresponse objectForKey:@"context"];
    NSDictionary * nextlevel = [context objectAtIndex:0];
    NSArray *attributes = [nextlevel objectForKey:@"attributes"];
    
    NSDictionary * healthstat = [attributes objectAtIndex:10];
    NSString * healthvalue = [NSString stringWithFormat:@"%@", [healthstat objectForKey:@"value"]];
    
    NSDictionary * opstat = [attributes objectAtIndex:13];
    NSString * opvalue = [NSString stringWithFormat:@"%@", [opstat objectForKey:@"value"]];

        
    return [NSArray arrayWithObjects:opvalue,healthvalue, nil];
    
}

- (NSArray *)getPhysvolsForCluster: (NSString *)cn;
{
    
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/clusters/%@/storage-elements/storage-volumes", ipaddress,cn];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:username];
    [request addRequestHeader:@"password" value:password];
    [request setValidatesSecureCertificate:NO];
    NSLog(@"start request");
    [request startSynchronous];
    NSError *error = [request error];
    
    if (error) {
        NSArray * errnames = [NSArray arrayWithObjects:@"no connection",@"no volumes", nil];
        NSLog(@"could not connect");
        return errnames;
    }
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[request responseData] 
                          
                          options:kNilOptions 
                          error:&error];
    
    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
    NSArray * context = [jsonresponse objectForKey:@"context"];
    NSDictionary * nextlevel = [context objectAtIndex:0];
    NSArray *children = [nextlevel objectForKey:@"children"];
    NSLog(@"volume count %d", [children count]);
    
    NSMutableArray * physvols = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < [children count];i++)
    {
        NSDictionary * tmpdic = [children objectAtIndex:i];
        [physvols addObject:[tmpdic objectForKey:@"name"]];
    }
    
    return physvols;
}

- (NSArray *)getExtentsForCluster: (NSString *)cn
{
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/clusters/%@/storage-elements/extents", ipaddress,cn];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:username];
    [request addRequestHeader:@"password" value:password];
    [request setValidatesSecureCertificate:NO];
    NSLog(@"start request");
    [request startSynchronous];
    NSError *error = [request error];
    
    if (error) {
        NSArray * errnames = [NSArray arrayWithObjects:@"no connection",@"no volumes", nil];
        NSLog(@"could not connect");
        return errnames;
    }
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[request responseData] 
                          
                          options:kNilOptions 
                          error:&error];
    
    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
    NSArray * context = [jsonresponse objectForKey:@"context"];
    NSDictionary * nextlevel = [context objectAtIndex:0];
    NSArray *children = [nextlevel objectForKey:@"children"];
    NSLog(@"extent count %d", [children count]);
    
    NSMutableArray * extents = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < [children count];i++)
    {
        NSDictionary * tmpdic = [children objectAtIndex:i];
        [extents addObject:[tmpdic objectForKey:@"name"]];
    }
    
    return extents;
}

- (NSArray *)getVVForCluster: (NSString *)cn
{
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/clusters/%@/virtual-volumes", ipaddress,cn];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:username];
    [request addRequestHeader:@"password" value:password];
    [request setValidatesSecureCertificate:NO];
    NSLog(@"start request");
    [request startSynchronous];
    NSError *error = [request error];
    
    if (error) {
        NSArray * errnames = [NSArray arrayWithObjects:@"no connection",@"no volumes", nil];
        NSLog(@"could not connect");
        return errnames;
    }
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[request responseData] 
                          
                          options:kNilOptions 
                          error:&error];
    
    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
    NSArray * context = [jsonresponse objectForKey:@"context"];
    NSDictionary * nextlevel = [context objectAtIndex:0];
    NSArray *children = [nextlevel objectForKey:@"children"];
    NSLog(@"vv count %d", [children count]);
    
    NSMutableArray * virtualsv = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < [children count];i++)
    {
        NSDictionary * tmpdic = [children objectAtIndex:i];
        [virtualsv addObject:[tmpdic objectForKey:@"name"]];
    }
    
    return virtualsv;
}

- (NSArray *)getDistributedDevivces
{
    
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/distributed-storage/distributed-devices", ipaddress];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:username];
    [request addRequestHeader:@"password" value:password];
    [request setValidatesSecureCertificate:NO];
    NSLog(@"start request");
    [request startSynchronous];
    NSError *error = [request error];
    
    if (error) {
        NSArray * errnames = [NSArray arrayWithObjects:@"no connection",@"no volumes", nil];
        NSLog(@"could not connect");
        return errnames;
    }
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[request responseData] 
                          
                          options:kNilOptions 
                          error:&error];
    
    NSDictionary * jsonresponse = [json objectForKey:@"response"]; 
    NSArray * context = [jsonresponse objectForKey:@"context"];
    NSDictionary * nextlevel = [context objectAtIndex:0];
    NSArray *children = [nextlevel objectForKey:@"children"];
    NSLog(@"distributed devices count %d", [children count]);
    
    NSMutableArray * distd = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < [children count];i++)
    {
        NSDictionary * tmpdic = [children objectAtIndex:i];
        [distd addObject:[tmpdic objectForKey:@"name"]];
    }
    
    return distd;
}

- (BOOL)isReachable

{
    NSString *tmpurlstring = [NSString stringWithFormat:@"https://%@/vplex/distributed-storage/distributed-devices", ipaddress];
    NSURL *url = [NSURL URLWithString:tmpurlstring];
    NSLog(@"url:%@", tmpurlstring);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-type" value:@"text/json"];
    [request addRequestHeader:@"username" value:username];
    [request addRequestHeader:@"password" value:password];
    [request setValidatesSecureCertificate:NO];
    NSLog(@"check reachablitiy");
    [request startSynchronous];
    NSError *error = [request error];
    
    if (error) {
        NSLog(@"error");
        return NO;
    }
    NSLog(@"pass");
    
    return YES;
    
}

@end
