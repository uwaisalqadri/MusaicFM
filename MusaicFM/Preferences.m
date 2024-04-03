//
//  Preferences.m
//  MusaicFM
//
//  Created by Dennis Oberhoff on 14/11/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

@import ScreenSaver;

#import "Preferences.h"

@implementation Preferences

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rows = 4;
        self.delays = 5;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (self) {
        self.lastfmUser = [decoder decodeObjectForKey:@"lastfmUser"];
        self.rows = [decoder decodeIntegerForKey:@"rows"];
        self.delays = [decoder decodeIntegerForKey:@"delays"];
        self.lastfmWeekly = [decoder decodeIntegerForKey:@"lastfmWeekly"];
        self.lastfmTag = [decoder decodeObjectForKey:@"lastfmTag"];
        self.mode = [decoder decodeIntegerForKey:@"mode"];
        self.artworks = [decoder decodeObjectForKey:@"artworks"];
        self.spotifyCode = [decoder decodeObjectForKey:@"spotifyCode"];
        self.spotifyToken = [decoder decodeObjectForKey:@"spotifyToken"];
        self.spotifyRefresh = [decoder decodeObjectForKey:@"spotifyRefresh"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeInteger:self.mode forKey:@"mode"];
    [encoder encodeObject:self.artworks forKey:@"artworks"];
    [encoder encodeObject:self.lastfmUser forKey:@"lastfmUser"];
    [encoder encodeObject:self.lastfmTag forKey:@"lastfmTag"];
    [encoder encodeObject:self.spotifyCode forKey:@"spotifyCode"];
    [encoder encodeObject:self.spotifyToken forKey:@"spotifyToken"];
    [encoder encodeObject:self.spotifyRefresh forKey:@"spotifyRefresh"];
    [encoder encodeInteger:self.rows forKey:@"rows"];
    [encoder encodeInteger:self.delays forKey:@"delays"];
    [encoder encodeInteger:self.lastfmWeekly forKey:@"lastfmWeekly"];
}

- (void)clear
{
    self.artworks = nil;
    self.spotifyToken = nil;
    self.spotifyRefresh = nil;
    self.spotifyCode = nil;
}

- (void)synchronize
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:bundleIdentifier];
    NSData *stored = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    [defaults setObject:stored forKey:@"settings"];
    [defaults synchronize];
}

+ (Preferences*)preferences
{

    static Preferences* preferences;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:bundleIdentifier];
        NSData* prefData = [defaults objectForKey:@"settings"];
        preferences = [NSKeyedUnarchiver unarchiveObjectWithData:prefData];
        if (!preferences)
            preferences = [Preferences new];
    });
    return preferences;
}

@end
