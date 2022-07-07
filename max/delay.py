import time

from pythonosc.udp_client import SimpleUDPClient
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer


client = SimpleUDPClient("127.0.0.1", 12000)
def in_bang(address, *args):
    time.sleep(1)
    client.send_message("/output", "bang")

dispatcher = Dispatcher()
dispatcher.map("/input", in_bang)

server = BlockingOSCUDPServer(("127.0.0.1", 6448), dispatcher)
server.serve_forever()