//
//  PerformSelector.h
//  7.14-HTML_object-c_interaction
//
//  Created by linyibin on 15/7/14.
//  Copyright (c) 2015年 NXAristotle. All rights reserved.
//



#ifndef __14_HTML_object_c_interaction_PerformSelector_h
#define __14_HTML_object_c_interaction_PerformSelector_h


#endif
//------------------------------------------------------------------------------
// 执行SEL
#define performSelector(method) if ([self respondsToSelector:method]) { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
[self performSelector:method]; \
_Pragma("clang diagnostic pop") \
}

// 执行带参数的SEL
#define performSelectorWith(method, obj) if ([self respondsToSelector:method]) { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
[self performSelector:method withObject:obj]; \
_Pragma("clang diagnostic pop") \
}





