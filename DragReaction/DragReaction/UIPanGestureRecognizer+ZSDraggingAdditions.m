//
//  UIPanGestureRecognizer+ZSDraggingAdditions.m
//  DragReaction
//
//  Created by Isaac Schmidt on 10/25/12.
//  Copyright (c) 2012 Zuse. All rights reserved.
//

#import "UIPanGestureRecognizer+ZSDraggingAdditions.h"
#import "UIView+ZSViewAdditions.h"

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
            UIView *containingView = [UIView viewContainingRect:evaluateRect evaluateViews:views];
            
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
                UIView *containingView = [UIView viewContainingRect:evaluateRect evaluateViews:views];
                
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

@end
