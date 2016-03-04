//
//  LoginViewController.h
//  MyDota
//
//  Created by Xiang on 16/3/3.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

-(id)initWithFinishBlock:(void(^)(NSString* token))successBlock;

@end
