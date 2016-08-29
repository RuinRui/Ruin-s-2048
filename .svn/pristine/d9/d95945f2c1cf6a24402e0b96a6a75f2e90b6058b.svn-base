//
//  NumLabel.m
//  JMDwornik
//
//  Created by FBI on 16/3/28.
//  Copyright © 2016年 君陌. All rights reserved.
//

#import "NumLabel.h"

@implementation NumLabel

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont fontWithName:@"Gill Sans" size:35];
    }
    
    return self;
}

- (void) setNumber:(NSNumber *)number{
    
    self.text = [NSString stringWithFormat:@"%@", number];
    _number = number;
    
    NSInteger index = [number integerValue];
    
    UIColor * bgColor;
    UIColor * fontColor = [UIColor darkGrayColor];
    
    switch (index) {
        case 2:
            bgColor = RGBColor(240, 240, 240);
        case 4:
        case 8:
        case 16:
        case 32:{
            fontColor = [UIColor whiteColor];
            bgColor = RGBColor(255 - 2 * index, 180, 70 - index);
        }
            
            break;
        case 64:
        case 128:
        case 256:{
            fontColor = [UIColor whiteColor];
            bgColor = RGBColor(88, 188 - index / 4, 188 - index / 4);
        }
            break;
        case 512:
        case 1024:{
            fontColor = [UIColor whiteColor];
            bgColor = RGBColor(190 - index / 20, 130 - index / 20, 188);
        }
            break;
        case 2048:{
            fontColor = [UIColor whiteColor];
            bgColor = RGBColor(43, 147, 246);
        }
            break;
            
        default:
            break;
    }
    
    self.backgroundColor = bgColor;
    self.textColor = fontColor;
}

@end
