#import <UIKit/UIKit.h>
#import "IntroView.h"

@protocol IntroControllDelegate <NSObject>

-(void)introControlSelectedIndex:(int)index;

@end


@interface IntroControll : UIView<UIScrollViewDelegate> {
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *pages;
    
    NSTimer *timer;
    int currentPhotoNum;
}

- (id)initWithFrame:(CGRect)frame pages:(NSArray<IntroModel*>*)pages;
@property(nonatomic,assign) id <IntroControllDelegate> delegate;



@end
