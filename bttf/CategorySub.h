//
//  CategorySub.h
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class CategoryMain;

@interface CategorySub : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* name;
@property (nonatomic) CategoryMain* categoryMain;

@end
