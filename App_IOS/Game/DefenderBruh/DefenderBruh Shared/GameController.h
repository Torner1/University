//
//  GameController.h
//  DefenderBruh Shared
//
//  Created by Doro Jim on 30/01/2025.
//

#import <SceneKit/SceneKit.h>


@interface GameController : NSObject <SCNSceneRendererDelegate>

@property (strong, readonly) SCNScene *scene;
@property (strong, readonly) id <SCNSceneRenderer> sceneRenderer;

- (instancetype)initWithSceneRenderer:(id <SCNSceneRenderer>)sceneRenderer;

- (void)highlightNodesAtPoint:(CGPoint)point;

@end
