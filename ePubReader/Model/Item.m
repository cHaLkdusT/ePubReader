//
//  Item.m
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithTBXMLElement:(TBXMLElement *)element
{
    self = [super init];
    if (self) {
        self.ID = [TBXML valueOfAttributeNamed:@"id" forElement:element];
        self.href = [TBXML valueOfAttributeNamed:@"href" forElement:element];
        self.mediaType = [TBXML valueOfAttributeNamed:@"media-type" forElement:element];
        self.properties = [TBXML valueOfAttributeNamed:@"properties" forElement:element];
    }
    return self;
}

@end
