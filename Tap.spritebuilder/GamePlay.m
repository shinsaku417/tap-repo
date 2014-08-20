//
//  GamePlay.m
//  Tap
//
//  Created by Shinsaku Uesugi on 8/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"

@implementation GamePlay {
    CCNodeColor *_whiteNode;
    CCNodeColor *_centerBar;
    
    // State of the game: 0 = background is white, 1 = background = black
    int _state;
    
    // Score system
    int _score;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_scoreMessage;
    
    // Timer system
    int _time;
    CCLabelTTF *_timer;
    
    // Multiplier System
    int _multiplier;
    CCLabelTTF *_multiplierLabel;
    CCLabelTTF *_xLabel;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = true;
}

- (void)onEnter {
    [super onEnter];
    
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    [gameState setBool:false forKey:@"movescoreten"];
    [gameState setBool:false forKey:@"movescorehundred"];
    [gameState setBool:false forKey:@"movescorethousand"];
    [gameState setBool:false forKey:@"moveten"];
    [gameState setBool:false forKey:@"movehundred"];
    
    _multiplier = 0;
    _state = 0;
    _time = 30;
    
    [self schedule:@selector(changeState) interval:0.5f];
    [self schedule:@selector(timerUpdate) interval:1.f];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    NSLog(@"%f self", self.contentSize.width / 2);
    NSLog(@"%f center", _centerBar.contentSize.width / 2);
    
    if ((_state == 0 && touchLocation.x < self.contentSize.width / 2 - _centerBar.contentSize.width / 2) || (_state == 1 && touchLocation.x > self.contentSize.width / 2 + _centerBar.contentSize.width / 2)) {
        _multiplier ++;
        _score += _multiplier;
        _multiplierLabel.string = [NSString stringWithFormat:@"%i",_multiplier];
        _scoreLabel.string = [NSString stringWithFormat:@"%i",_score];
    } else {
        _multiplier = 0;
        _multiplierLabel.string = [NSString stringWithFormat:@"%i",_multiplier];
    }
}

// Every 0.5s, 25% chance of changing the state
- (void)changeState {
    int rngChange = arc4random() % 4;
    if (_state == 0 && rngChange == 0) {
        _state = 1;
        _whiteNode.opacity = 0;
        _centerBar.color = [CCColor whiteColor];
        _scoreMessage.color = [CCColor whiteColor];
        _scoreLabel.color = [CCColor whiteColor];
        _multiplierLabel.color = [CCColor whiteColor];
        _xLabel.color = [CCColor whiteColor];
        _timer.color = [CCColor blackColor];
    } else if (_state == 1 && rngChange ==0) {
        _state = 0;
        _whiteNode.opacity = 1;
        _centerBar.color = [CCColor blackColor];
        _scoreMessage.color = [CCColor blackColor];
        _scoreLabel.color = [CCColor blackColor];
        _multiplierLabel.color = [CCColor blackColor];
        _xLabel.color = [CCColor blackColor];
        _timer.color = [CCColor whiteColor];
    }
}

// Update timer
// When time = 0, go to the next scene.
- (void)timerUpdate {
    _time--;
    _timer.string = [NSString stringWithFormat:@"%i", _time];
    if (_time < 10) {
        [self unschedule:@selector(changeState)];
        [self schedule:@selector(changeState) interval:0.25f];
    }
    if (_time == 0) {
        NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
        [gameState setInteger:_score forKey:@"score"];
        if ([gameState integerForKey:@"score"] > [gameState integerForKey:@"highscore"]) {
            [gameState setInteger:_score forKey:@"highscore"];
        }
        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        [[CCDirector sharedDirector] presentScene:recapScene];
    }
}

- (void)update:(CCTime)delta {
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    if (_score > 10 && [gameState boolForKey:@"movescoreten"] == false) {
        _scoreLabel.position = ccp(_scoreLabel.position.x - 0.01, _scoreLabel.position.y);
        [gameState setBool:true forKey:@"movescoreten"];
    } else if (_score > 100 && [gameState boolForKey:@"movescorehundred"] == false) {
        _scoreLabel.position = ccp(_scoreLabel.position.x - 0.02, _scoreLabel.position.y);
        [gameState setBool:true forKey:@"movescorehundred"];
    } else if (_score > 1000 && [gameState boolForKey:@"movescorethousand"] == false) {
        _scoreLabel.position = ccp(_scoreLabel.position.x - 0.03, _scoreLabel.position.y);
        [gameState setBool:true forKey:@"movescorethousand"];
    }
    
    if (_multiplier == 10 && [gameState boolForKey:@"moveten"] == false) {
        _xLabel.position = ccp(_xLabel.position.x + 0.02, _xLabel.position.y);
        [gameState setBool:true forKey:@"moveten"];
    } else if (_multiplier == 100 && [gameState boolForKey:@"movehundred"] == false) {
        _xLabel.position = ccp(_xLabel.position.x + 0.02, _xLabel.position.y);
        [gameState setBool:true forKey:@"movehundred"];
    }
}

@end
