#import "IntroModel.h"

@implementation IntroModel


- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageUrl {
    self = [super init];
    if(self != nil) {
        _titleText = title;
        _descriptionText = desc;
        _imageUrl = imageUrl;
    }
    return self;
}

@end
