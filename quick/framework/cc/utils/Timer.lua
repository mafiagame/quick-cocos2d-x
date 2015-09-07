
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local socket = require("socket")

--[[--

Timer 实现了一个计时器容器，用于跟踪应用中所有需要计时的事件。

]]
local Timer = {}

--[[--

创建一个计时器。

**Returns:**

-   Timer 对象

]]
function Timer.new()
    local timer = {}
    local eventProtocol = cc(timer):addComponent("components.behavior.EventProtocol"):exportMethods()

    ----

    local handle     = nil
    local countdowns = {}
    local lastTime = nil

    local _addEventListener = eventProtocol.addEventListener
    function eventProtocol:addEventListener(name,listener,...)
        local handler = _addEventListener(self,name,listener,...)
        if countdowns[name] then
            eventProtocol:dispatchEvent({name = name,countdown = countdowns[name]["countdown"],time = actions.getTime()})
        end
        return handler
    end

    ----

    -- countdown type
    local forever = 1
    local not_forever = 2
    --[[--
    @ignore
    ]]
    local function onTimer(dt)
        local curTime = socket.gettime()
        local mark = false
        if ( curTime - lastTime ) >= 1 then
            mark = true
        end

        if mark then
            for eventName, cd in pairs(countdowns) do
                if cd.type == forever then
                    cd.countdown = cd.countdown - (curTime - lastTime)
                    if cd.countdown <= 0 then
                        timer:dispatchEvent({name = eventName, countdown = cd.countdown , time = actions.getTime()})
                        cd.countdown = cd.interval
                    end
                else
                    cd.countdown = cd.countdown - (curTime - lastTime)

                    if not cd.mute then
                        timer:dispatchEvent({name = eventName, countdown = cd.countdown , time = actions.getTime()})
                    end

                    if cd.countdown <= 0 then
                        timer:dispatchEvent({name = eventName,countdown = cd.countdown ,time = actions.getTime()})
                        print(string.format("[finish] %s", eventName))
                        timer:removeCountdown(eventName)
                    end
                end
            end
            lastTime = curTime
        end
    end

    ----

    --[[--

    添加一个计时器。

    在计时器倒计时完成前，会按照 **interval** 参数指定的时间间隔触发 **eventName** 参数指定的事件。
    事件参数则是倒计时还剩余的时间。

    在计时器倒计时完成后，同样会触发 **eventName** 参数指定的事件。此时事件的参数是 0，表示倒计时完成。

    因此在事件处理函数中，可以通过事件参数判断倒计时是否已经结束：

    local Timer = require("framework.cc.utils.Timer")
    local appTimer = Timer.new()

    -- 响应 CITYHALL_UPGRADE_TIMER 事件
    local function onCityHallUpgradeTimer(event)
    if event.countdown > 0 then
    -- 倒计时还未结束，更新用户界面上显示的时间
    ....
    else
    -- 倒计时已经结束，更新用户界面显示升级后的城防大厅
    end
    end

    -- 注册事件
    appTimer:addEventListener("CITYHALL_UPGRADE_TIMER", onCityHallUpgradeTimer)
    -- 城防大厅升级需要 3600 秒，每 30 秒更新一次界面显示
    appTimer:addCountdown("CITYHALL_UPGRADE_TIMER", 3600, 30)

    考虑移动设备的特殊性，计时器可能存在一定误差，所以 **interval** 参数的最小值是 2 秒。
    在界面上需要显示倒计时的地方，应该以“分”为单位。例如显示为“2 小时 23 分”，这样可以避免误差带来的问题。

    ### 注意

    计时器在倒计时结束并触发事件后，会自动删除。关联到这个计时器的所有事件处理函数也会被取消。


    **Parameters:**

    -   eventName: 计时器事件的名称
    -   countdown: 倒计时（秒）
    -   interval（可选）: 检查倒计时的时间间隔，最小为 2 秒，最长为 120 秒，如果未指定则默认为 30 秒

    ]]
    function timer:addCountdown(eventName, countdown, interval,mute)
        mute = mute or false
        eventName = tostring(eventName)
        if countdowns[eventName] then
            timer:dispatchEvent({name = eventName, countdown = countdown , time = actions.getTime()})
            return
        end
        assert(not countdowns[eventName], "eventName '" .. eventName .. "' exists")
        local _type = not_forever
        if countdown == nil or countdown == -1 then
            countdown = 0
            _type = forever
        end
        -- assert(type(countdown) == "number","invalid countdown")

        countdowns[eventName] = {
            countdown = countdown,
            interval  = interval,
            mute      = mute,
            type      = _type
        }

        timer:dispatchEvent({name = eventName, countdown = countdown , time = actions.getTime()})
    end

    --[[--

    删除指定事件名称对应的计时器，并取消这个计时器的所有事件处理函数。

    **Parameters:**

    -   eventName: 计时器事件的名称

    ]]
    function timer:removeCountdown(eventName)
        eventName = tostring(eventName)
        countdowns[eventName] = nil
        self:removeEventListenersByEvent(eventName)
    end

    --[[--

    启动计时器容器。

    在开始游戏时调用这个方法，确保所有的计时器事件都正确触发。

    ]]
    function timer:start()
        if not handle then
            lastTime = socket.gettime()
            handle = scheduler.scheduleGlobal(onTimer, 1.0, false)
        end
    end

    --[[--

    停止计时器容器。

    ]]
    function timer:stop()
        if handle then
            scheduler.unscheduleGlobal(handle)
            handle = nil
            lastTime = nil
        end
    end

    function timer:clearCountdowns()
        countdowns = {}
    end

    return timer
end

cc = cc or {}
cc.utils = cc.utils or {}
cc.utils.Timer = Timer

return Timer
