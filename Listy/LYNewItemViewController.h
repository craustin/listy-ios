//
//  LYDetailViewController.h
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LYItemData.h"
#import "LYMasterViewController.h"

@interface LYNewItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *urlText;

- (void)setParent:(LYMasterViewController*)parent;

@end
