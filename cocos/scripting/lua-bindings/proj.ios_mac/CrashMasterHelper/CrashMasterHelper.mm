#import "CrashMasterHelper.h"

bool CrashMasterHelper::_initialed = false;

void CrashMasterHelper::init(const char* ccAppkey, const char* ccChannel)
{
    CrashMasterCConfig config;
    config.enabledMonitorException = true;
    config.useLocationInfo = false;
    config.reportOnlyWIFI = true;
    config.printLogForDebug = false;
    CrashMasterHelper::init(ccAppkey, ccChannel, config);
}

void CrashMasterHelper::init(const char* ccAppkey, const char* ccChannel, CrashMasterCConfig config)
{
    if (!_initialed)
    {
        _initialed = true;
        ::cmasterInitWithConfig(ccAppkey, ccChannel, config);
    }
}

void CrashMasterHelper::reportException(int nType, const char* ccReason, const char* ccTraceback)
{
    if (!_initialed || !ccReason || !ccTraceback)
    {
        return;
    }
    ::cmasterReportException(nType, ccReason, ccTraceback);
}

void CrashMasterHelper::setUserInfo(const char* ccUserInfo)
{
    if (!_initialed || !ccUserInfo)
    {
        return;
    }
    ::cmasterSetUserInfo(ccUserInfo);
}

void CrashMasterHelper::leaveBreadcrumb(const char* ccBreadcrumb)
{
    if (!_initialed || !ccBreadcrumb)
    {
        return;
    }
    ::cmasterLeaveBreadcrumb(ccBreadcrumb);
}

void CrashMasterHelper::terminate()
{
    ::cmasterTerminate();
}

