#import "IntroControll.h"
#import "UIImageView+AFNetworking.h"

@implementation IntroControll{
    int direction;
}


- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        
        //Initial Background images
        direction = 1;
        self.backgroundColor = [UIColor blackColor];
        
        backgroundImage1 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage1 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage1];
        
        backgroundImage2 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage2 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage2];
        
        //Initial shadow
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
        shadowImageView.contentMode = UIViewContentModeScaleToFill;
        shadowImageView.frame = CGRectMake(0, frame.size.height-200, frame.size.width, 200);
        [self addSubview:shadowImageView];
        
        //Initial ScrollView
        scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //Initial PageView
        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = pagesArray.count;
        [pageControl sizeToFit];
        [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-50)];
        [self addSubview:pageControl];
        
        //Create pages
        pages = pagesArray;
        
        scrollView.contentSize = CGSizeMake(pages.count * frame.size.width, frame.size.height);
        
        currentPhotoNum = -1;
        
        //insert TextViews into ScrollView
        for(int i = 0; i <  pages.count; i++) {
            IntroView *view = [[IntroView alloc] initWithFrame:frame model:[pages objectAtIndex:i]];
            view.frame = CGRectOffset(view.frame, i*frame.size.width, 0);
            [scrollView addSubview:view];
        }
            
        //start timer
        timer =  [NSTimer scheduledTimerWithTimeInterval:4.0
                        target:self
                        selector:@selector(tick)
                        userInfo:nil
                        repeats:YES];
        
        [self initShow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheImageView:)];
        [scrollView addGestureRecognizer:tap];

    }
    
    return self;
}

- (void) tick {
    if (currentPhotoNum + 1 == pages.count) {
        direction = -1;
    }
    if (currentPhotoNum == 0) {
        direction = 1;
    }
    [scrollView setContentOffset:CGPointMake((currentPhotoNum + direction)*self.frame.size.width, 0) animated:YES];
}

- (void) initShow {
    long scrollPhotoNumber = MAX(0, MIN(pages.count-1, (int)(scrollView.contentOffset.x / self.frame.size.width)));
    
    if(scrollPhotoNumber != currentPhotoNum) {
        currentPhotoNum = (int)scrollPhotoNumber;
        NSURL *url1 = [NSURL URLWithString:[[pages objectAtIndex:currentPhotoNum] imageUrl]];
        [backgroundImage1 setImageWithURL:url1];
        if (currentPhotoNum+1 != pages.count) {
            NSURL *url2 = [NSURL URLWithString:[[pages objectAtIndex:currentPhotoNum+1] imageUrl]];
            [backgroundImage2 setImageWithURL:url2];
        }else{
            backgroundImage2.image = nil;
        }
    }
    
    float offset =  scrollView.contentOffset.x - (currentPhotoNum * self.frame.size.width);
    
    
    //left
    if(offset < 0) {
        pageControl.currentPage = 0;
        
        offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
        backgroundImage2.alpha = 0;
        backgroundImage1.alpha = (offset / self.frame.size.width);
    
    //other
    } else if(offset != 0) {
        //last
        if(scrollPhotoNumber == pages.count-1) {
            pageControl.currentPage = pages.count-1;
            
            backgroundImage1.alpha = 1.0 - (offset / self.frame.size.width);
        } else {
            
            pageControl.currentPage = (offset > self.frame.size.width/2) ? currentPhotoNum+1 : currentPhotoNum;
            
            backgroundImage2.alpha = offset / self.frame.size.width;
            backgroundImage1.alpha = 1.0 - backgroundImage2.alpha;
        }
    //stable
    } else {
        pageControl.currentPage = currentPhotoNum;
        backgroundImage1.alpha = 1;
        backgroundImage2.alpha = 0;
    }
}


#pragma action -- 

-(void)tapTheImageView:(UITapGestureRecognizer*)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(introControlSelectedIndex:)]) {
        [_delegate introControlSelectedIndex:currentPhotoNum];
    }
}







- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    [self initShow];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll {
//    if(timer != nil) {
//        [timer invalidate];
//        timer = nil;
//    }
    [self initShow];
}

@end
