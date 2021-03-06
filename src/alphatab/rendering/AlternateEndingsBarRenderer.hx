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

import alphatab.model.Bar;
import alphatab.model.MasterBar;
import alphatab.model.TextBaseline;
import alphatab.model.Voice;
import alphatab.platform.ICanvas;
import alphatab.platform.model.Color;
import alphatab.rendering.glyphs.BeatContainerGlyph;
import alphatab.rendering.glyphs.BeatGlyphBase;
import alphatab.rendering.layout.ScoreLayout;
import alphatab.rendering.staves.BarSizeInfo;

/**
 * This bar renderer can render repeat endings.
 */
class AlternateEndingsBarRenderer extends BarRendererBase
{
    private static inline var Padding = 3;
    private var _endings:Array<Int>;
    private var _endingsString:String;
    
    public function new(bar:Bar) 
    {
        super(bar);
        
        var alternateEndings = bar.getMasterBar().alternateEndings;
        _endings = new Array<Int>();
        for (i in 0 ... MasterBar.MaxAlternateEndings)
        {
            if ( (alternateEndings & (0x01 << i)) != 0)
            {
                _endings.push(i);
            }
        }
    }
    
    public override function finalizeRenderer(layout:ScoreLayout):Void 
    {
        super.finalizeRenderer(layout);
        isEmpty = _endings.length == 0;        
    }
    
    
    public override function doLayout():Void 
    {
        super.doLayout();
        if (index == 0)
        {
            stave.topSpacing = 5;
            stave.bottomSpacing = 5;
        }
        height = Std.int(getResources().wordsFont.getSize());

        var endingsString = new StringBuf();
        for (e in _endings)
        {
            endingsString.add(e + 1);
            endingsString.add(". ");
        }
        _endingsString = endingsString.toString();
        
    }
    
    public override function getTopPadding():Int 
    {
        return 0;
    }    
    
    public override function getBottomPadding():Int 
    {
        return 0;
    }
    
    public override function applySizes(sizes:BarSizeInfo):Void 
    {
        super.applySizes(sizes);
        width = sizes.fullWidth;
    }
    
    public override function paint(cx:Int, cy:Int, canvas:ICanvas):Void 
    {
        if (_endings.length > 0)
        {
            var res = getResources();
            canvas.setColor(res.mainGlyphColor);
            canvas.setFont(res.wordsFont);
            canvas.moveTo(cx + x, cy + y + height);
            canvas.lineTo(cx + x, cy + y);
            canvas.lineTo(cx + x + width, cy + y);
            canvas.stroke();
            
            canvas.fillText(_endingsString, Std.int(cx + x + Padding * getScale()) ,Std.int(cy + y * getScale()));
        }
    }
}