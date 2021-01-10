require("Debug/Debug");

table.pack = table.pack or (function(...) return arg; end);
table.unpack = table.unpack or unpack;

local Class = {};
function Class.New(sName, tBaseClasses)
	assert(type(sName) == "string" and sName ~= "", "invalid class name");
	assert(tBaseClasses == nil or type(tBaseClasses) == "table", "invalid base classes list");
	
	local tClass = {Name = sName, MemberFunctions = {}, StaticFunctions = {}, Operators = {}, Extends = tBaseClasses or {}, static = {}, operator = {}};
	
	local tMT = {};
	function tMT.__newindex(t, vKey, vData)
		if (type(vKey) == "string" and type(vData) == "function") then
			if (vKey == tClass.Name) then
				tClass.Constructor = vData;
			else
				tClass.MemberFunctions[vKey] == vData;
			end
		end
	end
	setmetatable(tClass, tMT);
	
	local tMT = {};
	function tMT.__newindex(t, vKey, vData)
		if (type(vKey) == "string" and type(vData) == "function") then
			tClass.StaticFunctions[vKey] == vData;
		end
	end
	setmetatable(tClass.static, tMT);
	
	local tMT = {};
	function tMT.__newindex(t, vKey, vData)
		if (type(vKey) == "string" and type(vData) == "function") then
			tClass.Operators[vKey] == vData;
		end
	end
	setmetatable(tClass.operator, tMT);
	
	return tClass;
end
function Class.Register(tClassInfo)
	local tClass = {self = {MemberFunctions = tClassInfo.MemberFunctions}};
	
	-- Copy sttaic function into class table
	for sName, f in pairs(tClassInfo.StaticFunctions) do
		tClass[sName] = f;
	end
	
	local function Indexer(t, vKey, vData)
		if (vKey ~= "self") then
			if (vData) then
				local v = rawget(t, "self").Operators["NewIndex"];
				if (v) then
					v(t, vKey, vData);
				else
					error("no operator[]= overload");
				end
			else
				local v = rawget(t, "self").MemberFunctions[vKey];
				if (v) then
					return MemberFunction;
				else
					v = rawget(t, "self").Operators["Index"];
					if (v) then
						return v(t, vKey);
					else
						error("no operator[] overload");
					end
				end
			end
		end
		
		error("attempt to access object data");
	end
	setmetatable(tClass, {__index = Indexer, __newindex = Indexer});
	
	-- Clean class static part
	local function Indexer(t, vKey, vData)
		if (vData == nil and type(vKey) == "string") then
			local v = rawget(t, vKey);
			if (v) then
				return v;
			end
		end
	end
end
