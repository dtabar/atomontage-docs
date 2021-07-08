
print("start")
local serpent = require("generator.serpent")
local genDocs = {}

local f = io.open("generator/serverBindings.txt", "r")
local bindingsSerialized = f:read("*all")
f:close()

local fun, err = load(bindingsSerialized)
if err then error(err) end
local _Bindings = fun()

local testBindings = {
    ["Classes"] = {
        ["Vec3"] = {
            ["Methods"] = {
                "vec3 ()",
                "vec3 (float, float, float)",
                "vec3 (int32_t, int32_t, int32_t)",
                "vec3 (float)",
                "vec4 __mul (Mat4, vec3)",
                "vec3 __mul (vec3, float)",
                "vec3 __mul (float, vec3)",
                "vec3 __mul (vec3, vec3)",
                "vec3 __div (vec3, float)",
                "float Dot (vec3, vec3)",
                "vec3 Lerp (vec3, vec3, float)",
                "vec3 Mix (vec3, vec3, float)",
                "void Normalize (vec3)",
                "vec3 GetNormalized (vec3)",
                "void Clamp (vec3, float, float)",
                "float Length (vec3)"
            },
            ["Properties"] = {
                "float x",
                "float y",
                "float z",
                "vec3 zero",
                "vec3 up",
                "vec3 right",
                "vec3 forward",
                "float length",
                "vec3 normalized",
            }
        },
        ["Client"] = {
            ["Methods"] = {
                "void SendMessage (basic_table_core<0,classsol::basic_reference<0> >)",
                "void SendMessages (basic_table_core<0,classsol::basic_reference<0> >)",
                "basic_table_core<0,classsol::basic_reference<0> > ReceiveMessages (this_state)",
                "string UIItemUpdate (uint32_t, UIItem, basic_object<classsol::basic_reference<0> >)",
                "void OpenKeyboardShortcutInput (string)",
                "void ToggleUICreatorWindow ()",
                "Camera GetCamera ()",
                "bool IsClient ()",
                "bool IsServer ()",
            }
        },
        ["Camera"] = {
            ["Methods"] = {
                "Camera (string)",
                "Transformation GetTransformation (Object3D)",
                "void SetTransformation (Transformation)",
            },
            ["Properties"] = {
                "Transformation transformation",
                "Transformation transform"
            }
        }
    },
    ["Enums"] = {
        ["AttachmentFlags"] ={
            [2] = "Depth",
            [4] = "DepthAndStencil",
            [8] = "Color0",
        },
        ["BlendFactor"] = {
            "Zero",
            "One",
            "SrcColor",
            "OneMinusSrcColor",
            "DstColor",
            "OneMinusDstColor",
            "SrcAlpha",
            "OneMinusSrcAlpha",
            "DstAlpha",
            "OneMinusDstAlpha",
        }
    }
}

--_Bindings = testBindings

local docsLocation = "docs\\api\\"
local enumsLocation = "docs\\api\\enums\\"

function genDocs:gen()
    --make directory
    os.execute( "mkdir "..docsLocation )
    os.execute( "mkdir "..enumsLocation )

    --make category_.json
    local filename = docsLocation.."_category_.json"
    local file = io.open(filename, "w")
    file:write('{ "label": "API", "position": 2 }')
    file:close()

    local filename = enumsLocation.."_category_.json"
    local file = io.open(filename, "w")
    file:write('{ "label": "Enums", "position": 100000 }')
    file:close()

    for name,class in pairs(_Bindings.Classes) do
        local name = genDocs:firstToLower(name)
        --name = name:gsub("::", " ") --remove this
        if not string.find(name, "::") then --just skip these weird internal things for now
            genDocs:generateClassFile(name, class)
        end
    end

    for name,values in pairs(_Bindings.Enums) do
        local name = genDocs:firstToLower(name)
        name = name:gsub("::", " ") --remove this?
        --genDocs:generateEnumFile(name, values)
    end

    print("done")
end

--get groups[header] = body then remove matches, then handle left over ones (delete, no body, flag with body)
function genDocs:generateClassFile(name, class)
    local filename = docsLocation..name..".mdx"
    if (not genDocs:file_exists(filename)) then
        local fileW = io.open(filename, "w") --add the file if it was missing
        genDocs:addFrontMatter(name, fileW)
        fileW:close()
    end
    local lines = self:getLines(filename)

    --get current sections
    local intro, methods, properties = genDocs:getSections(filename)
    local removedMethods = table.clone(methods)
    local removedProperties = table.clone(properties)
    local file = io.open(filename, "w")

    --only add if missing
    local function addLine(line)
        if lines[line] then return end
        file:write(line, "\n\n")
    end
    local function addMethod(header)
        if (removedMethods[header]) then
            removedMethods[header] = nil
            return
        end
        print("new!", header)
        local entry = {header, ""}
        methods[header] = entry
        table.insert(methods, {name = header, entry = entry})
    end
    local function addProperty(header)
        if (removedProperties[header]) then
            removedProperties[header] = nil
            return
        end
        local entry = {header , ""}
        properties[header] = entry
        table.insert(properties, {name = header, entry = entry})
    end

    for i,method in ipairs(class.Methods or {}) do
        local header = genDocs:cleanUpName(method)
        addMethod("### "..header)
    end
    for i,prop in ipairs(class.Properties or {}) do
        local header = genDocs:cleanUpName(prop)
        addProperty("### "..header)
    end

    for i, line in ipairs(intro) do
        file:write(line, "\n")
    end
    if (class.Methods) then
        file:write("## List of Methods", "\n\n")
        for i, v in ipairs(methods) do
            local lines = v.entry
            for i, line in ipairs(lines) do
                file:write(line, "\n")
            end
        end
    end
    if (class.Properties) then
        file:write("## List of Properties", "\n\n")
        for i, v in ipairs(properties) do
            local lines = v.entry
            for i, line in ipairs(lines) do
                file:write(line, "\n")
            end
        end
    end

    for entry, lines in pairs(removedMethods) do
        if type(entry) == "string" then
            print(entry.." is old delete manually for now")
            local hasDocumentation = #lines > 3
        end
    end
    for entry, lines in pairs(removedProperties) do
        if type(entry) == "string" then
            print(entry.." is old delete manually for now")
            local hasDocumentation = #lines > 3
        end
    end

    file:close()
end

function genDocs:generateEnumFile(name, values)
    local filename = enumsLocation..name..".mdx"
    if (not genDocs:file_exists(filename)) then
        local fileW = io.open(filename, "w") --add the file if it was missing
        genDocs:addFrontMatter(name, fileW)
        fileW:close()
    end
    local lines = self:getLines(filename)
    local file = io.open(filename, "a")

    --only add if missing
    local function addLine(line)
        if lines[line] then return end
        file:write(line, "\n")
    end

    addLine("## Properties\n")

    addLine("| Name | Description |")
    addLine("| - | - |")
    for i,val in pairs(values) do
        addLine("| "..val.." |  |")
    end

    file:close()
end


--https://docusaurus.io/docs/api/plugins/@docusaurus/plugin-content-docs#markdown-frontmatter
function genDocs:addFrontMatter(filename, fileWrite)
    local title = genDocs:firstToUpper(filename)
    local id = genDocs:firstToLower(filename)
    local frontMatter = {
        "---",
        "title: "..title,
        "id: "..id,
        "---"
    }
    local str = table.concat(frontMatter, "\n") .. "\n\n"
    fileWrite:write(str)
end

--class file sections with header body pairs
function genDocs:getSections(filename)
    local intro = {}
    local methods = {}
    local properties = {}

    local groups = {intro, methods, properties}
    local iCurrentGroup = 1
    local currentGroup = groups[iCurrentGroup]

    local entryName
    local entry = currentGroup --first is just one entry
    local lines = genDocs:getLines(filename)

    local function addEntry(line)
        if entryName then
            currentGroup[entryName] = entry
            table.insert(currentGroup, {name = entryName, entry = entry})
        end
        entryName = line
        entry = {}
    end

    for i,line in ipairs(lines) do
        --group by headers
        if genDocs:stringStartsWith(line, "### ") then
            addEntry(line)
        end
        --group by sections
        if genDocs:stringStartsWith(line, "## ") then
            addEntry(line)
            iCurrentGroup = iCurrentGroup + 1
            currentGroup = groups[iCurrentGroup]
            entryName = nil
            entry = {}
        else
            table.insert(entry, line)
        end
    end
    --add last entry
    addEntry(nil)
    return intro, methods, properties
end


function genDocs:cleanUpName(name)
    --local UIItem = "<classae::core::UIItem,classstd::allocator<classae::core::UIItem> >"
    local table = "basic_table_core<0,classsol::basic_reference<0> >"
    local object = "basic_object<classsol::basic_reference<0> >"
    local int8 = "uint8_t"
    local int16 = "int16_t"
    local uint16 = "uint16_t"
    local int32 = "int32_t"
    local uint32 = "uint32_t"
    local int64 = "int64_t"
    local uint64 = "uint64_t"

    name = string.gsub(name, table, "table")
    name = string.gsub(name, object, "table")
    name = string.gsub(name, int8, "int")
    name = string.gsub(name, int16, "int")
    name = string.gsub(name, uint16, "int")
    name = string.gsub(name, int32, "int")
    name = string.gsub(name, uint32, "int")
    name = string.gsub(name, int64, "int")
    name = string.gsub(name, uint64, "int")
    return name
end

function genDocs:file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

--later get lines with and documentation below to keep and move that together, to be able to update order, or delete documentation of delted function
function genDocs:getLines(filename)
    local lines = {}
    -- read the lines in table 'lines'
    for line in io.lines(filename) do
        table.insert(lines, line)
        lines[line] = true
    end
    return lines
end

function genDocs:firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function genDocs:firstToLower(str)
    return (str:gsub("^%a", string.lower))
end

function genDocs:stringStartsWith(str, start)
   return str:sub(1, #start) == start
end

function table.clone(tab, seen)
  if type(tab) ~= 'table' then return tab end
  if seen and seen[tab] then return seen[tab] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(tab))
  s[tab] = res
  for k, v in pairs(tab) do res[table.clone(k, s)] = table.clone(v, s) end
  return res
end

genDocs:gen()
