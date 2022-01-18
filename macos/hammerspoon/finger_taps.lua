local touchdevice = require("hs._asm.undocumented.touchdevice")
local eventtap    = require("hs.eventtap")

--- middleButton.rescan() -> module
--- Function
--- Rescans for multi touch devices and starts watchers for those detected.
---
--- Parameters:
---  * None
---
--- Returns:
---  * the module
---
--- Notes:
---  * this function is invoked when you select the "Scan for Multitouch devices" from the menu.
---
---  * `hs._asm.undocumented.touchdevice` cannot currently detect when multitouch devices are removed or added, so this function can be used to update the watchers if you add or remove a device.
---    * this is expected to change soon and this function may disappear at that time.
module.rescan = function()
    -- clear the current callbacks
    for _, v in ipairs(_attachedDeviceCallbacks) do v:stop() end
    _attachedDeviceCallbacks = {}

    -- if we're running, start up new callbcaks for all currently attached devices
    if _menu then
        for _, v in ipairs(touchdevice.devices()) do
            table.insert(
                _attachedDeviceCallbacks,
                touchdevice.forDeviceID(v):frameCallback(function(_, touches, _, _)
                    local nFingers = #touches

                    if (_needToClick) then
                        _enoughDown = (nFingers == _fingers)
                    else
                        if nFingers == 0 then
                            if _middleclickPoint and _middleclickPoint2 then
                                local delta = math.abs(_middleclickPoint.x - _middleclickPoint2.x) +
                                              math.abs(_middleclickPoint.y - _middleclickPoint2.y)
                                if delta < _tapDelta then
                                    -- empty events default to current mouse location
                                    local nullEvent = eventtap.event.newEvent()
                                    eventtap.middleClick(nullEvent:location())
                                elseif module._debugDelta then
                                    print(string.format("%s - tap delta mismatch: want < %f, got %f", USERDATA_TAG, _tapDelta, delta))
                                end
                            end
                            _touchStartTime    = nil
                            _middleclickPoint  = nil
                            _middleclickPoint2 = nil
                        elseif nFingers > 0 and not _touchStartTime then
                            _touchStartTime   = timer.secondsSinceEpoch()
                            _maybeMiddleClick = true
                            _middleclickPoint = { x = 0, y = 0 }
                        elseif _maybeMiddleClick then
                            local elapsedTime = timer.secondsSinceEpoch() - _touchStartTime
                            if elapsedTime > .5 then
                                _maybeMiddleClick  = false
                                _middleclickPoint  = nil
                                _middleclickPoint2 = nil
                            end
                        end

                        if nFingers > _fingers then
                            _maybeMiddleClick  = false
                            _middleclickPoint  = nil
                            _middleclickPoint2 = nil
                        elseif nFingers == _fingers then
                            local xAggregate = touches[1].absoluteVector.position.x +
                                               touches[2].absoluteVector.position.x +
                                               touches[3].absoluteVector.position.x
                            local yAggregate = touches[1].absoluteVector.position.y +
                                               touches[2].absoluteVector.position.y +
                                               touches[3].absoluteVector.position.y

                            if _maybeMiddleClick then
                                _middleclickPoint  = { x = xAggregate, y = yAggregate }
                                _middleclickPoint2 = { x = xAggregate, y = yAggregate }
                                _maybeMiddleClick  = false;
                            else
                                _middleclickPoint2 = { x = xAggregate, y = yAggregate }
                            end
                        end
                    end
                end):start()
            )
        end
    end
    return module
end

--- middleButton.start() -> module
--- Function
--- Starts watching the currently attached multitouch devices for finger clicks and taps to determine if they should be converted into middle button mouse clicks.
---
--- Parameters:
---  * None
---
--- Returns:
---  * the module
---
--- Notes:
---  * if the menu has not previously been hidden by invoking `middleButton.toggleMenu()` or selecting "Hide menu" from the menu, the menu will also be created when this function is invoked.
module.start = function()
    if not _menu then
        module.rescan() -- will attach all currently attached devices
        _leftClickTap = eventtap.new({ eventTypes.leftMouseDown, eventTypes.leftMouseUp }, function(event)
            if _needToClick then
                local eType = event:getType()
                if _enoughDown and eType == eventTypes.leftMouseDown then
                    _wasEnoughDown = true
                    _enoughDown    = false
                    return true, {
                        eventtap.event.newMouseEvent(
                                eventTypes.otherMouseDown,
                                event:location()
                            ):rawFlags(event:rawFlags())
                             :setProperty(eventProperties.mouseEventButtonNumber, 2)
                    }
                elseif _wasEnoughDown and eType == eventTypes.leftMouseUp then
                    _wasEnoughDown = false
                    return true, {
                        eventtap.event.newMouseEvent(
                                eventTypes.otherMouseUp,
                                event:location()
                            ):rawFlags(event:rawFlags())
                             :setProperty(eventProperties.mouseEventButtonNumber, 2)
                    }
                end
            end
            return false
        end)
        if _needToClick then _leftClickTap:start() end

        _sleepWatcher = caffeinate.watcher.new(function(event)
            if event == caffeinate.watcher.systemDidWake then
                module.rescan()
            end
        end):start()
        -- _deviceWatcher = hasTDWatcher and touchdevice.watcher.new(function(...)
        _deviceWatcher = hasTDWatcher and touchdevice.watcher.new(function()
            module.rescan()
        end):start()
    end
    return module
end

--- middleButton.stop() -> module
--- Function
--- Stop detecting multi-finger clicks and taps and remove the menu, if it is visible.
---
--- Parameters:
---  * None
---
--- Returns:
---  * the module
---
--- Notes:
---  * this function is invoked if you select "Quit" from the menu.
---  * if you load this file with require (e.g. `require("middleButton")`), then you can type `package.loaded["middleButton"].start()` in the Hammerspoon console to reactivate.
module.stop = function()
    if _menu then
        if type(_menu) ~= "boolean" then _menu:delete() end
        _menu = nil
        module.rescan() -- will clear all device callbacks
        _leftClickTap:stop() ; _leftClickTap = nil
        _sleepWatcher:stop() ; _sleepWatcher = nil
        if _deviceWatcher then
            _deviceWatcher:stop() ; _deviceWatcher = nil
        end
    end
    return module
end
