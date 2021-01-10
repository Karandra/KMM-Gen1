-- Constants
local OWT_PAGE = 0;
local OWT_DIALOG = 1;

-- Helper functions
local function IsDialog()
	return Application.GetCurrentDialog() ~= "";
end
local function GetCurrentWindow()
	if IsDialog() then
		return Application.GetCurrentDialog();
	else
		return Application.GetCurrentPage();
	end
end
local function GetCurrentWindowType()
	if IsDialog() then
		return OWT_DIALOG;
	else
		return OWT_PAGE;
	end
end
local function GetObjectType(sObjectName)
	if IsDialog() then
		return DialogEx.GetObjectType(sObjectName);
	else
		return Page.GetObjectType(sObjectName);
	end
end
local function MakeRandomName()
	local tName = {};
	for i = 1, 64 do
		tName[i] = string.char(math.random(33, 126));
	end
	return table.concat(tName, "");
end

local AMSObject = {};
local ClassMT = {__metatable = "AMSObject"};
local ObjectMT = {__metatable = "AMSObject"};

-- Classes table
local tClasses = {};
tClasses[OBJECT_BUTTON] = Button;
tClasses[OBJECT_LABEL] = Label;
tClasses[OBJECT_PARAGRAPH] = Paragraph;
tClasses[OBJECT_IMAGE] = Image;
tClasses[OBJECT_FLASH] = Flash;
tClasses[OBJECT_VIDEO] = Video;
tClasses[OBJECT_WEB] = Web;
tClasses[OBJECT_INPUT] = Input;
tClasses[OBJECT_HOTSPOT] = Hotspot;
tClasses[OBJECT_LISTBOX] = ListBox;
tClasses[OBJECT_COMBOBOX] = ComboBox;
tClasses[OBJECT_TREE] = Tree;
tClasses[OBJECT_RADIOBUTTON] = RadioButton;
tClasses[OBJECT_RICHTEXT] = RichText;
tClasses[OBJECT_CHECKBOX] = CheckBox;
tClasses[OBJECT_SLIDESHOW] = SlideShow;
tClasses[OBJECT_GRID] = Grid;
tClasses[OBJECT_PDF] = PDF;
tClasses[OBJECT_QUICKTIME] = QuickTime;
tClasses[OBJECT_XBUTTON] = xButton;
tClasses[OBJECT_PLUGIN] = Plugin;

-- Constructor
function ClassMT.__call(_, sObjectName)
	local nType = GetObjectType(sObjectName);
	if (nType ~= -1) then
		local tObjectContainer = {};
		local tObject = {};
		tObject.Name = sObjectName;
		tObject.Type = nType;
		tObject.OwnerWindow = GetCurrentWindow();
		tObject.OwnerWindowType = GetCurrentWindowType();
		tObject.Deleted = false;
		tObject.Methods = tClasses[nType];
		
		tObjectContainer.Object = tObject;
		setmetatable(tObjectContainer, ObjectMT);
		return tObjectContainer;
	else
		return error("Unknown object type: "..nType);
	end
end
local function GetObject(tObjectContainer)
	return rawget(tObjectContainer, "Object");
end

-- Static functions
function AMSObject.EnumObjects()
	local tObjectNamesList = {};
	if IsDialog() == true then
		tObjectNamesList = DialogEx.EnumerateObjects();
	else
		tObjectNamesList = Page.EnumerateObjects();
	end
	
	local tObjects = {};
	for x, sObjectName in ipairs(tObjectNamesList) do
		tObjects[#tObjects+1] = AMSObject(sObjectName);
	end
	
	if (#tObjects ~= 0) then
		return tObjects;
	end
	return nil;
end
function AMSObject.GetFocusedObject()
	local sObjectName;
	if (IsDialog() == true) then
		sObjectName = DialogEx.GetFocus();
	else
		sObjectName = Page.GetFocus();
	end
	
	return AMSObject(sObjectName);
end
function AMSObject.CreateObject(vType, tInfo, sObjectName)
	local nType = assert(_G[vType] or vType, "object type expected");
	assert(tInfo, "object configuration expected");
	local sObjectName = sObjectName or MakeRandomName();
	
	if (IsDialog() == true) then
		DialogEx.CreateObject(nType, sObjectName, tInfo);
	else
		Page.CreateObject(nType, sObjectName, tInfo);
	end
	
	return AMSObject(sObjectName);
end

-- Class methods
function AMSObject:GetObjectName()
	return rawget(GetObject(self), "Name");
end
function AMSObject:GetObjectType()
	return rawget(GetObject(self), "Type");
end
function AMSObject:GetObjectMethods()
	local tMethods = rawget(GetObject(self), "Methods");
	local tList = {};
	for sName, vValue in pairs(tMethods) do
		tList[#tList+1] = sName;
	end
	
	if (#tList ~= 0) then
		return tList;
	else
		return nil;
	end
end
function AMSObject:GetOwnerWindow()
	return rawget(GetObject(self), "OwnerWindow");
end

function AMSObject:IsDeleted()
	return rawget(GetObject(self), "Deleted") and self:GetProperties() == nil;
end
function AMSObject:IsOnPage()
	return rawget(GetObject(self), "OwnerWindowType") == OWT_PAGE;
end
function AMSObject:IsOnDialog()
	return rawget(GetObject(self), "OwnerWindowType") == OWT_DIALOG;
end
function AMSObject:GetHWND()
	local tInfo = self:GetProperties();
	if (tInfo ~= nil) then
		local hWnd = tInfo.WindowHandle;
		if (hWnd ~= nil) then
			return hWnd;
		end
	end
	return nil;
end
function AMSObject:GetCharSet()
	local tInfo = self:GetProperties();
	if (tInfo ~= nil) then
		if (tInfo.FontScript ~= nil) then
			return tInfo.FontScript;
		end
	end
	return nil;
end
function AMSObject:SetCharSet(vCharSet)
	self:SetProperties({FontScript = _G[vCharSet] or vCharSet});
	
	-- ANSI_CHARSET - ANSI character set.
	-- BALTIC_CHARSET - Baltic character set.
	-- CHINESEBIG5_CHARSET - Chinese character set.
	-- DEFAULT_CHARSET - Default character set.
	-- EASTEUROPE_CHARSET - Eastern European character set.
	-- GB2312_CHARSET - GB2312 character set.
	-- GREEK_CHARSET - Greek character set.
	-- HANGUL_CHARSET - Hangul character set.
	-- MAC_CHARSET - MAC character set.
	-- OEM_CHARSET - OEM character set.
	-- RUSSIAN_CHARSET - Russian character set.
	-- SHIFTJIS_CHARSET - Shiftjis character set.
	-- SYMBOL_CHARSET - Symbol character set.
	-- TURKISH_CHARSET - Turkish character set.
end

function AMSObject:ClickObject()
	local sName = self:GetObjectName();
	if (IsDialog() == true) then
		DialogEx.ClickObject(sName);
	else
		Page.ClickObject(sName);
	end
end
function AMSObject:GetScript(sEvent)
	local sName = self:GetObjectName();
	if (IsDialog() == true) then
		return DialogEx.GetObjectScript(sName, sEvent);
	else
		return Page.GetObjectScript(sName, sEvent);
	end
end
function AMSObject:SetScript(sEvent, sScript)
	local sName = self:GetObjectName();
	if (IsDialog() == true) then
		DialogEx.SetObjectScript(sName, sEvent, sScript);
	else
		Page.SetObjectScript(sName, sEvent, sScript);
	end
end
function AMSObject:SetFocus()
	local sName = self:GetObjectName();
	if (IsDialog() == true) then
		DialogEx.SetFocus(sName);
	else
		Page.SetFocus(sName);
	end
end
function AMSObject:SetZOrder(nPosition, tReferenceObject)
	local sName = self:GetObjectName();
	local sReferenceObject = "";
	if (tReferenceObject ~= nil) then
		sReferenceObject = tReferenceObject:GetObjectName();
	end
	
	if (IsDialog() == true) then
		DialogEx.SetObjectZOrder(sName, nPosition, sReferenceObject);
	else
		Page.SetObjectZOrder(sName, nPosition, sReferenceObject);
	end
end

function AMSObject:DeleteObject()
	local sName = self:GetObjectName();
	if (IsDialog() == true) then
		DialogEx.DeleteObject(sName);
	else
		Page.DeleteObject(sName);
	end
	
	rawset(GetObject(self), "Deleted", true);
end
function AMSObject:DuplicateObject(sObjectName)
	local nType = self:GetObjectType();
	local tInfo = self:GetProperties();
	local sObjectName = sObjectName or MakeRandomName();

	if (IsDialog() == true) then
		DialogEx.CreateObject(nType, sObjectName, tInfo);
	else
		Page.CreateObject(nType, sObjectName, tInfo);
	end
	
	return AMSObject(sObjectName);
end

-- Object indexers
function ObjectMT.__index(tObjectContainer, sKey)
	if (sKey ~= "Object") then
		local tObject = GetObject(tObjectContainer);
		-- Try to find AMS function first
		local tMethods = rawget(tObject, "Methods");
		if (tMethods ~= nil) then
			local vValue = tMethods[sKey];
			if (vValue ~= nil) then
				local function AMSCallWrapper(...)
					table.remove(arg, 1);
					return vValue(rawget(tObject, "Name"), table.unpack(arg));
				end
				return AMSCallWrapper;
			else
				-- If this is not AMS function, try this class function
				return AMSObject[sKey];
			end
		end
	else
		error("attempt to index object data");
	end
end
function ObjectMT.__newindex(tObject, sKey, sValue)
	error("attempt to edit object data");
	return nil;
end

-- Class indexers
function ClassMT.__index(tObject, sKey)
	error("attempt to index class data or index a nil value");
	return nil;
end
function ClassMT.__newindex(tObject, sKey, sValue)
	error("attempt to edit class data");
	return nil;
end

setmetatable(AMSObject, ClassMT);

-- Loading
-- return AMSObject; -- Uncomment to use require: AMSObject = require("AMSObject");
AMSObject = AMSObject; -- Load to globals
