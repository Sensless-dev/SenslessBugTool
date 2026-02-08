-- Locale Helper Functions
-- Provides server-side localization support

Locale = {}

-- Get localized string
function Locale:Get(key, ...)
    local locale = Config.Locale or 'en'
    local locales = Locales and Locales[locale] or {}
    
    local text = locales[key] or key
    
    -- Support for string formatting with arguments
    if ... then
        local args = {...}
        text = string.format(text, table.unpack(args))
    end
    
    return text
end

-- Shorthand function
function _L(key, ...)
    return Locale:Get(key, ...)
end

