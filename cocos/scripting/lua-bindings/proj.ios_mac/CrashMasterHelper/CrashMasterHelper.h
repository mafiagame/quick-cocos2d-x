#ifndef __CRASH_HELPER_H__
#define __CRASH_HELPER_H__

#include "CrashMasterC.h"

class CrashMasterHelper
{
private:
    static bool _initialed;
    
public:
    static void init(const char* ccAppkey, const char* ccChannel);
    
    static void init(const char* ccAppkey, const char* ccChannel, CrashMasterCConfig config);
    
    static void reportException(int nType, const char* ccReason, const char* ccTraceback);
    
    static void setUserInfo(const char* ccUserInfo);
    
    static void leaveBreadcrumb(const char* ccBreadcrumb);
    
    static void terminate();
};

#endif //__CRASH_HELPER_H__
