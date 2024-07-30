local function filter_lines(text, filter)
  local lines = pandoc.List()
  local code = text .. "\n"
  for line in code:gmatch("([^\r\n]*)[\r\n]") do
    if filter(line) then
      lines:insert(line)
    end
  end
  return table.concat(lines, "\n")
end

function CodeBlock(el)
  if el.classes:includes('cell-code') then
    el.text = filter_lines(el.text, function(line)
      return not line:match("#>")
    end)
    return el
  end
end
