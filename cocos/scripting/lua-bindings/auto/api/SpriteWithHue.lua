
--------------------------------
-- @module SpriteWithHue
-- @extend Sprite
-- @parent_module cc

--------------------------------
-- 
-- @function [parent=#SpriteWithHue] getHue 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#SpriteWithHue] setHue 
-- @param self
-- @param #float hue
        
--------------------------------
-- @overload self, string         
-- @overload self         
-- @overload self, string, rect_table         
-- @function [parent=#SpriteWithHue] create
-- @param self
-- @param #string filename
-- @param #rect_table rect
-- @return SpriteWithHue#SpriteWithHue ret (return value: SpriteWithHue)

--------------------------------
-- @overload self, cc.Texture2D, rect_table, bool         
-- @overload self, cc.Texture2D         
-- @function [parent=#SpriteWithHue] createWithTexture
-- @param self
-- @param #cc.Texture2D texture
-- @param #rect_table rect
-- @param #bool rotated
-- @return SpriteWithHue#SpriteWithHue ret (return value: SpriteWithHue)

--------------------------------
-- 
-- @function [parent=#SpriteWithHue] createWithSpriteFrameName 
-- @param self
-- @param #string spriteFrameName
-- @return SpriteWithHue#SpriteWithHue ret (return value: SpriteWithHue)
        
--------------------------------
-- 
-- @function [parent=#SpriteWithHue] createWithSpriteFrame 
-- @param self
-- @param #cc.SpriteFrame spriteFrame
-- @return SpriteWithHue#SpriteWithHue ret (return value: SpriteWithHue)
        
return nil
