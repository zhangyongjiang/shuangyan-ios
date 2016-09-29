/*Auto generated file. Do not modify. Thu Sep 29 23:53:34 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "Journal.h"
#import "JournalDetailsList.h"

@interface JournalApi : NSObject

+(AFHTTPRequestOperation*) JournalAPI_AddResourceToJournal:(NSDictionary*)filePart journalId:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) JournalAPI_UpdateText:(Journal*)journal onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) JournalAPI_CreateJournal:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) JournalAPI_ListUserJournals:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(JournalDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) JournalAPI_GetJournal:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) JournalAPI_RemoveJournal:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(AFHTTPRequestOperation*) JournalAPI_RemoveResources:(Journal*)journal onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;


@end
