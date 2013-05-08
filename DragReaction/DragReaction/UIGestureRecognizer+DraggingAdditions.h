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

// Animate recognizer's attached view with touch. Execute overlap block when the recognizer's view frame is contained within the frame of a view in evaluatingOverappingViews array.
- (void)dragAttachedViewWithinView:(UIView *)view evaluatingOverlappingViews:(NSArray *)views contains:(void (^)(UIView *overlappingView))containsBlock completion:(void (^)(UIView *overlappingView))completionBlock;

// Animate recognizer's attached view with touch. Execute overlap block with the index of an evaluated rect that contains the rect of the gesture's view. 
- (void)dragAttachedViewWithinView:(UIView *)view evaluatingOverlappingRects:(NSArray *)rects contains:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock;

// Animate the passed layer with the recognizer's position, evaluate overlapping views. Layer to drag must reside in same superlayer as the gesture's view layer.
- (void)dragLayer:(CALayer *)layer withinView:(UIView *)view evaluateOverlappingRects:(NSArray *)rects contains:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock;

@end
