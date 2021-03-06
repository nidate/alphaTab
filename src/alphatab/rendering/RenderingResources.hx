/*
 * This file is part of alphaTab.
 * Copyright c 2013, Daniel Kuschny and Contributors, All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or at your option any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */
package alphatab.rendering;

import alphatab.platform.model.Color;
import alphatab.platform.model.Font;

/**
 * This class contains central definitions for controlling the visual appearance. 
 */
class RenderingResources 
{
    public var copyrightFont:Font;
    public var titleFont:Font;
    public var subTitleFont:Font;
    public var wordsFont:Font;
    public var effectFont:Font;

    public var tablatureFont:Font;
    public var graceFont:Font;

    public var staveLineColor:Color;
    public var barSeperatorColor:Color;
    
    public var barNumberFont:Font;
    public var barNumberColor:Color;
    
    public var markerFont:Font;
    public var tabClefFont:Font;
    
    public var mainGlyphColor:Color;
    
    public var scale:Float;
    

    public function new(scale:Float)
    {
        init(scale);
    }
    
    public function init(scale:Float) : Void
    { 
        this.scale = scale;
        
        var sansFont = "Arial";
        var serifFont = "Georgia";
        
        effectFont = new Font(serifFont, 12 * scale, Font.StyleItalic);
        copyrightFont = new Font(sansFont, 12 * scale, Font.StyleBold);
        
        titleFont = new Font(serifFont, 32 * scale);
        subTitleFont = new Font(serifFont, 20 * scale);
        wordsFont = new Font(serifFont, 15 * scale);
        
        tablatureFont = new Font(sansFont, 13 * scale); 
        graceFont = new Font(sansFont, 11 * scale); 
        
        staveLineColor = new Color(165, 165, 165);
        barSeperatorColor = new Color(34, 34, 17);
        
        barNumberFont = new Font(sansFont, 11 * scale); 
        barNumberColor = new Color(200, 0, 0);
        
        markerFont = new Font(serifFont, 14 * scale, Font.StyleBold);
        tabClefFont = new Font(sansFont, 18 * scale, Font.StyleBold);
        
        mainGlyphColor = new Color(0,0,0);
    }
}