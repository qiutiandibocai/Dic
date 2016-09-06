//
//  PYJSTableViewCell.h
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/22.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYJSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *wordImageView;
@property (weak, nonatomic) IBOutlet UILabel *wordNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *duyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *bushouLabel;
@property (weak, nonatomic) IBOutlet UILabel *bihuaLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;

@end
