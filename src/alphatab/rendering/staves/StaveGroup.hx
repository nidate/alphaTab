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
package alphatab.rendering.staves;

import alphatab.model.Bar;
import alphatab.platform.ICanvas;
import alphatab.platform.model.Color;
import alphatab.rendering.BarRendererBase;
import alphatab.rendering.layout.ScoreLayout;

/**
 * A stave consists of a list of different staves and groups
 * them using an accolade. 
 */
class StaveGroup 
{
    private var _firstStaveInAccolade:Stave;
    private var _lastStaveInAccolade:Stave;
    
    public var x:Int;
    public var y:Int;

    /**
     * Indicates whether this line is full or not. If the line is full the
     * bars can be aligned to the maximum width. If the line is not full 
     * the bars will not get stretched.
     */
    public var isFull:Bool;
    
    /**
     * The width that the content bars actually need
     */
    public var width:Int;

    public var bars:Array<Bar>;
    public var staves:Array<Stave>;
    
    public var layout:ScoreLayout;
    
    
    public function new() 
    {
        bars = new Array<Bar>();
        staves = new Array<Stave>();
        width = 0;
    }
    
    public inline function getLastBarIndex() : Int
    {
        return bars[bars.length - 1].index;
    }
    
    public function addBar(bar:Bar) : Void
    {
        bars.push(bar);
        
        // add renderers
        var maxSizes = new BarSizeInfo();
        for (s in staves)
        {
            s.addBar(bar);
            s.barRenderers[s.barRenderers.length - 1].registerMaxSizes(maxSizes);
        }
        
        // ensure same widths of new renderer
        var realWidth:Int = 0;
        for (s in staves)
        {
            s.barRenderers[s.barRenderers.length - 1].applySizes(maxSizes);
            if (s.barRenderers[s.barRenderers.length - 1].width > realWidth)
            {
                realWidth = s.barRenderers[s.barRenderers.length - 1].width;
            }
        }
    
        width += realWidth;
    }

    public function addStave(stave:Stave) 
    {
        stave.staveGroup = this;
        stave.index = staves.length;
        staves.push(stave);
        if (_firstStaveInAccolade == null && stave.isInAccolade())
        {
            _firstStaveInAccolade = stave;
            stave.isFirstInAccolade = true;
        }
        if (stave.isInAccolade())
        {
            if (_lastStaveInAccolade != null) { _lastStaveInAccolade.isLastInAccolade = false; }
            _lastStaveInAccolade = stave;
            _lastStaveInAccolade.isLastInAccolade = true;
        }
    }
    
    public function calculateHeight() : Int
    {
        return staves[staves.length - 1].y + staves[staves.length - 1].height; 
    }
    
    public function revertLastBar() : Void
    {
        if (bars.length > 1)
        {
            bars.pop();
            var w = 0;
            for (s in staves)
            {
                w = Std.int(Math.max(w, s.barRenderers[s.barRenderers.length - 1].width));
                s.revertLastBar();
            }
            width -= w;
        }
    }
    
    public function applyBarSpacing(spacing:Int)
    {
        for (s in staves)
        {
            s.applyBarSpacing(spacing);
        }
        width += bars.length * spacing;
    }
    
    public function paint(cx:Int, cy:Int,  canvas:ICanvas)
    {
        for (s in staves)
        {
            s.paint(cx + x, cy + y, canvas);
        }
        
        var res = layout.renderer.renderingResources; 
        
        if (staves.length > 0)
        {
            //
            // Draw start grouping
            // 
            
            if (_firstStaveInAccolade != null && _lastStaveInAccolade != null)
            {
                var firstStart = cy + y + _firstStaveInAccolade.y + _firstStaveInAccolade.staveTop + _firstStaveInAccolade.topSpacing + _firstStaveInAccolade.getTopOverflow();
                var lastEnd = cy + y + _lastStaveInAccolade.y + _lastStaveInAccolade.topSpacing + _lastStaveInAccolade.getTopOverflow()
                                     + _lastStaveInAccolade.staveBottom;
                
                canvas.setColor(res.barSeperatorColor);
                
                canvas.beginPath();
                canvas.moveTo(cx + x + _firstStaveInAccolade.x, firstStart);
                canvas.lineTo(cx + x + _lastStaveInAccolade.x, lastEnd);
                canvas.stroke();
                            
                //
                // Draw accolade
                // 
                
                var barSize:Int = Std.int(3 * layout.renderer.settings.scale);
                var barOffset:Int = barSize;
                
                var accoladeStart = firstStart - (barSize*4);
                var accoladeEnd = lastEnd + (barSize * 4);
                
                canvas.fillRect(cx + x - barOffset - barSize, accoladeStart, barSize, accoladeEnd - accoladeStart);
                
                var spikeStartX = cx + x - barOffset - barSize;
                var spikeEndX = cx + x + barSize * 2;
                
                // top spike
                canvas.beginPath();
                canvas.moveTo(spikeStartX, accoladeStart);
                canvas.bezierCurveTo(spikeStartX, accoladeStart, x, accoladeStart, spikeEndX, accoladeStart - barSize);
                canvas.bezierCurveTo(cx + x, accoladeStart + barSize, spikeStartX, accoladeStart + barSize, spikeStartX, accoladeStart + barSize);
                canvas.closePath();
                canvas.fill();
                
                // bottom spike 
                canvas.beginPath();
                canvas.moveTo(spikeStartX, accoladeEnd);
                canvas.bezierCurveTo(spikeStartX, accoladeEnd, x, accoladeEnd, spikeEndX, accoladeEnd + barSize);
                canvas.bezierCurveTo(x, accoladeEnd - barSize, spikeStartX, accoladeEnd - barSize, spikeStartX, accoladeEnd - barSize);
                canvas.closePath();
                
                canvas.fill();
            }
        }
    }
    
    public function finalizeGroup(scoreLayout:ScoreLayout)
    {
        var currentY:Float = 0;
        for (i in 0 ... staves.length)
        {
            staves[i].x = 0;
            staves[i].y = Std.int(currentY);
            staves[i].finalizeStave(scoreLayout);
            currentY += staves[i].height;
        }
    }
}