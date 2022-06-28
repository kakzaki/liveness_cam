
#import "FaceIdentifierResult.h"

#ifndef FaceIdentifierDelegate_h
#define FaceIdentifierDelegate_h

@protocol FaceIdentifierDelegate <NSObject>

- (void)faceIdentifierResult:(nonnull FaceIdentifierResult *)result;

@end

#endif /* FaceIdentifierDelegate_h */
