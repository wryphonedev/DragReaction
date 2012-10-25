//
//  UIPanGestureRecognizer+ZSDraggingAdditions.m
//  DragReaction
//
//  Created by Isaac Schmidt on 10/25/12.
//  Copyright (c) 2012 Zuse. All rights reserved.
//

#import "UIPanGestureRecognizer+ZSDraggingAdditions.h"

static char const * const StartPointKey = "StartPoint";

@implementation UIPanGestureRecognizer (ZSDraggingAdditions)

@dynamic startPoint;

- (void)dragWithinView:(UIView *)view evaluateOverlappingViews:(NSArray *)views overlapsBlock:(void (^)(UIView *overlapView))overlapsBlock completion:(void (^)(UIView *overlapView))completionBlock 
{
    CGPoint translatedPoint = [self translationInView:view];
    
    // Adjust our translated point if the containing view has a transform applied
    if (!CGAffineTransformIsIdentity(view.transform))
    {
        translatedPoint = CGPointApplyAffineTransform(translatedPoint, view.transform);
    }
    
    switch ([self state])
    {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint startPoint = [[self view] center];
            [self setStartPoint:startPoint];
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            translatedPoint =  CGPointMake(self.startPoint.x + translatedPoint.x, self.startPoint.y + translatedPoint.y);
            [[self view] setCenter:translatedPoint];
            UIView *evaluatingView = [self view];
            CGRect evaluateRect = evaluatingView.frame;
            
            // Do any of our evaluation views contain our recognizer's view?
            UIView *containingView = [self viewContainingRect:evaluateRect evaluateViews:views];
            
            if (overlapsBlock)
            {
                overlapsBlock(containingView);
            }
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            // Handle completion
            if (completionBlock)
            {
                UIView *evaluatingView = [self view];
                CGRect evaluateRect = [evaluatingView frame];
                UIView *containingView = [self viewContainingRect:evaluateRect evaluateViews:views];
                
                completionBlock(containingView);
            }
            
            [self setStartPoint:CGPointZero];
            
        }
            break;
            
        default:
            break;
    }
}

- (CGPoint)startPoint
{
    NSValue *pointValue = objc_getAssociatedObject(self, StartPointKey);
    return [pointValue CGPointValue];
}

- (void)setStartPoint:(CGPoint)startPoint
{    
    NSValue *pointValue = [NSValue valueWithCGPoint:startPoint];
    
    // If startPoint is CGPointZero, pointValue should be nil so that previous value is released.
    if (CGPointEqualToPoint(startPoint, CGPointZero))
    {
        pointValue = nil;
    }
    
    objc_setAssociatedObject(self, StartPointKey, pointValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)viewContainingPoint:(CGPoint)point evaluateViews:(NSArray *)views
{
    // View containing a point
    UIView *matchingView = nil;
    NSInteger matchingIndex = [views indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
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

- (UIView *)viewIntersectingRect:(CGRect)rect evaluateViews:(NSArray *)views
{
    UIView *matchingView = nil;
    NSInteger matchingIndex = [views indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        UIView *view = (UIView *)obj;
        CGRect frame = view.frame;
        
        return CGRectIntersectsRect(rect, frame);
    }];
    
    if (matchingIndex != NSNotFound)
    {
        matchingView = [views objectAtIndex:matchingIndex];
    }
    
    return matchingView;
}

- (UIView *)viewContainingRect:(CGRect)rect evaluateViews:(NSArray *)views
{
    UIView *matchingView = nil;
    NSInteger matchingIndex = [views indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                               {
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
