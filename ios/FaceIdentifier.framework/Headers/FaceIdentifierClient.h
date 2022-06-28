
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FaceIdentifierDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceIdentifierClient : NSObject

@property (nonatomic, weak) id <FaceIdentifierDelegate> delegate;

- (void)showFaceIdentifier:(UIViewController *)parent;

@end

NS_ASSUME_NONNULL_END
