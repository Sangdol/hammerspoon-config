local canvas = require("hs.canvas")

local ca = {}


function ca.showItermSign(frame)
  ItermSign = canvas.new(frame):appendElements({
      type = "rectangle",
      action = "fill",
      fillColor = { alpha = 0.5, green = 0.5, red = 0.4, blue = 0.3 },
      frame = { x = "0", y = "0", h = "0.01", w = "1", },
    }):show()
end

function ca.deleteItermSign()
  if ItermSign then
    ItermSign:delete()
  end
end

return ca
