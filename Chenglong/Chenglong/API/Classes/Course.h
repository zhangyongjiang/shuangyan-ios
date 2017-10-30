/*Auto generated file. Do not modify. Wed Jan 11 15:45:26 CST 2017 */

#import "Data.h"
#import "LocalMediaContent.h"

@interface Course : Data

@property(strong, nonatomic) NSString* id;
@property(strong, nonatomic) NSNumber* created;
@property(strong, nonatomic) NSNumber* updated;
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* title;
@property(strong, nonatomic) NSString* content;
@property(strong, nonatomic) NSString* author;
@property(strong, nonatomic) NSString* parentCourseId;
@property(strong, nonatomic) NSNumber* isDir;
@property(strong, nonatomic) NSString* link;
@property(strong, nonatomic) NSNumber* ageStart;
@property(strong, nonatomic) NSNumber* ageEnd;
@property(strong, nonatomic) NSMutableArray* resources;
@property(strong, nonatomic) NSNumber* value;
@property(strong, nonatomic) NSString* originalCourseId;

-(BOOL)isAudio;
-(BOOL)isVideo;
-(BOOL)isAudioOrVideo;
-(BOOL)isPdf;
-(BOOL)isImage;
-(BOOL)isText;
-(LocalMediaContent*)localMediaContent;
@end
