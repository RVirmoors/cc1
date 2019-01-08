// Import the net libraries
import processing.net.*;

// Declare a server
Server server;
int nClients;

String[] ips = new String[8];
int[] position = new int[8];

void setup() {
  size(400,200);
  
  // Create the Server on port 5204
  server = new Server(this, 5204); 
}

void draw() {
  background(200);
  textAlign(CENTER);
  fill(0);
  text("connected: "+nClients, width/2, height/2);
  
  Client client = server.available();
  if (client != null) {
    int xpos = client.read(); 
    int whichClient = which(client.ip());
    // The trim() function is used to remove the extra line break that comes in with the message.
    position[whichClient] = xpos;
  }
  String positions = "";
  for (int i = 0; i < nClients; i++) {
    positions = positions + str(position[i]) + ",";
  }
  text(positions, width/2, 2*height/3);
  server.write(positions+"\n");
}

int which(String ip) {
  int index = 0;
  for (int i = 0; i < nClients; i++) {
    if (ips[i].equals(ip)) {
      index = i;
    }
  }
  return index; 
}


// The serverEvent function is called whenever a new client connects.
void serverEvent(Server server, Client client) {
  ips[nClients] = client.ip();
  nClients++;
  print("client connected ", nClients, client.ip());
}

void disconnectEvent() {
  nClients--;
  print("client disconnected", nClients);
}
