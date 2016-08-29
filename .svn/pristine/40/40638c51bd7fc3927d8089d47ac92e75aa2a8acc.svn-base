//
//  UIView+CornerRadius.m
//  YJLYClient
//
//  Created by FBI on 16/3/21.
//  Copyright © 2016年 sunjames. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>

@implementation UIView (CornerRadius)

- (CGFloat) cornerRadius{
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}

- (void) setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat) borderWidth{
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}

- (void) setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

- (UIColor *) borderColor{
    return objc_getAssociatedObject(self, @selector(borderColor));
}

- (void) setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

@end
