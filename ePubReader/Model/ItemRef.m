//
//  ItemRef.m
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "ItemRef.h"

@implementation ItemRef

- (instancetype)initWithInfo:(NSString *)idref
{
    self = [super init];
    if (self)
    {
        self.idref = idref;
    }
    return self;
}

@end
