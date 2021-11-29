import numpy as np
from sklearn.linear_model import LinearRegression
from pythonosc.dispatcher import Dispatcher
from typing import List, Any

inputs = 3

X = np.array([])
y = np.array([])
training = True

dispatcher = Dispatcher()
reg = LinearRegression()

def add_example(address: str, *args: List[Any]) -> None:
    # ADD TRAINING EXAMPLE
    # ex: input = [0 1 -1 0.5]      # 3 inputs, 1 output
    global X, y, reg, training

    if training:
        Xadd = args[:inputs]
        yadd = args[inputs:]
        print(f"Received input: {Xadd} with output {yadd}")

        if X.size:
            X, y = np.vstack([X, Xadd]), np.vstack([y, yadd])
        else:
            X, y = np.array(Xadd), np.array(yadd)
    else: # RUN
        Xrun = args[:inputs]
        print( "out: ", reg.predict(np.array([Xrun])) )
        outList = reg.predict(np.array([Xrun]))[0]
        client.send_message("/outputs", outList )

def train(address: str, *args: List[Any]) -> None:
    global X, y, reg

    reg.fit(X, y)
    print("trained. score: ", reg.score(X, y))

def run(address: str, *args: List[Any]) -> None:
    global training
    training = not training

dispatcher.map("/inputs", add_example)  # Map wildcard address to set_filter function
dispatcher.map("/train", train)
dispatcher.map("/run", run)

# Set up server and client for testing
from pythonosc.osc_server import BlockingOSCUDPServer
from pythonosc.udp_client import SimpleUDPClient

server = BlockingOSCUDPServer(("127.0.0.1", 6448), dispatcher)
client = SimpleUDPClient("127.0.0.1", 12000)

server.serve_forever() # https://python-osc.readthedocs.io/en/latest/server.html