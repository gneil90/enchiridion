//
//  GameManager.m
//  spaceViking_1_0_1
//
//  Created by Mac Owner on 1/27/13.
//
//

#import "GameManager.h"
#import "cocos2d.h"
#import "Constants.h"

@implementation GameManager
static GameManager* _sharedGameManager = nil;                      
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize hasPlayerDied;
@synthesize counterKill;
@synthesize managerSoundState;
@synthesize listOfSoundEffectFiles;
@synthesize soundEffectsState;


+(GameManager*)sharedGameManager {
    @synchronized([GameManager class]) // 2
    {
        if(!_sharedGameManager) // 3
            [[self alloc] init];
        return _sharedGameManager; // 4
    }
    return nil;
}
+(id)alloc
{
    //Defines a synchronized block. This ensures that even if two class instances call
    //this method at the same time, only one will go through at a time. This code
    //becomes really important when you have a multithreaded app or game and you
    //have the risk of executing the same code block by two different class instances
    //(such as a scene and another object).
    @synchronized ([GameManager class])                            // 5
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton");                                          // 6
        _sharedGameManager = [super alloc];
        return _sharedGameManager;                                 // 7
    }
    return nil;
}
-(id)init { //
            self = [super init];
            if (self != nil) {
                         // Game Manager initialized
                         CCLOG(@"Game Manager Singleton, init");
                    hasAudioBeenInitialized = NO;
                    soundEngine = nil;
                    managerSoundState = kAudioManagerUninitialized;
                         isMusicON = YES;
                         isSoundEffectsON = YES;
                         hasPlayerDied = NO;
                         currentScene = kNoSceneUninitialized;
                         counterKill=0;
                     }
                     return self;
                 }
                 
                 
                 
-(void)runSceneWithID:(SceneTypes)sceneID {
                     SceneTypes oldScene = currentScene;
                     currentScene = sceneID;
                     id sceneToRun = nil;
                     switch (sceneID) {
                                                                    
                         default:
                             CCLOG(@"Unknown ID, cannot switch scenes");
                             return;
                             break;
                     }
    
    if (sceneToRun == nil) {
        // Revert back, since no new scene was found
        currentScene = oldScene;
        return;
    }
    

    
    
    
    // Menu Scenes have a value of < 100
       
    [self performSelectorInBackground:
     @selector(loadAudioForSceneWithID:)
                           withObject:[NSNumber
                                       numberWithInt: currentScene]];
    /*if ((sceneID < 100)&&(sceneID!=4)) {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            CGSize screenSize = [CCDirector sharedDirector].winSizeInPixels;
            if (screenSize.width == 960.0f) {
                // iPhone 4 Retina
                [sceneToRun setScaleX:0.9375f];
                [sceneToRun setScaleY:0.8333f];
                CCLOG(@"GameMgr:Scaling for iPhone 4 (retina)");
                
            } else {
                [sceneToRun setScaleX:0.4688f];
                [sceneToRun setScaleY:0.4166f];
                CCLOG(@"GameMgr:Scaling for iPhone 3GS or older (non-retina)");
                
            }
        }
    }*/
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
        
    } else {
        
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }

    
    [self performSelectorInBackground:
     @selector(unloadAudioForSceneWithID:)
                           withObject:[NSNumber
                                       numberWithInt: oldScene]];
    currentScene = sceneID;

}

                 
-(void)openSiteWithLinkType:(LinkTypes)linkTypeToOpen {
                     NSURL *urlToOpen = nil;
                     if (linkTypeToOpen == kLinkTypeBookSite) {
                         CCLOG(@"Opening Book Site");
                         urlToOpen =
                         [NSURL URLWithString:
                          @"http://www.informit.com/title/9780321735621"];
                     } else if (linkTypeToOpen == kLinkTypeDeveloperSiteRod) {
                         CCLOG(@"Opening Developer Site for Rod");
                         urlToOpen = [NSURL URLWithString:@"http://www.prop.gr"];
                     } else if (linkTypeToOpen == kLinkTypeDeveloperSiteRay) {
                         CCLOG(@"Opening Developer Site for Ray");
                         urlToOpen =
                         [NSURL URLWithString:@"http://www.raywenderlich.com/"];
                     } else if (linkTypeToOpen == kLinkTypeArtistSite) {
                         CCLOG(@"Opening Artist Site");
                         urlToOpen = [NSURL URLWithString:@"http://EricStevensArt.com"];
                     } else if (linkTypeToOpen == kLinkTypeMusicianSite) {
                         CCLOG(@"Opening Musician Site");
                         urlToOpen =
                         [NSURL URLWithString:@"http://www.mikeweisermusic.com/"];
                     } else {
                         CCLOG(@"Defaulting to Cocos2DBook.com Blog Site");
                         urlToOpen = 
                         [NSURL URLWithString:@"http://www.cocos2dbook.com"];
                     }
                     
                     if (![[UIApplication sharedApplication] openURL:urlToOpen]) {
                         CCLOG(@"%@%@",@"Failed to open url:",[urlToOpen description]);
                         [self runSceneWithID:kMainMenuScene];
                     }    
                 }


#pragma mark - AudioEngine


-(void)setupAudioEngine {
    if (hasAudioBeenInitialized == YES) {
        return;
    } else {
        hasAudioBeenInitialized = YES;
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *asyncSetupOperation =
        [[NSInvocationOperation alloc] initWithTarget:self
                                             selector:@selector(initAudioAsync)
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
    }
}

-(void)initAudioAsync {
    // Initializes the audio engine asynchronously
    managerSoundState = kAudioManagerInitializing;
    // Indicate that we are trying to start up the Audio Manager
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    //Init audio manager asynchronously as it can take a few seconds
    //The FXPlusMusicIfNoOtherAudio mode will check if the user is
    // playing music and disable background music playback if
    // that is the case.
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    //Wait for the audio manager to initialize
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    //At this point the CocosDenshion should be initialized
    // Grab the CDAudioManager and check the state
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed;
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready");
    }
}


- (NSString*)formatSceneTypeToString:(SceneTypes)sceneID {
    NSString *result = nil;
    switch(sceneID) {
        case kNoSceneUninitialized:
            result = @"kNoSceneUninitialized";
            break;
        case kMainMenuScene:
            result = @"kMainMenuScene";
            break;
        case kOptionsScene:
            result = @"kOptionsScene";
            break;
        case kCreditsScene:
            result = @"kCreditsScene";
            break;
        case kIntroScene:
            result = @"kIntroScene";
            break;
        case kLevelCompleteScene:
            result = @"kLevelCompleteScene";
            break;
        case kGameLevel1:
            result = @"kGameLevel1";
            break;
        case kGameLevel2:
            result = @"kGameLevel2";
            break;
        case kGameLevel3:
            result = @"kGameLevel3";
            break;
        case kGameLevel4:
            result = @"kGameLevel4";
            break;
        case kGameLevel5:
            result = @"kGameLevel5";
            break;
        case kCutSceneForLevel2:
            result = @"kCutSceneForLevel2";
            break;
        default:
            [NSException raise:NSGenericException format:@"UnexpectedSceneType."];
             }
             return result;
             }


-(NSDictionary *)getSoundEffectsListForSceneWithID:(SceneTypes)sceneID {
    NSString *fullFileName = @"SoundEffects.plist";
    NSString *plistPath;
    // 1: Get the Path to the plist file
    NSString *rootPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES)
     objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:@"SoundEffects" ofType:@"plist"];
    }
    // 2: Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading SoundEffects.plist");
        return nil; // No Plist Dictionary or file found
    }
    // 4. If the list of soundEffectFiles is empty, load it
    if ((listOfSoundEffectFiles == nil) ||
        ([listOfSoundEffectFiles count] < 1)) {
        NSLog(@"Before");
        [self setListOfSoundEffectFiles:
         [[NSMutableDictionary alloc] init]];
        NSLog(@"after");
        for (NSString *sceneSoundDictionary in plistDictionary) {
            [listOfSoundEffectFiles
             addEntriesFromDictionary:
             [plistDictionary objectForKey:sceneSoundDictionary]];
        }
        CCLOG(@"Number of SFX filenames:%d",
              [listOfSoundEffectFiles count]);
    }
    // 5. Load the list of sound effects state, mark them as unloaded
    if ((soundEffectsState == nil) ||
        ([soundEffectsState count] < 1)) {
        [self setSoundEffectsState:[[NSMutableDictionary alloc] init]];
        for (NSString *SoundEffectKey in listOfSoundEffectFiles) {
            [soundEffectsState setObject:[NSNumber
                                          numberWithBool:SFX_NOTLOADED] forKey:SoundEffectKey];
        }
    }
    // 6. Return just the mini SFX list for this scene
    NSString *sceneIDName = [self formatSceneTypeToString:sceneID];
    NSDictionary *soundEffectsList =
    [plistDictionary objectForKey:sceneIDName];
    return soundEffectsList;
}



-(void)loadAudioForSceneWithID:(NSNumber*)sceneIDNumber {
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    // 1
    if (managerSoundState == kAudioManagerInitializing) {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) ||
                (managerSoundState == kAudioManagerFailed)) {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    if (managerSoundState == kAudioManagerFailed) {
        return; // Nothing to load, CocosDenshion not ready
    }
    NSDictionary *soundEffectsToLoad =
    [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToLoad == nil) { // 2
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    // Get all of the entries and PreLoad // 3
    for( NSString *keyString in soundEffectsToLoad )
    {
        CCLOG(@"\nLoading Audio Key:%@ File:%@",
              keyString,[soundEffectsToLoad objectForKey:keyString]);
        [soundEngine preloadEffect:
         [soundEffectsToLoad objectForKey:keyString]]; // 3
        // 4
        [soundEffectsState setObject:
         [NSNumber numberWithBool:SFX_LOADED] forKey:keyString];
    }
}


-(void)unloadAudioForSceneWithID:(NSNumber*)sceneIDNumber {
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    if (sceneID == kNoSceneUninitialized) {
        return; // Nothing to unload
    }
    NSDictionary *soundEffectsToUnload =
    [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToUnload == nil) {
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    if (managerSoundState == kAudioManagerReady) {
        // Get all of the entries and unload
        for( NSString *keyString in soundEffectsToUnload )
        {
            [soundEffectsState setObject:
             [NSNumber numberWithBool:SFX_NOTLOADED] forKey:keyString];
            [soundEngine unloadEffect:keyString];
            CCLOG(@"\nUnloading Audio Key:%@ File:%@",
                  keyString,
                  [soundEffectsToUnload objectForKey:keyString]);
        }
    }
}


-(void)playBackgroundTrack:(NSString*)trackFileName {
    if (isMusicON) {
    // Wait to make sure soundEngine is initialized
    if ((managerSoundState != kAudioManagerReady) &&
        (managerSoundState != kAudioManagerFailed)) {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) ||
                (managerSoundState == kAudioManagerFailed)) {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    if (managerSoundState == kAudioManagerReady) {
        if ([soundEngine isBackgroundMusicPlaying]) {
            [soundEngine stopBackgroundMusic];
        }
        [soundEngine preloadBackgroundMusic:trackFileName];
        [soundEngine playBackgroundMusic:trackFileName loop:YES];
    }
    }
    else
    {
        CCLOG(@"music is Off");
    }
}

-(void)stopSoundEffect:(ALuint)soundEffectID {
    if (managerSoundState == kAudioManagerReady) {
        [soundEngine stopEffect:soundEffectID];
    }
}


-(ALuint)playSoundEffect:(NSString*)soundEffectKey {
    ALuint soundID = 0;
    if (managerSoundState == kAudioManagerReady) {
        NSNumber *isSFXLoaded =
        [soundEffectsState objectForKey:soundEffectKey];
        if ([isSFXLoaded boolValue] == SFX_LOADED) {
            soundID =
            [soundEngine playEffect:
             [listOfSoundEffectFiles objectForKey:soundEffectKey]];
        } else {
            CCLOG(@"GameMgr: SoundEffect %@ is not loaded.",
                  soundEffectKey);
        }
    } else {
        CCLOG(@"GameMgr: Sound Manager is not ready, cannot play %@",
              soundEffectKey);
    }
    return soundID;
}

#pragma mark - Dimension Stuff
-(CGSize)getDimensionsOfCurrentScene {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize;
    switch (currentScene) {
        case kMainMenuScene:
        case kOptionsScene:
        case kCreditsScene:
        case kIntroScene:
        case kLevelCompleteScene:
        case kGameLevel1:
            levelSize =screenSize;
            
            break;
        case kGameLevel2:
           
            levelSize = CGSizeMake(screenSize.width*4.0f,
                                   screenSize.height);
            break;
        default:
            CCLOG(@"Unknown Scene ID, returning default size");
            levelSize = screenSize;
            break;
    }
    return levelSize;
}

@end
