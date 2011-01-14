//
//  Menulet.h
//  HostfileManager
//
//  Created by ezarko on 11/23/10.
//  Copyright 2010 Synacor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Menulet : NSObject {
    NSStatusItem *statusItem;
	AuthorizationRef auth;
	NSMenu *theMenu;
}

-(NSArray *) status;
-(IBAction)refresh:(id)sender;
-(IBAction)toggleFragment:(id)sender;

@end
