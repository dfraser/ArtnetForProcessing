package org.capybara.artnetforprocessing;

/**
 * Represents a vertical range of pixels within Processing's stage.
 * 
 * @author dfraser
 *
 */
public class VertPixelRange extends AbstractPixelRange {

	/**
	 * Creates a new VertPixelRange.
	 * 
	 * @param x the x-position to start the pixel range
	 * @param y the y-position to start the pixel range
	 * @param length the length of the vertical strip of pixels represented by this pixel range
	 * @param startDmxChannel the Dmx channel offset for this pixel range.  
	 */
	public VertPixelRange(int x, int y, int length, int startDmxChannel) {
		super(x, y, length, startDmxChannel);
	}

}
