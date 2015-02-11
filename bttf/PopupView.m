//
//  PopupView.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 12/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "PopupView.h"
#import "Screen.h"
#import "ScreenNavigation.h"

@interface PopupView ()
@property (weak, nonatomic) IBOutlet UIView* contentView, *mainView;
@property (nonatomic, strong) ScreenNavigation* screenNavigation;

@end

@implementation PopupView

-(instancetype)initWithScreen:(NSString*)screenName andData:(NSDictionary*)data onScreen:(Screen*)overScreen{
    
    self = [super init];
    
    
    if(self){
        _mainView = [[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:self options:nil][0];
        CGRect frame = _mainView.frame;
        float totalHeight = [UIScreen mainScreen].bounds.size.height;
        float totalWidth = [UIScreen mainScreen].bounds.size.width;
        frame.origin.x = (totalWidth - frame.size.width)/2.0f;
        frame.origin.y = (totalHeight - frame.size.height)/2.0f;
        self.frame = frame;
        
        [self addSubview:_mainView];
        _screenNavigation = [[ScreenNavigation alloc] init];
        NSMutableDictionary *dataAppend = data.mutableCopy;
        if(!dataAppend){
            dataAppend = @{}.mutableCopy;
        }
        [dataAppend setObject:self forKey:@"popup_vc"];
        [_screenNavigation startWithScreen:screenName data:dataAppend animated:NO];
        
        Screen *inputCutDataScreen = ((Screen*)_screenNavigation.viewControllers[0]);
        _screenNavigation.view.frame = inputCutDataScreen.view.frame;
        
        [_contentView addSubview:_screenNavigation.view];
        
        
    }
    
    return self;
}

- (IBAction)closeBox:(id)sender {
    [self removeFromSuperview];
    if(self.delegate && self.closeAction){
        [self.delegate performSelectorOnMainThread:self.closeAction withObject:nil waitUntilDone:YES];
    }
}

@end
