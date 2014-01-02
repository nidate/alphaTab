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
        
        x += contentPadding.left;
        posY = Math.floor(posY + firstMeasureSpacing);
        _lines = getStaveLines(song, 0, posY, x);
        for (line in _lines) {
            posY += line.getHeight();
        }
    
        height = posY + contentPadding.bottom;
        
        width = _lines[0].width + PAGE_PADDING.getHorizontal();
        layoutSize = new Point(width, height);
    }

    public function getStaveLines(song:Song, startIndex:Int, startY:Int, startX:Int) : Array<StaveLine>
    {
        _lines = [];
        var y = startY;
        for (track in song.tracks) {
            var line:StaveLine = createStaveLine(track);
            line.y = y;
            line.x = startX;
            line.spacing.set(StaveLine.TopPadding, Math.floor(10 * scale));
            line.spacing.set(StaveLine.BottomSpacing, Math.floor(10 * scale));
            _lines.push(line);
        }
        
        var measureCount = song.tracks[0].measureCount();
        var x = 0;
        for (i in startIndex ... measureCount) 
        {
            var maxWidth = 0;
            for (trackIndex in 0 ... song.tracks.length) {
                var track:Track = song.tracks[trackIndex];
                var line = _lines[trackIndex];
                var measure:MeasureDrawing = cast track.measures[i];
                measure.staveLine = line;
                measure.performLayout(this);
                measure.x = x;
                if (measure.width > maxWidth) {
                    maxWidth = measure.width;
                }
            }
            for (trackIndex in 0 ... song.tracks.length) {
                var track:Track = song.tracks[trackIndex];
                var line = _lines[trackIndex];
                var measure:MeasureDrawing = cast track.measures[i];
                measure.width = maxWidth;
                for (stave in line.staves)
                {
                    stave.prepare(measure);
                }
                line.addMeasure(i);
            }
            x += maxWidth;
        }
        y = 0;
        for (line in _lines) {
            line.width = x;
            line.y = y;
            y += line.getHeight();
        }
        return _lines;
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