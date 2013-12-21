/*
 * This file is part of alphaTab.
 *
 *  alphaTab is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  alphaTab is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with alphaTab.  If not, see <http://www.gnu.org/licenses/>.
 */
package alphatab.tablature;
import alphatab.model.Beat;
import alphatab.model.Measure;
import alphatab.model.Padding;
import alphatab.model.Point;
import alphatab.model.Rectangle;
import alphatab.model.Track;
import alphatab.model.Song;
import alphatab.tablature.drawing.DrawingContext;
import alphatab.tablature.model.BeatDrawing;
import alphatab.tablature.model.MeasureDrawing;
import alphatab.tablature.staves.StaveLine;
import alphatab.tablature.HorizontalViewLayout;


/**
 * This layout renders all measures in one single line
 */
class MultitrackViewLayout extends HorizontalViewLayout
{
    public static var LAYOUT_ID = "multitrack"; 
    public static var PAGE_PADDING:Padding = PageViewLayout.PAGE_PADDING;
    
    private var _lines:Array<StaveLine>;

    public override function prepareLayout(clientArea:Rectangle, x:Int, y:Int) : Void
    {
        width = 0;
        height = 0;
        
        var posY:Int = y;
        
        var track:Track = tablature.track;
        var song:Song = track.song;

        var measureCount:Int = song.measureCount();
        var nextMeasureIndex:Int = 0;
        
        x += contentPadding.left;
        posY = Math.floor(posY + firstMeasureSpacing);
         
        while (measureCount > nextMeasureIndex) 
        {
            // calculate a stave line
            _line = getStaveLine(track, nextMeasureIndex, posY, x); // useless
            _lines = new Array<StaveLine>();
            for (track in song.tracks) {
              var line:StaveLine = getStaveLine(track, nextMeasureIndex, posY, x);
              posY += line.getHeight();
              _lines.push(line);
            }

            // next measure index
            nextMeasureIndex = _line.lastIndex() + 1;
        }
        
        height = posY + contentPadding.bottom;
        
        width = _line.width + PAGE_PADDING.getHorizontal();
        layoutSize = new Point(width, height);
    }

    public override function paintSong(ctx:DrawingContext, clientArea:Rectangle, x:Int, y:Int) : Void
    {
        var song:Song = tablature.track.song;
        
        y = Math.floor(y + contentPadding.top + firstMeasureSpacing);
        for (i in 0 ... song.tracks.length) 
        {
            var line:StaveLine = _lines[i];
            var track:Track = song.tracks[i];
            line.paint(this, track, ctx);
        }
    }

}