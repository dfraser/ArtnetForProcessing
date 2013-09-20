package org.capybara.artnetforprocessing;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AbstractPixelRange {
	private int y;
	private int x;
	private int length;
	private int startChannel;
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	public AbstractPixelRange(int x, int y, int length, int startDmxChannel) {
		this.x = x;
		this.y = y;
		if (startDmxChannel == 0) {
			log.warn("dmx channels start at 1, not 0. assuming you meant 1.");
			startDmxChannel = 1;
		}
		startDmxChannel--; // real-world channel numbers start at 1, we start at 0.
		this.length = length;
		this.startChannel = startDmxChannel;
	}

	@Override
	public String toString() {
		return this.getClass().getName()+"  range: y="+y+" x=["+x+"-"+(x+length)+"] channels=["+startChannel+"-"+(startChannel+length*3)+"]";
	}
	
	public int getY() {
		return y;
	}

	public int getX() {
		return x;
	}

	public int getLength() {
		return length;
	}
	
	public int getStartChannel() {
		return startChannel;
	}
}
