import numpy as np
from sm130_read import Interrogator

def main(address, port):
    #print(port)
    interrogator = Interrogator(address,int(port))
    #fbg_reading = interrogator.getData()
    return interrogator

if __name__ == "__main__":
    interrogator = main(address,port)
