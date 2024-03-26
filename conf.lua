env = require("env")

function love.conf (t)
    t.window.width = env.width
    t.window.height =  env.height
    t.modules.joystick = false
    t.modules.physics = false
end


