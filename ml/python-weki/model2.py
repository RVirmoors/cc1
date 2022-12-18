from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer


def add_example(address, *args):
    print(args)


def default_handler(address, *args):
    print(f"DEFAULT {address}: {args}")


dispatcher = Dispatcher()
dispatcher.map("/wek/inputs", add_example)
dispatcher.map("/train", train)
dispatcher.map("/run", run)

dispatcher.set_default_handler(default_handler)

ip = "127.0.0.1"
port = 6448

server = BlockingOSCUDPServer((ip, port), dispatcher)
server.serve_forever()  # Blocks forever