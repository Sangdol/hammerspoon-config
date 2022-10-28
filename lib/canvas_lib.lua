canvas = require("hs.canvas")

Ca = {}


function Ca.showItermSign(frame)
  ItermSign = canvas.new(frame):appendElements({
      type = "rectangle",
      action = "fill",
      fillColor = { alpha = 0.5, green = 0.5, red = 0.4, blue = 0.3 },
      frame = { x = "0", y = "0", h = "0.01", w = "1", },
      type = "rectangle",
    }):show()
end

function Ca.deleteItermSign()
  if ItermSign then
    ItermSign:delete()
  end
end

return Ca
