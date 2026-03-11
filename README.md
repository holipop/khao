# khao ข้าว

> [!WARNING]
> hey! khao is a work in progress (and so is this readme)

**khao** (thai for "rice") is a layout library for LÖVE inspired by [clay](https://github.com/nicbarker/clay) and HTML. It's designed to be as declarative and terse as possible within the syntax of Lua.

## Installation
Place `khao.lua` in your project and use `require` whereever you need it.
```lua
local khao = require("khao") -- if khao.lua is in your root directory
local khao = require("path.to.khao") -- if it's in a subfolder
```

## Basic Overview
The `Element` class acts as the foundation of khao. To construct one, use the `:from` method or call the class directly, then pass a configuration table where its _keys are properties_ of the element and its _indices are child elements_.

```lua
local Element = khao.Element
local Text = khao.Text

local thing = Element { 
    width = 150, 
    height = 100,
    align_x = "center",
    align_y = "center",

    Text {
        content = "Hello World!"
    }
}
```
We can then call the `:calculate` method that computes the dimensions and positions of each element, which then allows us to `:draw` our elements where ever we like.
```lua
thing:calculate()

function love.draw ()
    thing:draw(100, 100)
end
```

## Example

# API Reference
## `Element`
The base element class.

### `:from (config: table): Element`
Constructs an Element from a given configuration table, its keys being properties and its indices being child elements. Can also be invoked by calling the `Element` class itself.

#### Configuration Parameters
- `width_sizing: "fixed"|"fit"|"grow"` - The sizing behavior of the width. `"fixed"` by default. 
- `height_sizing: "fixed"|"fit"|"grow"` - The sizing behavior of the height. `"fixed"` by default. 
- `width: number` - If sizing is set to `"fixed"`, the width in pixels. If sizing is set to `"grow"`, the proportion of available width this element takes.
- `height: number` - If sizing is set to `"fixed"`, the height in pixels. If sizing is set to `"grow"`, the proportion of available height this element takes.
- `min_width: number` - The minimum width in pixels.
- `max_width: number` - The maximum width in pixels.
- `min_height: number` - The minimum height in pixels.
- `max_height: number` - The maximum height in pixels.
- `align_x: "left"|"center"|"right"` - The positioning of child elements along the x-axis. `"left"` by default. 
- `align_y: "top"|"center"|"bottom"` - The positioning of child elements along the y-axis. `"top"` by default.
- `direction: "row"|"column"` - `"row"` by default. The direction child elements are drawn.
- `padding: number` - A shorthand for setting all padding values.
- `padding_left: number` - The amount of pixels between the child elements and the left edge.
- `padding_right: number` - The amount of pixels between the child elements and the right edge.
- `padding_top: number` - The amount of pixels between the child elements and the top edge.
- `padding_bottom: number` - The amount of pixels between the child elements and the bottom edge.
- `gap: number` - The amount of pixels between each child element.
- `name: string` - Just a string, mainly intended for drawing/debugging.
- `color: [number, number, number, number]` - A table of RGBA values, intended for `love.graphics.setColor`.
- `on_update: function (self, dt: number)` - A callback fired when the root element calls `:update`.
- `on_draw: function (self, x: number, y: number)` - A callback fired when the root element calls `:draw`
- `post_draw: function (self, x: number, y: number)` - A callback fired after child elements have been drawn.

Instances of `Element` have the following fields upon creation along with the ones listed above. _These should be treated as read-only._
- `parent: Element?` - The parent element. `nil` if it is a root element.
- `x: number` - The x position relative to its parent.
- `y: number` - The y position relative to its parent.
- `w: number` - The calculated width.
- `h: number` - The calculated height.

### `:add_children (...: table|Element)`
Adds child elements to the end of the list of children. Configuration tables can be inputed which get instantiated as the type of the element.

### `:extend (can_have_children: boolean?): table`
Returns a class that extends the Element class. If `false` is inputed, it prevents this type from having child elements.

### `:init ()`
An abstract method called whenever elements are instantiated. Intended for subclasses to override with custom initialization.

### `:calculate ()`
Calculates the dimensions and positions of the element and its descendents. This should be called after initialization and whenever changes are made an element's properties so it and its descendents' `x`, `y`, `w`, and `h` fields are updated.

### `:update (dt: number)`
Calls the element's and its descendents' `:on_update` callbacks.

### `:on_update (dt: number)`
The default callback fired by `:update` and called if an element instance doesn't have an `on_update` callback, intended to be overriden by subclasses. This is called before its child elements.

### `:draw (x: number, y: number)`
Calls the element's and its descendents `:on_draw` and `:post_draw` callbacks.

### `:on_draw (x: number, y: number)`
The default callback fired by `:draw` and called if an element instance doesn't have an `on_draw` callback, intended to be overriden by subclasses. This is called *before* its child elements are drawn.

### `:post_draw (x: number, y: number)`
The default callback fired by `:draw` and called if an element instance doesn't have an `post_draw` callback, intended to be overriden by subclasses. This is called *after* its child elements are drawn.

### `:get_dimensions (): number, number`
Returns the elements computed width and height.

## `Text`
A subclass of Element with some basic handling for text. Text elements have their sizing permanently set to `"grow"` so that their text can wrap.

#### Configuration Parameters
- `content: string` - The text to display.
- `font: love.Font` - The Font object to use. Default value is whatever `love.graphics.getFont` returns.

## `Image`
A subclass of Element for drawing images. 

#### Configuration Parameters
- `image: love.Image` - The Image object to use.
- `path: string` - The path to the image, used only if no Image object is given.
- `settings: { mipmaps: boolean, linear: boolean, dpiscale: number }` - The settings for the image, used only if no Image object is given.
- `quad: love.Quad` - The Quad object to use. By default, a quad of the entire image is used.
- `angle: number` - The image's angle of rotation.
- `skew_x: number` - The image's horizontal skew factor.
- `skew_y: number` - The image's vertical skew factor.
- `scale_x: number` - The image's horizontal scale factor.
- `scale_y: number` - The image's vertical scale factor.
- `offset_x: number` - The image's offset along the x-axis.
- `offset_y: number` - The image's offset along the y-axis.

After construction, Images get the following fields. These are intended to use for scaling the image to the computed dimensions.
- `sx: number` - The computed horizontal scale factor for setting the image's width to the element's `w`.
- `sy: number` - The computed vertical scale factor for setting the image's height to the element's `h`.

## `Transformable`
A subclass of Element for transforming it and its child element's draw calls.

#### Configuration Parameters
- `angle: number` - The element's angle of rotation.
- `skew_x: number` - The element's horizontal skew factor.
- `skew_y: number` - The element's vertical skew factor.
- `scale_x: number` - The element's horizontal scale factor.
- `scale_y: number` - The element's vertical scale factor.
- `origin_x: number` - The element's origin offset along the x-axis.
- `origin_y: number` - The element's origin offset along the y-axis.

After construction, Transformable instances get the following fields.
- `transform: love.Transform` - The Transform object applied before `:on_draw` and updated after `:on_update` is called.
- `inverse: love.Transform` - The inverse Transform object applied after `:post_draw`.