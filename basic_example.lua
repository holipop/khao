local khao = require("khao")
local Element = khao.Element
local t = 0

local ui = Element {
    width_sizing = "fit",
    height_sizing = "fit",
    padding = 10,

    on_draw = function(self, x, y)
        local r = math.sin(t) / 2 + 0.5
        local g = math.sin(t + math.pi * (1/3)) / 2 + 0.5
        local b = math.sin(t + math.pi * (2/3)) / 2 + 0.5
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("line", x, y, self.w, self.h)
    end,
    post_draw = function(self, x, y)
        love.graphics.setColor(1, 1, 1)
    end,

    Element {
        on_update = function(self, dt)
            self.width = (math.cos(t) + 1) * 100
            self.height = (math.sin(t) + 1) * 100
        end,
        on_draw = function(self, x, y)
            love.graphics.rectangle("fill", x, y, self.w, self.h)
        end
    }
}

ui:calculate_dimensions()
ui:calculate_positions()

function love.update (dt)  
    t = t + dt

    ui:update(dt)

    -- whenever you change the sizing of an element, you should call these to recalculate sizes and positions.
    ui:calculate_dimensions() 
    ui:calculate_positions()
end

function love.draw ()
    ui:draw(100, 100)

    love.graphics.print("t: " .. t, 50, 50)
end