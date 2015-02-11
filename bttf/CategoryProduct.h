//
//  CategoryProduct.h
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "MTLModel.h"

@class  CategoryMain;
@class  CategorySub;

@interface CategoryProduct : MTLModel

@property (nonatomic) NSString* name;
@property (nonatomic) CategoryMain* categoryMain;
@property (nonatomic) CategorySub* categorySub;


@end
