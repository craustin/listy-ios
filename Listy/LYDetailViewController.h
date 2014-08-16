//
//  LYDetailViewController.h
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
