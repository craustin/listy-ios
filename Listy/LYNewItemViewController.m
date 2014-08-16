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
    LYItemData *_item;
}
@end

@implementation LYNewItemViewController

- (void)viewDidLoad
{
    NSString *paste = [UIPasteboard generalPasteboard].string;
    if (paste && [self isValidURL:paste])
        self.urlText.text = paste;
    
    if (_item)
    {
        self.titleText.text = _item.title;
        self.urlText.text = _item.url;
        if (_item.cookedDate)
        {
            self.cookedDatePicker.date = _item.cookedDate;
            self.cookedSwitch.on = YES;
            self.cookedControlsView.hidden = NO;
        }
        if (_item.cookedImage)
            self.cookedImage.image = _item.cookedImage;
    }
    [super viewDidLoad];
}

- (IBAction)userDidSave:(id)sender
{
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
    
    if (!_item)
    {
        [_parent createNewItemWithTitle:self.titleText.text
                                    url:self.urlText.text
                             cookedDate:self.cookedDatePicker.date
                            cookedImage:self.cookedImage.image];
    }
    else
    {
        _item.title = self.titleText.text;
        _item.url = self.urlText.text;
        _item.cookedDate = self.cookedDatePicker.date;
        _item.cookedImage = self.cookedImage.image;
        [_parent setEditing:NO animated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (bool)validateData
{
    if (self.urlText.text.length > 0)
    {
        if (![self isValidURL:self.urlText.text])
            return NO;
    }

    return (self.titleText.text.length > 0);
}

- (bool)isValidURL:(NSString *)url
{
    NSURL *candidateURL = [NSURL URLWithString:url];
    return (candidateURL && candidateURL.scheme && candidateURL.host);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self touchesBegan:touches withEvent:event];
}

- (void)setParent:(LYMasterViewController *)parent
{
    _parent = parent;
}

-(void)setItem:(LYItemData *)item
{
    _item = item;
}

- (IBAction)cookedSwitchChanged:(id)sender {
    [UIView transitionWithView:self.cookedControlsView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.cookedControlsView.hidden = !self.cookedSwitch.on;
}

- (IBAction)didClickChoosePhoto:(id)sender {
    [self getPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)didClickTakePhoto:(id)sender {
    [self getPhoto:UIImagePickerControllerSourceTypeCamera];
}

- (void)getPhoto:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	self.cookedImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

@end
