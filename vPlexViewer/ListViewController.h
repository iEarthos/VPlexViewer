//
//  ListViewController.h
//  vPlexViewer
//
//  Created by Bischoff Tobias on 24.02.12.
//  Copyright (c) 2012 Tobias Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController

@property (nonatomic, retain) NSArray * inhalt;
@property (nonatomic, retain) NSString *title;

@end
