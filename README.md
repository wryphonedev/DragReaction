DragReaction
============

Included are two Cocoa Touch Objective-C categories that (when combined) simplify two common behaviors: First, the animating of a layer or view corresponding to the movement of a UIGestureRecognizer. Second, to evaluate the position of the view or layer being animated, and to execute code when this view overlaps (or more specifically contains) with another specified view or rectangle.

The UIGestureRecognizer+DraggingAdditions category includes methods that streamline the process of animating and evaluating overlapping views.

The UIView+ZSViewAdditions category provides several supporting methods that assist with calculating whether or not certain views or rectangles overlap.

Usage:
The concept as demonstrated in the included sample project is as follows: A view hierarchy that includes one "parent" view and a variable number of subviews. One of the subviews is decorated with a UIGestureRecognizer. 

In this example, we wish to drag the decorated view according to the movement of the UIPanGestureRecognizer that decorates it. As the view is "dragged", should it at any time overlap with one of the other subviews, we wish to style the subview that "contains" the view we're dragging. At this time there is no support for intersection, whichever view is being dragged must be fully contained within the candidate/evaluation view in order to invoke the containsBlock. Additionally, if the dragged view overlaps with more than one of the candidate views, the containsBlock will return a reference to the first overlapping view that can be determined.

In the method that handles the UIPanGestureRecognizer, we invoke this method on the UIPanGestureRecognizer instance:

- (void)dragAttachedViewWithinView:(UIView *)view evaluatingOverlappingViews:(NSArray *)views contains:(void (^)(UIView *overlappingView))containsBlock completion:(void (^)(UIView *overlappingView))completionBlock;

This will animate the movement of the recognizer's decorated view within the passed view (coordinates are converted to the passed view's space). We also pass an array of "views". As the view moves with the user's finger, if the decorated view is fully contained by any one of the views in the "views" array, the containsBlock will be executed. This block carries a reference to the view that is currently overlapping/containing, giving us the opportunity to "style" that overlapping view. When the gesture ends, the completionBlock is executed (regardless of whether the decorated view currently overlaps, however, in cases where it does, a reference to the overlapping view is again provided).


The method:
- (void)dragAttachedViewWithinView:(UIView *)view evaluatingOverlappingRects:(NSArray *)rects contains:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock;

Behaves similarly, but rather than pass an array of "views", this method expects an array of NSValues, where each value boxes a CGRect. The blocks carry a reference to the index of the overlapping rectangle, as opposed to a pointer to a view instance. This allow greater flexibility, for example allowing the programmer the ability to convert rectangles or transforms to a common coordinate space, or respond to movement in arbitrary rectangles that do not represent the frame of a view.

Finally, the method:
- (void)dragLayer:(CALayer *)layer withinView:(UIView *)view evaluateOverlappingRects:(NSArray *)rects contains:(void (^)(NSUInteger overlappingIndex))containsBlock completion:(void (^)(NSUInteger overlappingIndex))completionBlock;

This method allows us to animate any given CALayer instance corresponding to the movement of the gesture, not restricted to the layer of the view that the gesture recognizer decorates. It is required that any layer you wish to animate	with this method reside in the same superlayer as the layer of the recognizer's view.
