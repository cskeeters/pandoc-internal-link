--[[
This is a pandoc filter that enables internal links in Typst.

    ---
    title: Print URL Test
    author: Chad Skeeters
    filters:
      - pandoc-internal-link/0.1.0/internal-link.lua
    ---

    Jump to the [Introduction](#introduction).

    # Introduction

In Typst, cross references to headings only work when section numbering is
enabled.  If the template doesn't enable section numbers, you can add this to
the markdown, or the template you are using.

    ```{=typst}
    #let blue-underline(it) = underline[
    #set text(blue)
    #it
    ]

    #show link: blue-underline
    #show ref: it => {
    if it.element.numbering == none {
        // Use your custom scheme
        link(it.target, it.element.body)
    } else {
        // Default `ref`
        it
    }
    }
    ```
]]

local logging = require 'logging'

-- There is no table.len in Lua (Boo!!)
function tablelen(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- Tests for links like <http://...>
function isInternal(elem)
    -- logging.info(elem.target[1])
    if string.sub(elem.target, 1, 1) == "#" then
        return true
    end
    return false
end

function getMark(elem)
    return string.sub(elem.target, 2)
end

function Link(elem)
    print("Running for target "..elem.target)
    if not isInternal(elem) then
      return elem
    end

    if FORMAT == "typst" then
          logging.info("Internal: "..pandoc.utils.stringify(elem.target))
          local content = pandoc.utils.stringify(elem.content)
          if content ~= "" then
              return pandoc.RawInline('typst', "@"..getMark(elem).."[".. pandoc.utils.stringify(elem.content).."]")
          else
              return pandoc.RawInline('typst', "@"..getMark(elem))
          end
    end

    if FORMAT == "docx" then
        return pandoc.RawInline('openxml',  '<w:r><w:t xml:space="preserve">Section 1</w:t></w:r>')
    end

    --<w:hyperlink w:anchor="sec:2">
    --  <w:r>
    --    <w:rPr>
    --      <w:rStyle w:val="Hyperlink"/>
    --    </w:rPr>
    --    <w:t>2</w:t>
    --  </w:r>
    --</w:hyperlink>

    return elem
end

--    , Link
--        ( "" , [] , [] )
--        [ Str "link" ]
--        ( "http://www.google.com" , "" )

-- Link (content, target[, title[, attr]])
--   Creates a link inline element, usually a hyperlink.
-- 
-- Parameters:
--   content:  text for this link (Inlines)
--   target:  the link target (string)
--   title: brief link description (string)
--   attr:  link attributes (Attr)
--
-- Returns:
--   link element (Inline)
