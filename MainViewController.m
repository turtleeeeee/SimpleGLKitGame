//
//  MainViewController.m
//  SimpleGLKitGame
//
//  Created by Turtleeeeeeeeee on 15/11/4.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property(strong, nonatomic) EAGLContext *context;
@property(strong) GLKBaseEffect *effect;
@property(strong) Sprite *player;
@property(strong) NSMutableArray *children;
@property(assign) float timeSinceLastSpawn;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create OpenGL ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    _effect = [[GLKBaseEffect alloc] init];
    GLKMatrix4 projectionMatirx = GLKMatrix4MakeOrtho(0, screenSize.width, 0, screenSize.height, -1024, 1024);
    _effect.transform.projectionMatrix = projectionMatirx;
    
    _player = [[Sprite alloc] initWithFile:@"Player.png" effect:_effect];
    _player.position = GLKVector2Make(_player.contentSize.width / 2, screenSize.height / 2);
    
    _children = [NSMutableArray array];
    [_children addObject:_player];
//    _player.moveVelocity = GLKVector2Make(50, 50);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    for (Sprite *sprite in _children) {
        [sprite render];
    }
}

- (void)addTarget {
    Sprite *target = [[Sprite alloc] initWithFile:@"Target.png" effect:_effect];
    [_children addObject:target];
    
    int minY = target.contentSize.height / 2;
    int maxY = 320 - target.contentSize.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    target.position = GLKVector2Make(480, actualY);
    
    int minVelocity = 480.0 / 4.0;
    int maxVelocity = 480.0 / 2.0;
    int rangeVelocity = maxVelocity - minVelocity;
    int actualVelocity = (arc4random() % rangeVelocity) + minVelocity;
    
    target.moveVelocity = GLKVector2Make(-actualVelocity, 0);
}

- (void)update{
    _timeSinceLastSpawn += self.timeSinceLastUpdate;
    if (_timeSinceLastSpawn > 1.0) {
        _timeSinceLastSpawn = 0;
        [self addTarget];
    }
    for (Sprite *sprite in _children) {
        [sprite update:self.timeSinceLastUpdate];
    }
}
@end
