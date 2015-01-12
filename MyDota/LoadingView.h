//
//  LoadingView.h
//  Map
//
//  Created by yiwugou on 13-3-20.
//  Copyright (c) 2013年 LEEMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
-(void)show;
-(id)initWithFailView;
-(id)initWithString:(NSString*)str;
-(void)startLoading;
@end
