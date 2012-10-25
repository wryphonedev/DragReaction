//
//  UIPanGestureRecognizer+ZSDraggingAdditions.h
//  DragReaction
//
//  Created by Isaac Schmidt on 10/25/12.
//  Copyright (c) 2012 Zuse. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    
    ZSDraggingOverlapContainsOrIntersects =  0,
    ZSDraggingOverlapContains,
    ZSDraggingOverlapIntersects                 
    
} ZSDraggingOverlapOptions;

@interface UIPanGestureRecognizer (ZSDraggingAdditions)

@property (assign) CGPoint startPoint;

- (void)dragWithinView:(UIView *)view evaluateOverlappingViews:(NSArray *)views overlapsBlock:(void (^)(UIView *overlapView))overlapsBlock completion:(void (^)(UIView *overlapView))completionBlock options:(ZSDraggingOverlapOptions)options;
- (UIView *)viewContainingPoint:(CGPoint)point evaluateViews:(NSArray *)views;
- (UIView *)viewIntersectingRect:(CGRect)rect evaluateViews:(NSArray *)views;
- (UIView *)viewContainingRect:(CGRect)rect evaluateViews:(NSArray *)views;


@end
