package org.capybara.artnetforprocessing;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import processing.core.PApplet;
import processing.core.PConstants;
import artnet4j.ArtNet;
import artnet4j.ArtNetException;
import artnet4j.ArtNetNode;
import artnet4j.events.ArtNetDiscoveryListener;
import artnet4j.packets.ArtDmxPacket;
/**
 * Library class to add Art-Net capability to Processing.  Allows the user to choose multiple pixel ranges
 * within Processing's stage and assign them to channel ranges within Art-Net universes. Each Processing frame
 * causes an Art-Net packet to be sent for each defined universe.
 * <p> 
 * Pixels are currently exported in the <a href="http://hackstrich.sen.cx/Beacon4">Hackstrich Beacon4</a> format (BRG).
 * <p>
 * Processing usage example:
 * <pre>
 * {@code
 * void setup() {
 *   size(200,200)
 *   frameRate(20)
 *   ArtnetForProcessing afp = new ArtnetForProcessing(this);
 *   afp.setBroadcastAddress("10.0.1.255");
 *   Universe u = new Universe(0,0);
 *   u.addPixelRange(new PixelRange(0,0,20,1));
 *   afp.addUniverse(u);
 *   afp.start();
 * }
 * }
 * @author dfraser
 *
 */
public class ArtnetForProcessing implements ArtNetDiscoveryListener, PConstants {

	private PApplet parent;
	private static final Logger log = LoggerFactory.getLogger(ArtnetForProcessing.class);
    private ArtNetNode netLynx;
    private int sequenceID;
	private ArtNet artnet;
	private List<Universe> universes = new ArrayList<Universe>();

	/**
	 * Create a new library class.  Called by Processing.
	 * @param parent the PApplet currently in use by the processing sketch.
	 */
	public ArtnetForProcessing(PApplet parent) {
		this.parent = parent;
		parent.registerMethod("dispose", this);
		parent.registerMethod("post", this);
        artnet = new ArtNet();
        try {
			artnet.start();
		} catch (Exception e) {
			log.error("unable to start artnet: "+e.getMessage());
		}
	}
	
	/**
	 * Add a new Universe to this Art-Net configuration. Each universe that is added will cause an Art-Net
	 * packet to be sent every time a Processing frame is rendered.
	 * @param u an Art-Net Universe, which defines a Subnet and Universe.  
	 */
	public void addUniverse(Universe u) {
		this.universes.add(u);
	}

	/**
	 * Called by Processing after frame rendering is complete. Copies defined pixel ranges, 
	 * then builds and sends Art-Net packets.
	 */
	public void post() {
		for (Universe u: universes) {
			byte[] universeBuffer = new byte[512];
			for (AbstractPixelRange pixelRange : u.getPixelRanges()) {
				int startOffset = pixelRange.getStartChannel();
				for (int i = 0; i < pixelRange.getLength(); i++) {
					int rgbPixel = 0;
					if (pixelRange instanceof HorizPixelRange) {
						rgbPixel = parent.get(pixelRange.getX()+i, pixelRange.getY());
					} else if (pixelRange instanceof VertPixelRange) {
						rgbPixel = parent.get(pixelRange.getX(), pixelRange.getY()+i);
					} else {
						log.error("Unknown pixel range type, aborting frame: "+pixelRange.toString());
						return;
					}

					int red = (rgbPixel >> 16) & 0xFF;
					int green = (rgbPixel >> 8) & 0xFF;
					int blue = rgbPixel & 0xFF;
					
					universeBuffer[startOffset+(i*3)] = (byte) green;
					universeBuffer[startOffset+(i*3)+1] = (byte) red;
					universeBuffer[startOffset+(i*3)+2] = (byte) blue;					
				}
			}
			sendPacket(universeBuffer,u.getSubnet(), u.getUniverse());
		}
	}
	
	/**
	 * Sets the broadcast address for the conencted Art-Net network.  We use broadcast mode only.
	 * @param ip a string representing an IP Broadcast Address, e.g. "192.168.4.255"
	 */
	public void setBroadcastAddress(String ip) {
		artnet.setBroadCastAddress(ip);
	}
	
	/**
	 * Called by Processing when the sketch is shut down.  We ask artnet4j to close down its networking.
	 */
	public void dispose() {
		artnet.stop();
	}

	/**
	 * Add logging when artnet4j notices an new node. 
	 */
    @Override
    public void discoveredNewNode(ArtNetNode node) {
        if (netLynx == null) {
            netLynx = node;
            log.debug("found a new node: "+node);
        }
    }

    /**
     * Add logging when artnet4j notices a node disconnecting.
     */
    @Override
    public void discoveredNodeDisconnected(ArtNetNode node) {
        System.out.println("node disconnected: " + node);
        if (node == netLynx) {
            netLynx = null;
        }
    }

    /**
     * Print a summary each time artnet4j's discovery phase completes.
     */
    @Override
    public void discoveryCompleted(List<ArtNetNode> nodes) {
    	log.debug(nodes.size() + " nodes found:");
        for (ArtNetNode n : nodes) {
        	log.debug("   "+n);
        }
    }

    
    /**
     * Sends an Art-Net packet.
     * @param buffer buffer of bytes representing a universe
     * @param subnet the Art-Net subnet to include in the packet
     * @param universe the Art-Net universe to include in the packet
     */
    private void sendPacket(byte[] buffer, int subnet, int universe) {
        ArtDmxPacket dmx = new ArtDmxPacket();
        dmx.setUniverse(subnet,universe);
        dmx.setSequenceID(sequenceID % 255);
        dmx.setDMX(buffer, buffer.length);
        artnet.broadcastPacket(dmx);
        sequenceID++;
    }
    
    /**
     * Add logging when artnet4j encounters an error in its discovery process.
     */
    @Override
    public void discoveryFailed(Throwable t) {
    	log.error("discovery failed: "+t.getMessage(),t);
    }

    /**
     * Set up the art-net networking.  Must be called in Processing init phase.
     */
    public void start() {
        try {
            artnet.getNodeDiscovery().addListener(this);
            artnet.startNodeDiscovery();
        } catch (ArtNetException e) {
            log.error("error starting artnet: "+e.getMessage(),e);
        }
    }
}