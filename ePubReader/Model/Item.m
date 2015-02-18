//
//  Item.m
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithInfo:(NSString *)href ID:(NSString *)ID mediaType:(NSString *)mediaType properties:(NSString *)properties
{
    self = [super init];
    if (self) {
        self.href = href;
        self.ID = ID;
        self.mediaType = mediaType;
        self.properties = properties;
    }
    return self;
}

@end
