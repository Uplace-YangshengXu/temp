import numpy as np
from FBG import FBG_process

def main():
    Load_json_filename = './3CH_4AA_0006.json'
    total_reading_num = 10
    signal_each_ch = np.array([3,0,4,2])
    ref_wavelength = np.array([1,1,1,1,1,1,1,1,1,1])

    fbg_process = FBG_process(Load_json_filename,total_reading_num,signal_each_ch,ref_wavelength)
    raw_data = np.array([1434,4355,3436,2342,5754,2422,8345,7344,6345,5345])
    curvatures = fbg_process.getCurvatures(raw_data)
    print(curvatures)

if __name__ == "__main__":
    main()

