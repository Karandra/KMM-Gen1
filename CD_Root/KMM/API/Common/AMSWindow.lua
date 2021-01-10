table.pack = table.pack or (function(...) return arg; end);
table.unpack = table.unpack or unpack;

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
				return AMSWindow[sKey];
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

setmetatable(AMSWindow, ClassMT);

-- Loading
-- return AMSWindow; -- Uncomment to use require: AMSWindow = require("AMSWindow");
AMSWindow = AMSWindow; -- Load to globals
