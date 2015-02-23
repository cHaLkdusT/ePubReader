//
//  Item.h
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface Item : NSObject

@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *properties;

- (instancetype)initWithTBXMLElement:(TBXMLElement *)element;

@end
