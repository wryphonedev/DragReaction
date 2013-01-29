//
//  UIPanGestureRecognizer+ZSDraggingAdditions.h
//  DragReaction
//
//  Created by Isaac Schmidt on 10/25/12.
//  Copyright (c) 2012 Zuse. All rights reserved.
//
//  Adds animated dragging functionality to UIGestureRecognizer's view and provides overlap detection with passed views or array of rect values.

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIPanGestureRecognizer (ZSDraggingAdditions)

@property (assign) CGPoint startPoint;

// Drag the recognizer's view within passed view. Execute overlap block when overlapping with subview in passed views array.
- (void)dragWithinView:(UIView *)view evaluateOverlappingViews:(NSArray *)views overlapsBlock:(void (^)(UIView *overlapView))overlapsBlock completion:(void (^)(UIView *overlapView))completionBlock;

@end
