from pathlib import Path
import sys

addon = Path(__file__).resolve().parent
root = addon.parent
sys.path.insert(0, str(root / 'LH_Tweaks/.test-runtime'))
from lupa.lua51 import LuaRuntime

lua = LuaRuntime(unpack_returned_tuples=True)
lua.execute('''
frames={}
local methods={}
for _,name in ipairs({'EnableMouse','SetFrameStrata','SetStatusBarTexture','SetOrientation',
 'SetReverseFill','SetMinMaxValues','SetFrameLevel','SetFont','SetTextColor','SetJustifyH'}) do
 methods[name]=function() end
end
function methods:SetScript(name,callback) self.scripts[name]=callback end
function methods:RegisterEvent(name) self.events[name]=true end
function methods:SetPoint(...) self.point={...};self.points=self.points or {};self.points[#self.points+1]=self.point;if self.kind=='StatusBar' and select(1,...)=='TOPRIGHT' then self.width=self.point[2].width end end
function methods:ClearAllPoints() self.point=nil;self.points={} end
function methods:SetSize(width,height) self.width,self.height=width,height end
function methods:SetHeight(height) self.height=height end
function methods:SetValue(value) self.value=value end
function methods:GetWidth() return self.width or 0 end
function methods:GetEffectiveScale() return self.scale or 1 end
function methods:GetFrameLevel() return 1 end
function methods:Show() self.shown=true end
function methods:Hide() self.shown=false end
function methods:SetColorTexture(...) self.color={...} end
function methods:SetStatusBarColor(...) self.color={...} end
function methods:SetFormattedText(format,value) self.text=string.format(format,value) end
local function object(kind,parent)
 return setmetatable({kind=kind,parent=parent,scripts={},events={}}, {__index=methods})
end
function methods:CreateTexture() local texture=object('Texture',self);self.textures=self.textures or {};self.textures[#self.textures+1]=texture;return texture end
function methods:CreateFontString() return object('FontString',self) end
function CreateFrame(kind,name,parent)
 local frame=object(kind,parent);frames[#frames+1]=frame
 if name then _G[name]=frame end
 return frame
end
UIParent=object('Frame');PlayerCastingBarFrame=object('Frame');PlayerCastingBarFrame.width=200
Enum={PlayerSwingType={MainHand=1,OffHand=2,Ranged=3}}
C_SwingTimer={};STANDARD_TEXT_FONT='Font';SlashCmdList={}
now=0;function GetTime() return now end
''')
lua.execute((addon / 'LH_SwingTimer.lua').read_text(encoding='utf-8'), 'LH_SwingTimer')
lua.execute('''
driver=frames[1]
local function event(name,...) driver.scripts.OnEvent(driver,name,...) end
local function tick(at)
 local elapsed=at-now;now=at
 if driver.scripts.OnUpdate then driver.scripts.OnUpdate(driver,elapsed) end
end
assert(driver.events.PLAYER_SWING and driver.events.WEAPON_SLOT_CHANGED)
event('ADDON_LOADED','LH_SwingTimer')
assert(LH_SwingTimerDB.enabled and LH_SwingTimerDB.mainHand and LH_SwingTimerDB.ranged)
event('PLAYER_SWING',2,Enum.PlayerSwingType.MainHand)
bar=LH_SwingTimerBar;orange=frames[3]
assert(bar.shown and bar.width==200 and bar.height==2)
assert(not bar.textures[1].shown and not orange.shown)
assert(bar.textures[2].height==8 and orange.color[2]==.38)
tick(1);assert(bar.value==.5 and orange.value==0)
tick(1.5);assert(bar.value==.75 and orange.value==0)
PlayerCastingBarFrame.width=240
tick(1.75);assert(bar.value==.875 and not orange.shown)
tick(1.99)
assert(bar.width==240 and not bar.textures[1].shown)
assert(bar.value>.99 and not orange.shown)
tick(2);assert(not bar.shown and not driver.scripts.OnUpdate)
now=5;event('PLAYER_SWING',2,Enum.PlayerSwingType.Ranged)
assert(bar.textures[1].shown and orange.shown)
assert(bar.textures[1].point[4]==180 and bar.textures[1].height==8)
assert(orange.points[1][4]==180 and orange.points[1][2]==bar)
PlayerCastingBarFrame.width=300;tick(6.25)
assert(bar.width==300 and bar.textures[1].point[4]==225)
assert(bar.value==.625 and orange.value==0)
tick(6.75);assert(bar.value==.75 and orange.value==.5)
tick(7);assert(not bar.shown)
-- Durations shorter than half a second have an orange segment from the start.
now=10;event('PLAYER_SWING',.3,Enum.PlayerSwingType.Ranged)
assert(bar.textures[1].point[4]==0 and bar.value==0)
tick(10.15);assert(bar.value==0 and orange.value>.49 and orange.value<.51)
event('PLAYER_SWING',1,Enum.PlayerSwingType.OffHand)
assert(bar.shown and orange.value>.49)
event('WEAPON_SLOT_CHANGED');assert(not bar.shown)
event('PLAYER_SWING',2,Enum.PlayerSwingType.MainHand)
LH_SwingTimer:SetOption('enabled',false);assert(not bar.shown)
event('PLAYER_SWING',2,Enum.PlayerSwingType.MainHand);assert(not bar.shown)
LH_SwingTimer:SetOption('enabled',true)
LH_SwingTimer:SetOption('mainHand',false)
event('PLAYER_SWING',2,Enum.PlayerSwingType.MainHand);assert(not bar.shown)
event('PLAYER_SWING',2,Enum.PlayerSwingType.Ranged);assert(bar.shown)
LH_SwingTimer:SetOption('ranged',false);assert(not bar.shown)
event('ADDON_LOADED','AnotherAddon');assert(not bar.shown)
''')
lua.execute('''
Settings={};registry={};controls={};notices={}
function Settings.RegisterVerticalLayoutSubcategory(parent,title)
 local category={parent=parent,title=title}
 function category:GetID() return self.title end
 local layout={rows={}}
 function layout:AddInitializer(row) self.rows[#self.rows+1]=row end
 category.layout=layout;return category,layout
end
function Settings.RegisterAddOnCategory(category) registered=category end
function Settings.RegisterProxySetting(category,variable,kind,label,default,get,set)
 local setting={variable=variable,default=default,get=get,set=set}
 registry[variable]=setting;return setting
end
function Settings.CreateCheckbox(category,setting)
 local row={setting=setting}
 function row:SetParentInitializer(parent,predicate) self.parent=parent;self.predicate=predicate end
 category.layout:AddInitializer(row);controls[setting.variable]=row;return row
end
function Settings.NotifyUpdate(variable) notices[variable]=(notices[variable] or 0)+1 end
function Settings.OpenToCategory(id) opened=id end
function CreateSettingsListSectionHeaderInitializer(name) return {header=name} end
LH_Tweaks={modules={},category={}}
''')
source = (root / 'LH_Tweaks/LH_Tweaks.lua').read_text(encoding='utf-8')
registration = source.split('function Hub:RegisterModule(id, title, build)')[1].split('\nfunction Hub:RestoreDefaults')[0]
lua.execute('local Hub=LH_Tweaks\nfunction Hub:RegisterModule(id, title, build)' + registration)
source = (root / 'LH_Tweaks/Settings.lua').read_text(encoding='utf-8')
registration = source.split('function Hub:RegisterModulePage(id)')[1].split('\nlocal function RegisterSettings')[0]
lua.execute('local Hub=LH_Tweaks\nfunction Hub:RegisterModulePage(id)' + registration)
lua.execute((addon / 'Settings.lua').read_text(encoding='utf-8'), 'LH_SwingTimer')
lua.execute('''
assert(registered.parent==LH_Tweaks.category and registered.title=='LH SwingTimer')
assert(registry.LH_SwingTimer_enabled.default==true)
assert(registry.LH_SwingTimer_mainHand.default==true)
assert(registry.LH_SwingTimer_ranged.default==true)
assert(controls.LH_SwingTimer_mainHand.parent==controls.LH_SwingTimer_enabled)
assert(controls.LH_SwingTimer_ranged.parent==controls.LH_SwingTimer_enabled)
registry.LH_SwingTimer_enabled.set(true)
registry.LH_SwingTimer_mainHand.set(true)
registry.LH_SwingTimer_ranged.set(true)
SlashCmdList.LH_SWINGTIMER('');assert(opened=='LH SwingTimer')
SlashCmdList.LH_SWINGTIMER('off');assert(not registry.LH_SwingTimer_enabled.get())
SlashCmdList.LH_SWINGTIMER('on');assert(registry.LH_SwingTimer_enabled.get())
''')
for ext in ('png', 'tga'):
    assert (addon / f'Media/Icon.{ext}').read_bytes() == (root / f'LH_Tweaks/Icon.{ext}').read_bytes()
print('PASS: ranged-only orange phase and 0.5-second marker, short swings, resizing, filtering, activation, native settings and shared icons')
