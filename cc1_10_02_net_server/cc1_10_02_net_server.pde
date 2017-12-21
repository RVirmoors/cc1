// receive ship coords and angle

import processing.net.*;

int port = 10002;      
int counter = 0; // clients
Server myServer;     

void setup()
{
  size(400, 400);
  myServer = new Server(this, port);
}

void draw()
{
  background(0);
  // Get the next available client
  Client thisClient = myServer.available();
  // If the client is not null, and says something, display what it said
  while (thisClient != null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      myServer.write(whatClientSaid);
      println(counter);
    }
    thisClient = myServer.available();
  } 
  text("ships connected: " + counter, 100, 200);
}

void serverEvent(Server myServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
  counter++;
  myServer.write("666," + counter);
}