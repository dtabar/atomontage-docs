
the client does client stuff blallblalb lalal bal babl aabab
blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab

blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab blallblalb lalal bal babl aabab

## List of Methods

### void SendMessage (basic_table_core<0,classsol::basic_reference<0> >)
Send a message to server scripts. The message is a table

```lua
-- send message examples
Client:SendMessage({act = 'erase', pos = Vec3(0,0,0), rad = 1})
-- send message example with no string use
Client:SendMessage({[1] = 1, [2] = 100, [3] = false, [4] = Vec2(0)})
-- send message with no keys, it's the same message as the line above
Client:SendMessage({1, 100, false, Vec2(0)})

-- send more messages in one call
Client:SendMessages({	
    {act = 1}, -- message 1
    {act = 5}, -- message 2
    {1, 100, false}, -- message 3 (with no keys)
    {act = 2, brush = 'paint'}}) -- message 4



local my_msgs = {}
table.insert(my_msgs, {act = 'erase'})
table.insert(my_msgs, {act = 'erase'})
table.insert(my_msgs, {act = 'erase'})
Client:SendMessages(my_msgs)
```

### void SendMessages (basic_table_core<0,classsol::basic_reference<0> >)

### basic_table_core<0,classsol::basic_reference<0> > ReceiveMessages (this_state)
Recieve messages send by server scripts

```lua title="Link messages to actions and do them on recieve"
-- define your actions for network messages (good example, but user can wrok this out freely)
net_actions = {}
net_actions['Del'] = function(msg) Scene:ClearSphere(msg.pos, msg.rad) end
net_actions[1] = function(msg) Scene:ClearSphere(msg[2], msg[3]) end

-- receive all messages in one call and process them
for i,msg in ipairs(Client:ReceiveMessages()) do
    -- process message example:
    local f = msg.act and net_actions[msg.act]
    if type(f) == 'function' then
        f(msg)
    end
end
```

### string UIItemUpdate (uint32_t, UIItem, basic_object<classsol::basic_reference<0> >)

### void OpenKeyboardShortcutInput (string)

### void ToggleUICreatorWindow ()

### Camera GetCamera ()

### bool IsClient ()

### bool IsServer ()

