//
//  Screen.m
//  SidUI
//
//  Created by Siddhant Dange on 6/18/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "Screen.h"

@interface Screen ()

@property (nonatomic, strong) id subclassInstance;

@end

@implementation Screen

-(id)initWithData:(NSDictionary*)data nibName:(NSString*)nibName bundle:(NSBundle*)bundle{
    self = [self initWithNibName:nibName bundle:bundle];
    if(self){
        _passedData = data;
        _subclassInstance = self;   
    }
    
    return self;
}



-(void)viewWillAppear:(BOOL)animated{
    [_subclassInstance setup];
}

-(void)setup{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


-(void)goToScreen:(NSString*)screenName animated:(BOOL)animated{
    [self goToScreen:screenName animated:animated withData:nil];
}

-(void)goToScreen:(NSString *)screenName animated:(BOOL)animated withData:(NSDictionary *)data{
    
    Screen *screen = [(Screen*)[NSClassFromString(screenName) alloc] initWithData:data nibName:screenName bundle:NULL];
    [self.navigationController pushViewController:screen animated:animated];
}

-(void)popScreenWithAnimation:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:animated];
}

@end
