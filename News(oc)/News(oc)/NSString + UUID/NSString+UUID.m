#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString *)stringWithUUID {

    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (NSString *)stringWithUniquePath {
    NSString *unique = [NSString stringWithUUID];
    return [NSTemporaryDirectory() stringByAppendingPathComponent: unique];
}

@end
