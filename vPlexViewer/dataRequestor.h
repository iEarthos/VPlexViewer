//
//  dataRequestor.h
//  vPlexViewer
//
//  Created by Bischoff Tobias on 24.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataRequestor : NSObject

@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *ipaddress;

- (NSArray *)getClusternames;
- (NSArray *)getStatusForCluster: (NSString *)cn;
- (NSArray *)getPhysvolsForCluster: (NSString *)cn;
- (NSArray *)getExtentsForCluster: (NSString *)cn;
- (NSArray *)getVVForCluster: (NSString *)cn;
- (NSArray *)getDistributedDevivces;
- (BOOL)isReachable;

@end
