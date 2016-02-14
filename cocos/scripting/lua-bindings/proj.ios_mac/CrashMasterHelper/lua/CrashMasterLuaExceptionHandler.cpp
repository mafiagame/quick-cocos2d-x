#include <string.h>
#include "CrashMasterLuaExceptionHandler.h"
#include "../CrashMasterHelper.h"
#include "CCLuaEngine.h"


void CrashMasterLuaExceptionHandler::registerLuaExceptionHandler() {
#if COCOS2D_VERSION >= 0x00030000
	lua_State* ls = cocos2d::LuaEngine::getInstance()->getLuaStack()->getLuaState(); 
#else
	lua_State* ls = cocos2d::CCLuaEngine::defaultEngine()->getLuaStack()->getLuaState(); 
#endif
	lua_register(ls, "onLuaException", onLuaException);
    lua_register(ls, "leaveBreadcrumb", leaveBreadcrumb);
    lua_register(ls, "setUserInfo", setUserInfo);
}

int CrashMasterLuaExceptionHandler::onLuaException(lua_State* ls) {
	const char* brief = lua_tostring(ls, 1); 
	const char* traceback = lua_tostring(ls, 2); 
	CrashMasterHelper::reportException(CMASTER_TYPE_LUA, brief, traceback);

	return 0;
}

int CrashMasterLuaExceptionHandler::leaveBreadcrumb(lua_State* ls){
    const char* ccBreadcrumb = lua_tostring(ls, 1);
    CrashMasterHelper::leaveBreadcrumb(ccBreadcrumb);
    
    return 0;
}

int CrashMasterLuaExceptionHandler::setUserInfo(lua_State* ls) {
    const char* ccUserinfo = lua_tostring(ls, 1);
    CrashMasterHelper::setUserInfo(ccUserinfo);
    
    return 0;
}



