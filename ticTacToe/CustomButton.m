//
//  CustomButton.m
//  ticTacToe
//
//  Created by Kate on 2/17/15.
//  Copyright (c) 2015 game. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self.layer setBorderWidth:.5f];
        [self.layer setBorderColor:[UIColor blackColor].CGColor];
    }
    return self;
}

@end
