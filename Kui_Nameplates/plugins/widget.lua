-- message: WidgetUpdate
local addon = KuiNameplates
local kui = LibStub('Kui-1.0')
local mod = addon:NewPlugin('Widget',0)

local INTERVAL = 0.05
local elapsed = 0

-- local functions #############################################################
local function Frame_UpdateWidget(f)
    f.state.widgetOnly = UnitNameplateShowsWidgetsOnly(f.unit)
    f.state.hasAnyWidgetsShowing = f.parent.UnitFrame.WidgetContainer:HasAnyWidgetsShowing()
end
local function Frame_Check(f)
    if f.parent.UnitFrame and f.parent.UnitFrame.WidgetContainer then
        Frame_UpdateWidget(f)
        addon:DispatchMessage('WidgetUpdate',f)
    end
end
local function UpdateFrame_OnUpdate(self,elap)
    elapsed = elapsed + elap
    if elapsed > INTERVAL then
        Frame_Check(self)
        elapsed = 0
    end
end
-- messages ####################################################################
function mod:Show(f)
    if f.parent.UnitFrame and not f.parent.UnitFrame.WidgetContainer then return end
    Frame_UpdateWidget(f)
    if not f.WidgetUpdateFrame then
        f.WidgetUpdateFrame = CreateFrame('Frame')
        f.WidgetUpdateFrame:Hide()
    end
    f:SetScript('OnUpdate',UpdateFrame_OnUpdate)
end
function mod:Hide(f)
    f.WidgetUpdateFrame:SetScript('OnUpdate',nil)
    f.WidgetUpdateFrame:Hide()
end
-- register ####################################################################
function mod:OnEnable()
    self:RegisterMessage('Show')
    self:RegisterMessage('Hide')
end
