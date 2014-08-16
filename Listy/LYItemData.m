//
//  LYItemData.m
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import "LYItemData.h"

@implementation LYItemData

@synthesize title = _title;
@synthesize url = _url;

- (id)initWithTitle:(NSString *)title url:(NSString *)url cookedDate:(NSDate *)cookedDate cookedImage:(UIImage *)cookedImage
{
    if ((self = [super init])) {
        self.title = title;
        self.url = url;
        self.cookedDate = cookedDate;
        self.cookedImage = cookedImage;
    }
    return self;
}

@end
