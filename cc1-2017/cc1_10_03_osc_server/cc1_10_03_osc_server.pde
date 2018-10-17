// receive ship coords and angle

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 32000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12000;
String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

int counter = 0; // clients   

void setup()
{
  size(400, 400);
  oscP5 = new OscP5(this, myListeningPort);
}

void draw()
{
  background(0);
  text("ships connected: " + counter, 100, 200);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    counter++;
    connect(theOscMessage.netAddress().address());
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    disconnect(theOscMessage.netAddress().address());
    counter--;
  }
  else {
    oscP5.send(theOscMessage, myNetAddressList);
  }
}

 private void connect(String theIPaddress) {
     if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
       myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
     OscMessage mess = new OscMessage("/count");
     mess.add(counter);
     oscP5.send(mess, myNetAddressList);
 }



private void disconnect(String theIPaddress) {
  if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
    myNetAddressList.remove(theIPaddress, myBroadcastPort);
       println("### removing "+theIPaddress+" from the list.");
     } else {
       println("### "+theIPaddress+" is not connected.");
     }
     println("### currently there are "+myNetAddressList.list().size());
     OscMessage mess = new OscMessage("/disconnected");
     oscP5.send(mess, myNetAddressList);
 }