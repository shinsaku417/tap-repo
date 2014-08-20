//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Shinsaku Uesugi on 8/20/14.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene {
    CCLabelTTF *_tap;
    CCLabelTTF *_pro;
    CCButton *_playButton;
}

- (void)onEnter {
    [super onEnter];
    
    [self bounce:_tap];
    [self bounce:_pro];
    
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:1.0f position:ccp(_playButton.position.x, 0.5)];
    CCActionEaseBounceOut *bounceOut = [CCActionEaseBounceOut actionWithAction:moveTo];
    [_playButton runAction:bounceOut];
}

- (void)bounce:(CCSprite *)sprite {
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:1.0f position:ccp(0.5, sprite.position.y)];
    CCActionEaseBounceOut *bounceOut = [CCActionEaseBounceOut actionWithAction:moveTo];
    [sprite runAction:bounceOut];
}

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
}

@end
