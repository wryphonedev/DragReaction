//
//  UIGestureRecognizer+DraggingAdditions.m
//  Zuse
//
//  Created by Isaac Schmidt on 5/7/13.
//
//

#import "UIGestureRecognizer+DraggingAdditions.h"
#import "UIView+ZSViewAdditions.h"

static char const * const StartPointKey = "ZSStartPoint";
static char const * const RectValuesKey = "ZSRectValues";
static char const * const AnimatingLayerKey = "ZSAnimatingLayer";

@implementation UIGestureRecognizer (DraggingAdditions)

@dynamic startPoint;
@dynamic rectValues;

- (void)dragViewWithinView:(UIView *)view evaluateViewsForOverlap:(NSArray *)views containedByOverlappingViewBlock:(void (^)(UIView *overlappingView))containsBlock completion:(void (^)(UIView *overlappingView))completionBlock
{
    if ([self state] == UIGestureRecognizerStateBegan)
    {
        NSArray *rectValues = [UIView frameRectValuesForViews:views];
        [self setRectValues:[NSArray arrayWithArray:rectValues]];
    }
    
    static void (^overlappingBlock)(NSUInteger);
    overlappingBlock = ^(NSUInteger overlappingIndex){
        
        UIView *overlappingView = nil;
        if (overlappingIndex != NSNotFound)
        {
            overlappingView = [views objectAtIndex:overlappingIndex];
        }
        
        if (containsBlock)
        {
            containsBlock(overlappingView);
        }
    };
    
    static void (^finishedBlock)(NSUInteger);
    finishedBlock = ^(NSUInteger overlappingIndex){
        
        UIView *overlappingView = nil;
        if (overlappingIndex != NSNotFound)
        {
            overlappingView = [views objectAtIndex:overlappingIndex];
        }
        
        if (completionBlock)
        {
            completionBlock(overlappingView);
        }
    };
    
    [self dragViewWithinView:view
     evaluateRectsForOverlap:[self rectValues]
containedByOverlappingRectBlock:overlappingBlock
                  completion:finishedBlock];
    
    
    if ([self state] == UIGestureRecognizerStateEnded)
    {
        [self setRectValues:nil];
    }
}

- (void)dragViewWithinView:(UIView *)view evaluateRectsForOverlap:(NSArray *)rects containedByOverlappingRectBlock:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock
{
    CALayer *gestureViewLayer = [[self view] layer];
    [self dragLayer:gestureViewLayer
         withinView:view
evaluateRectsForOverlaps:rects
containedByOverlappingRectBlock:containsBlock
         completion:completionBlock];
}

- (void)dragLayer:(CALayer *)layer withinView:(UIView *)view evaluateRectsForOverlaps:(NSArray *)rects containedByOverlappingRectBlock:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock
{
    CGPoint location = [self locationInView:view];
    CGPoint translatedPoint;
    translatedPoint.x = location.x - self.startPoint.x;
    translatedPoint.y = location.y - self.startPoint.y;
    translatedPoint = [[[self view] superview] convertPoint:location fromView:view];
    
    CGRect layerRect = [layer frame];
    layerRect = [view convertRect:layerRect fromView:[[self view] superview]];
    
    switch ([self state])
    {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint startPoint = translatedPoint;
            [self setStartPoint:startPoint];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            [layer setPosition:translatedPoint];
            
            NSUInteger containingIndex = [UIView indexOfRectContainingRect:layerRect evaluateRects:rects];
            
            if (containsBlock)
            {
                containsBlock(containingIndex);
            }
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            if (completionBlock)
            {
                NSUInteger containingIndex = [UIView indexOfRectContainingRect:layerRect evaluateRects:rects];
                
                if (completionBlock)
                {
                    completionBlock(containingIndex);
                }
            }
            
            [self setStartPoint:CGPointZero];
            
        }
            break;
            
        default:
            break;
    }
}

- (NSArray *)rectValues
{
    return objc_getAssociatedObject(self, RectValuesKey);
}

- (void)setRectValues:(NSArray *)rectValues
{
    objc_setAssociatedObject(self, RectValuesKey, rectValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
