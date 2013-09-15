package org.capybara.artnetforprocessing;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Represents an Art-Net universe. Contains multiple pixel ranges.
 * 
 * @author dfraser
 *
 */
public class Universe {

	private List<AbstractPixelRange> pixelRanges = new ArrayList<AbstractPixelRange>();
	private int subnet;
	private int universe;
	private final Logger log = LoggerFactory.getLogger(Universe.class);
	
	/**
	 * Create a new Universe.
	 * @param subnet the Art-Net subnet represented by this universe
	 * @param universe the Art-Net universe represented by this universe
	 */
	public Universe(int subnet, int universe) {
		this.subnet = subnet;
		this.universe = universe;
	}
	
	/**
	 * Add a pixel range to this universe. One or more pixel ranges have to be added before the
	 * universe will do anything interesting.  If multiple PixelRanges use the same target DMX channels,
	 * the most recently added range will take precedence.
	 * @param pr the AbstractPixelRange subclass to add.
	 */
	public void addPixelRange(AbstractPixelRange pr) {
		pixelRanges.add(pr);
		log.debug(pr.toString());
		
	}

	/**
	 * Return a list of the currently defined pixel ranges.
	 * @return
	 */
	public List<AbstractPixelRange> getPixelRanges() {
		return Collections.unmodifiableList(pixelRanges);
	}
	
	/**
	 * Return the Art-Net subnet.
	 * @return the subnet
	 */
	public int getSubnet() {
		return subnet;
	}
	
	/**
	 * Return the Art-Net universe.
	 * @return the universe
	 */
	public int getUniverse() {
		return universe;
	}

}
