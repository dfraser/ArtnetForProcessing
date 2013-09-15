package org.capybara.artnetforprocessing;

/**
 * Represents a horizontal range of pixels within the Processing stage.
 * @author dfraser
 *
 */
public class HorizPixelRange extends AbstractPixelRange {
	
	/**
	 * Creates a new HorizPixelRange.
	 * 
	 * @param x the x-position to start the pixel range
	 * @param y the y-position to start the pixel range
	 * @param length the length of the horizontal strip of pixels represented by this pixel range
	 * @param startDmxChannel the Dmx channel offset for this pixel range.
	 */
	public HorizPixelRange(int x, int y, int length, int startDmxChannel) {
		super(x, y, length, startDmxChannel);
	}


}
