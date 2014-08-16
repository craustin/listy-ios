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

@interface LYNewItemViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *urlText;
@property (weak, nonatomic) IBOutlet UISwitch *cookedSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *cookedDatePicker;
@property (weak, nonatomic) IBOutlet UIImageView *cookedImage;
@property (weak, nonatomic) IBOutlet UIView *cookedControlsView;

- (void)setParent:(LYMasterViewController*)parent;
- (IBAction)cookedSwitchChanged:(id)sender;

@end
