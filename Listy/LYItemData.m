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

NSString *const DateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";

- (id)initWithTitle:(NSString *)title url:(NSString *)url cookedDate:(NSDate *)cookedDate cookedImage:(UIImage *)cookedImage
{
    if ((self = [super init])) {
        self.key = nil;
        self.title = title;
        self.url = url;
        self.cookedDate = cookedDate;
        self.cookedImage = cookedImage;
    }
    return self;
}

- (id)initWithDict:(NSDictionary *)dict key:(NSString *)key
{
    if ((self = [super init])) {
        self.key = key;
        self.title = [dict valueForKey:@"title"];
        self.url = [dict valueForKey:@"url"];
        
        NSString *cookedDate = [dict valueForKey:@"cookedDate"];
        if (cookedDate.length > 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = DateFormat;
            self.cookedDate = [dateFormatter dateFromString:cookedDate];
        }
    }
    return self;
}

- (NSDictionary *)asDict
{
    NSString *cookedDate;
    
    if (self.cookedDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = DateFormat;
        cookedDate = [dateFormatter stringFromDate:self.cookedDate];
    }
    return  @{
              @"title": self.title,
              @"url": self.url,
              @"cookedDate": (cookedDate ?: @"")
              };
}

@end
