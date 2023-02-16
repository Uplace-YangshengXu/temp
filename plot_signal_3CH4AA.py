# this script directly plot signal data for 3ch 4AA needle
# to determine the timeout error

import time
import numpy as np
import queue
import matplotlib.pyplot as plt
from sm130_read import Interrogator


def main():
    address = "192.168.1.11"
    port = 1852
    plot_point = 200
    current_point_num = 0
    current_time = 0
    interrogator = Interrogator(address, int(port))
    time_interval = 0
    fig, axs = plt.subplots(4,1)
    plt.subplots_adjust(wspace=0.3,hspace=0.4)
    fig.set_figwidth(20)
    fig.set_figheight(12)
    axs[0].set_xlabel("time")
    axs[0].set_ylabel("Wavelength")
    axs[0].set_title("CH1AA1")
    axs[1].set_xlabel("time")
    axs[1].set_ylabel("Wavelength")
    axs[1].set_title("CH1AA2")
    axs[2].set_xlabel("time")
    axs[2].set_ylabel("Wavelength")
    axs[2].set_title("CH1AA3")
    axs[3].set_xlabel("time")
    axs[3].set_ylabel("Wavelength")
    axs[3].set_title("CH1AA4")
    """
    axs[1][0].set_xlabel("Time (s)")
    axs[1][0].set_ylabel("Wavelength")
    axs[1][0].set_title("CH2AA1")
    axs[1][1].set_xlabel("Time (s)")
    axs[1][1].set_ylabel("Wavelength")
    axs[1][1].set_title("CH2AA2")
    axs[1][2].set_xlabel("Time (s)")
    axs[1][2].set_ylabel("Wavelength")
    axs[1][2].set_title("CH2AA3")
    axs[1][3].set_xlabel("Time (s)")
    axs[1][3].set_ylabel("Wavelength")
    axs[1][3].set_title("CH2AA4")
    axs[2][0].set_xlabel("Time (s)")
    axs[2][0].set_ylabel("Wavelength")
    axs[2][0].set_title("CH3AA1")
    axs[2][1].set_xlabel("Time (s)")
    axs[2][1].set_ylabel("Wavelength")
    axs[2][1].set_title("CH3AA2")
    axs[2][2].set_xlabel("Time (s)")
    axs[2][2].set_ylabel("Wavelength")
    axs[2][2].set_title("CH3AA3")
    axs[2][3].set_xlabel("Time (s)")
    axs[2][3].set_ylabel("Wavelength")
    axs[2][3].set_title("CH3AA4")
    """
    buff_x = []
    buff_yAA1 = []
    buff_yAA2 = []
    buff_yAA3 = []
    buff_yAA4 = []
    
    while True:
        count = time.perf_counter()

        raw_data = interrogator.getData().reshape((12,))

        current_point_num += 1
        current_time += time_interval
        
        #print(current_point_num)


        if current_point_num <= plot_point:
            """
            axs[0].set_xlim([0,plot_point])
            axs[1].set_xlim([0,plot_point])
            axs[2].set_xlim([0,plot_point])
            axs[3].set_xlim([0,plot_point])
            
            axs[1][0].set_xlim([0,plot_point])
            axs[1][1].set_xlim([0,plot_point])
            axs[1][2].set_xlim([0,plot_point])
            axs[1][3].set_xlim([0,plot_point])
            axs[2][0].set_xlim([0,plot_point])
            axs[2][1].set_xlim([0,plot_point])
            axs[2][2].set_xlim([0,plot_point])
            axs[2][3].set_xlim([0,plot_point])
            """
            buff_x.append(current_time)
            buff_yAA1.append(raw_data[0])
            buff_yAA2.append(raw_data[1])
            buff_yAA3.append(raw_data[2])
            buff_yAA4.append(raw_data[3])

        else:
            #print(np.shape(buff_x))
            buff_yAA1.pop(0)
            buff_yAA2.pop(0)
            buff_yAA3.pop(0)
            buff_yAA4.pop(0)
            buff_x.pop(0)
            buff_x.append(current_time)
            buff_yAA1.append(raw_data[0])
            buff_yAA2.append(raw_data[1])
            buff_yAA3.append(raw_data[2])
            buff_yAA4.append(raw_data[3])



            """
            axs[0].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[1].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[2].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[3].set_xlim([current_point_num-plot_point + 1, current_point_num])
            
            axs[1][0].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[1][1].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[1][2].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[1][3].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[2][0].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[2][1].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[2][2].set_xlim([current_point_num-plot_point + 1, current_point_num])
            axs[2][3].set_xlim([current_point_num-plot_point + 1, current_point_num])
            """

        # plot for CH1 0-3 CH2 4-8 CH3 9-12
        """
        axs[0].scatter(current_point_num,raw_data[0],marker='.',c='r')
        axs[1].scatter(current_point_num,raw_data[1],marker='.',c='r')
        axs[2].scatter(current_point_num,raw_data[2],marker='.',c='r')
        axs[3].scatter(current_point_num,raw_data[3],marker='.',c='r')
        """

        axs[0].plot(buff_x,buff_yAA1,'r')
        axs[1].plot(buff_x,buff_yAA2,'b')
        axs[2].plot(buff_x,buff_yAA3,'g')
        axs[3].plot(buff_x,buff_yAA3,'y')



        """
        axs[1][0].scatter(current_point_num,raw_data[4],marker='.',c='b')
        axs[1][1].scatter(current_point_num,raw_data[5],marker='.',c='b')
        axs[1][2].scatter(current_point_num,raw_data[6],marker='.',c='b')
        axs[1][3].scatter(current_point_num,raw_data[7],marker='.',c='b')
        axs[2][0].scatter(current_point_num,raw_data[8],marker='.',c='g')
        axs[2][1].scatter(current_point_num,raw_data[9],marker='.',c='g')
        axs[2][2].scatter(current_point_num,raw_data[10],marker='.',c='g')
        axs[2][3].scatter(current_point_num,raw_data[11],marker='.',c='g')
        """
        axs[0].grid()
        axs[1].grid()
        axs[2].grid()
        axs[3].grid()

        plt.pause(0.01)
        axs[0].clear()
        axs[1].clear()
        axs[2].clear()
        axs[3].clear()
        axs[0].set_xlabel("time")
        axs[0].set_ylabel("Wavelength")
        axs[0].set_title("CH1AA1")
        axs[1].set_xlabel("time")
        axs[1].set_ylabel("Wavelength")
        axs[1].set_title("CH1AA2")
        axs[2].set_xlabel("time")
        axs[2].set_ylabel("Wavelength")
        axs[2].set_title("CH1AA3")
        axs[3].set_xlabel("time")
        axs[3].set_ylabel("Wavelength")
        axs[3].set_title("CH1AA4")
        

        time_interval = time.perf_counter() - count
        #print(time_interval)
        


if __name__ == "__main__":
    main()
