#ifndef __CRASH_LUA_EXCEPTION_HANDLER_H__
#define __CRASH_LUA_EXCEPTION_HANDLER_H__

#include "cocos2d.h"

class  CrashMasterLuaExceptionHandler
{
public:
	static void registerLuaExceptionHandler();
	static int onLuaException(lua_State* ls);
    static int leaveBreadcrumb(lua_State* ls);
    static int setUserInfo(lua_State* ls);
};

#endif  // __CRASH_LUA_EXCEPTION_HANDLER_H__

