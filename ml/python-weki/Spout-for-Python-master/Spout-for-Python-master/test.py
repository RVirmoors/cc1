# load library
from Library.Spout import Spout

def main() :
    # create spout object
    spout = Spout(silent = False)
    # create receiver
    spout.createReceiver('maxSender')
    # create sender
    #spout.createSender('output')

    while True :

        # check on close window
        spout.check()
        # receive data
        data = spout.receive()
        # print(len(data))
        # send data
        #spout.send(data)
    
if __name__ == "__main__":
    main()