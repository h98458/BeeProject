//
//  MakingBoard_iPhone.m
//  School
//
//  Created by JSon-lion on 15/5/29.
//  Copyright (c) 2015年 huangrg. All rights reserved.
//

#import "MakingBoard_iPhone.h"
#import "AppBoard_iPhone.h"

@interface MakingBoard_iPhone()
{
    BeeUILabel *_title;
    BeeUIImageView *_imageView;
}
@end

@implementation MakingBoard_iPhone
SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    
}

- (void)unload
{
    
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    _imageView = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image = [UIImage imageNamed:@"webload_failed.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    _title = [[BeeUILabel alloc] initWithFrame:CGRectZero];
    _title.backgroundColor = [UIColor clearColor];
    _title.font = [UIFont systemFontOfSize:16];
    _title.text = __TEXT(@"内容正在开发中，敬请期待～");
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = [UIColor colorWithString:@"#333"];
    _title.numberOfLines = 0;
    [self.view addSubview:_title];
    
    self.view.backgroundColor = [UIColor colorWithString:@"#fff"];
    
}

ON_DELETE_VIEWS( signal )
{
    
}

ON_LAYOUT_VIEWS( signal )
{
    _imageView.frame = CGRectMake((self.width-_imageView.image.size.width)*0.5, 50, _imageView.image.size.width, _imageView.image.size.height);
    _title.frame = CGRectMake(20,_imageView.bottom+20,self.view.width-40,50);
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard_iPhone hideTabbar];
}

ON_DID_APPEAR( signal )
{
    
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -
ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

@end
