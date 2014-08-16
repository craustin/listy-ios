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

- (id)initWithTitle:(NSString *)title url:(NSString *)url {
    if ((self = [super init])) {
        self.title = title;
        self.url = url;
    }
    return self;
}

@end
