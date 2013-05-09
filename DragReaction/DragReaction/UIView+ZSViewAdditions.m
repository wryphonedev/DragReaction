//
//  UIView+ZSViewAdditions.m
//  Zuse
//
//  Created by Isaac Schmidt on 12/10/12.
//
//

#import "UIView+ZSViewAdditions.h"

@implementation UIView (ZSViewAdditions)

- (NSArray *)frameRectValuesForSubviews
{
    return [UIView frameRectValuesForViews:[self subviews]];
}

+ (NSArray *)frameRectValuesForViews:(NSArray *)subviews
{
    __block NSMutableArray *frameValues = [[NSMutableArray alloc] initWithCapacity:[subviews count]];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIView *view = (UIView *)obj;
        CGRect frame = [view frame];
        NSValue *frameValue = [NSValue valueWithCGRect:frame];
        [frameValues insertObject:frameValue atIndex:idx];
        
    }];
    
    return [NSArray arrayWithArray:frameValues];
}

+ (NSUInteger)indexOfRectContainingPoint:(CGPoint)point evaluateRects:(NSArray *)evaluate
{
    return [evaluate indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        NSValue *rectValue = (NSValue *)obj;
        CGRect rect = [rectValue CGRectValue];
        return CGRectContainsPoint(rect, point);
        
    }];
}

+ (NSUInteger)indexOfRectContainingRect:(CGRect)rect evaluateRects:(NSArray *)evaluate
{
    return [evaluate indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        NSValue *rectValue = (NSValue *)obj;
        CGRect evaluationRect = [rectValue CGRectValue];
        return CGRectContainsRect(evaluationRect, rect);
        
    }];
}

+ (UIView *)viewContainingPoint:(CGPoint)point evaluateViews:(NSArray *)views
{
    // View containing a point
    UIView *matchingView = nil;
    NSInteger matchingIndex = [views indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        NSAssert([obj isMemberOfClass:[UIView class]], @"Attempting to evaluate an object that isn't a view.");
        UIView *view = (UIView *)obj;
        CGRect frame = view.frame;
        
        return CGRectContainsPoint(frame, point);
    }];
    
    if (matchingIndex != NSNotFound)
    {
        matchingView = [views objectAtIndex:matchingIndex];
    }
    
    return matchingView;
    
}

+ (UIView *)viewContainingRect:(CGRect)rect evaluateViews:(NSArray *)views
{
    UIView *matchingView = nil;
    NSInteger matchingIndex = [views indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                               {
                                   NSAssert([obj isMemberOfClass:[UIView class]], @"Attempting to evaluate an object that isn't a view");
                                   UIView *view = (UIView *)obj;
                                   CGRect frame = view.frame;
                                   
                                   return CGRectContainsRect(frame, rect);
                               }];
    
    if (matchingIndex != NSNotFound)
    {
        matchingView = [views objectAtIndex:matchingIndex];
    }
    
    return matchingView;
}

@end
