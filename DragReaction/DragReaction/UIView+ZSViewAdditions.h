//
//  UIView+ZSViewAdditions.h
//  Zuse
//
//  Created by Isaac Schmidt on 12/10/12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (ZSViewAdditions)

+ (UIView *)viewContainingPoint:(CGPoint)point evaluateViews:(NSArray *)views;
+ (UIView *)viewIntersectingRect:(CGRect)rect evaluateViews:(NSArray *)views;
+ (UIView *)viewContainingRect:(CGRect)rect evaluateViews:(NSArray *)views;
+ (NSUInteger)indexOfRectContainingPoint:(CGPoint)point evaluateRects:(NSArray *)evaluate;

@end
