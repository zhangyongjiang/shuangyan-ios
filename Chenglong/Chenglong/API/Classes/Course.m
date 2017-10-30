/*Auto generated file. Do not modify. Wed Jan 11 15:45:26 CST 2017 */

#import "Course.h"
#import "ObjectMapper.h"

@implementation Course

MapClassToArray(LocalMediaContent, resources);

-(BOOL)isAudio {
    if(self.resources == NULL || self.resources.count == 0)
        return NO;
    LocalMediaContent* lmc = [self.resources objectAtIndex:0];
    return lmc.isAudio;
}

-(BOOL)isVideo {
    if(self.resources == NULL || self.resources.count == 0)
        return NO;
    LocalMediaContent* lmc = [self.resources objectAtIndex:0];
    return lmc.isVideo;
}

-(BOOL)isPdf {
    if(self.resources == NULL || self.resources.count == 0)
        return NO;
    LocalMediaContent* lmc = [self.resources objectAtIndex:0];
    return lmc.isPdf;
}

-(BOOL)isImage {
    if(self.resources == NULL || self.resources.count == 0)
        return NO;
    LocalMediaContent* lmc = [self.resources objectAtIndex:0];
    return lmc.isImage;
}

-(BOOL)isText {
    return self.resources == NULL || self.resources.count == 0;
}

-(BOOL)isAudioOrVideo {
    return self.isAudio || self.isVideo;
}

-(LocalMediaContent*)localMediaContent {
    if(self.isText) return NULL;
    return [self.resources objectAtIndex:0];
}
@end
