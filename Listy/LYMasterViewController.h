//
//  LYMasterViewController.h
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYMasterViewController : UITableViewController

@property (strong) NSMutableArray *items;

- (void)createNewItemWithTitle:(NSString*)title url:(NSString*)url;

@end
