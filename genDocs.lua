
local genDocs = {}

local _Bindings = {
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
        }
    }
}


local classes = _Bindings.Classes



local docsLocation = "docs\\api\\"
function genDocs:gen()
    --make directory
    os.execute( "mkdir "..docsLocation )

    --make category_.json
    local filename = docsLocation.."_category_.json"
    local file = io.open(filename, "w")
    file:write('{ "label": "API", "position": 2 }')

    for name,class in pairs(classes) do
        genDocs:generateClassFile(name, class)
    end
end

function genDocs:generateClassFile(name, class)
    local filename = docsLocation..name..".md"
    if (not genDocs:file_exists(filename)) then
        io.open(filename, "w") --add the file if it was missing
        io.close()
    end
    local lines = self:getLines(filename)
    local file = io.open(filename, "a")

    --only add if missing
    local function addLine(line)
        if lines[line] then return end
        file:write(line, "\n\n")
    end


    if (class.Methods) then
        addLine("## List of Methods")
        for i,method in ipairs(class.Methods) do
            addLine("### "..method)
        end
    end
    if (class.Properties) then
        addLine("## List of Properties")
        for i,prop in ipairs(class.Properties) do
            addLine("### "..prop)
        end
    end
    
    file:close()
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

genDocs:gen()
