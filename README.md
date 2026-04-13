# 3DUS Tractography Study

This repository contains materials for the validation and comparison of 3D ultrasound (3DUS) tractography against Diffusion Tensor Imaging (DTI).

## Repository Structure

The repository is organized into three main folders:

### [Data](https://github.com/PaulT95/3DUS-Tractography-Study/tree/main/Data)
Contains the full dataset used for the comparison.

- Includes both 3D ultrasound and DTI processed outputs  
- Data refer to the tibialis anterior muscle at 15° and 35° plantarflexion  
- Sample size: N = 5 subjects  

Within the `3DUS` folder, along with the data, a [MATLAB script](https://github.com/PaulT95/3DUS-Tractography-Study/blob/main/Data/3DUS/Matlab_show/Main.m) is provided to (plug and play):
- Load the dataset  
- Visualize image volumes using a slicer-style viewer  
- Interact with meshes, image planes, and local 3D fascicle vectors and 3D fascicle paths etc.
Furthermore, two pdf are avaiable containing the fascicle length distributions of each subjbect's leg at 15° and 35° plantarflexion, respectively. Distribution "line" are generated using [Kernel smoothing function](https://de.mathworks.com/help/stats/ksdensity.html), specifically [here](https://github.com/PaulT95/3DUS-Tractography-Study/blob/main/Data/3DUS/ALL_FL_dist_mean.pdf) the dashed lines represent the mean of each distribution, while [here](https://github.com/PaulT95/3DUS-Tractography-Study/blob/main/Data/3DUS/ALL_FL_dist_median.pdf) they represent the median.

Within the `DTI` folder the entire output (images mostly) from [QMRITool](https://www.qmritools.com/tool/bids/)  for each subject can be found as well as the overall output.

---

### [R_Stats](https://github.com/PaulT95/3DUS-Tractography-Study/tree/main/R_Stats)
Contains statistical analysis outputs generated in R.

---

### [STL](https://github.com/PaulT95/3DUS-Tractography-Study/tree/main/STL)
Contains 3D printable files used in the experimental setup:

- Footplate for controlling ankle joint angles (15° and 35° plantarflexion) used in the study.
- Custom ultrasound transducer holder with marker attachments for 3D ultrasound acquisition used in the study.  

---

## Notes
This repository is intended to support reproducibility and provide access to both data and tools used in the study.
