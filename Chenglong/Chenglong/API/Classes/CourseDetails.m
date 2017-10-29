/*Auto generated file. Do not modify. Wed Jan 11 15:45:26 CST 2017 */

#import "CourseDetails.h"
#import "ObjectMapper.h"

@implementation CourseDetails

MapClassToArray(CourseDetails, items);

-(void)sortChild
{
    if(!self.isDirectory && self.items.count==0)
        return;
    if(self.items.count==0)
        return;
    [self.items sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CourseDetails* o1 = obj1;
        CourseDetails* o2 = obj2;
        return [o1.course.title compare:o2.course.title];
    }];
    for (CourseDetails* child in self.items) {
        [child sortChild];
    }
}
@end
