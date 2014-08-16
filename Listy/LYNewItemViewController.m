//
//  LYDetailViewController.m
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import "LYNewItemViewController.h"
#import "LYMasterViewController.h"

@interface LYNewItemViewController () {
    LYMasterViewController *_parent;
}
@end

@implementation LYNewItemViewController

- (IBAction)userDidSave:(id)sender {
    if (![self validateData])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not save item"
                                                        message:@"Your item must have a valid title and URL."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [_parent createNewItemWithTitle:self.titleText.text url:self.urlText.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (bool)validateData
{
    if (self.urlText.text.length > 0)
    {
        NSURL *candidateURL = [NSURL URLWithString:self.urlText.text];
        if (!candidateURL || !candidateURL.scheme || !candidateURL.host)
            return NO;
    }

    return (self.titleText.text.length > 0);
}

- (void)setParent:(LYMasterViewController *)parent
{
    _parent = parent;
}

@end
