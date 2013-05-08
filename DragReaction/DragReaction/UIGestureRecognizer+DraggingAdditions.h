//
//  UIGestureRecognizer+DraggingAdditions.h
//  Zuse
//
//  Created by Isaac Schmidt on 5/7/13.
//
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIGestureRecognizer (DraggingAdditions)

@property (assign, nonatomic) CGPoint startPoint;
@property (strong, nonatomic) NSArray *rectValues;

// Animate recognizer's decorated view with touch. Execute containedByOverlappingViewBlock when the recognizer's frame is fully contained by at least one subview's frame.
- (void)dragViewWithinView:(UIView *)view evaluateViewsForOverlap:(NSArray *)views containedByOverlappingViewBlock:(void (^)(UIView *overlappingView))overlappingBlock completion:(void (^)(UIView *overlappingView))completionBlock;

// Animate recognizer's decorated view with touch. Execute overlap block with the index of an evaluated rect that fully contains the rect of the gesture's view.
- (void)dragViewWithinView:(UIView *)view evaluateRectsForOverlap:(NSArray *)rects containedByOverlappingRectBlock:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock;

// Animate the passed layer with the recognizer's position, evaluate overlapping views.
- (void)dragLayer:(CALayer *)layer withinView:(UIView *)view evaluateRectsForOverlaps:(NSArray *)rects containedByOverlappingRectBlock:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock;

@end
