//
//  GameManager.h
//  spaceViking_1_0_1
//
//  Created by Mac Owner on 1/27/13.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SimpleAudioEngine.h"


@interface GameManager : NSObject
{
BOOL isMusicON;
BOOL isSoundEffectsON;
BOOL hasPlayerDied;
SceneTypes currentScene;
NSUInteger counterKill;
    
    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
}


@property (readwrite) GameManagerSoundState managerSoundState;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;


@property (readwrite,assign) NSUInteger counterKill;
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL hasPlayerDied;

+(GameManager*)sharedGameManager; // 1
-(void)runSceneWithID:(SceneTypes)sceneID; // 2
-(void)openSiteWithLinkType:(LinkTypes)linkTypeToOpen ;


-(void)setupAudioEngine;
-(ALuint)playSoundEffect:(NSString*)soundEffectKey;
-(void)stopSoundEffect:(ALuint)soundEffectID;
-(void)playBackgroundTrack:(NSString*)trackFileName;
-(CGSize)getDimensionsOfCurrentScene;

@end
