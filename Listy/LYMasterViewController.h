//
//  LYMasterViewController.h
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYItemList.h"

@interface LYMasterViewController : UITableViewController<LYDataUpdatedDelegate>

@property (nonatomic, strong) LYItemList *items;

- (void)createNewItemWithTitle:(NSString *)title url:(NSString *)url cookedDate:(NSDate *)cookedDate cookedImage:(UIImage *)cookedImage;
- (void)childUpdatedItem:(LYItemData *)item;

@end
