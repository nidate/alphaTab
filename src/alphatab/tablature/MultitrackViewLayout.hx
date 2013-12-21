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
    
}