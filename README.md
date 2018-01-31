# nidmresults-spmhtml

Read and display NIDM-Results packs in the SPM environment.

##### Usage

To view NIDM results using the NIDM results viewer run the following

1. Open `SPM fMRI` from the Matlab command line.
1. Click on Batch.

<img src="Doc/examplemenu1.png" width="200">  |
:-------------------------:
 **Fig. 1.** The SPM menu. |
3. Click on SPM -> Tools -> NIDM-Results Display

<img src="Doc/examplemenu2.png" width="200">  |
:-------------------------:
 **Fig. 2.** The SPM option in the batch window. |
4. Enter the NIDM-Results file you wish to view and where you wish the output html to be stored. You can specify which contrasts to view here or the 'select' option can be chosen to open the contrast window.

<img src="Doc/example_batch.png" width="200"> |  
:-------------------------:|
 **Fig. 3.** The NIDM-Results batch window. |
5. If the 'select' option was chosen and there are multiple contrasts stored inside the NIDM-Results pack, the contrast window will open. Select the contrasts you wish to view and click done. 

<img src="Doc/example_conMan.png" width="200"> |
:-------------------------:|
 **Fig. 4.** The contrast manager window. |
6. This should create output like the below.

<img src="Doc/example1.png" width="300">            |  <img src="Doc/example2.png" width="300">
:-------------------------:|:-------------------------:
 **Fig. 5.** Table data and images  |  **Fig. 6.** Summary statistics

##### Requirements

- [SPM12](http://www.fil.ion.ucl.ac.uk/spm/software/spm12/)

##### Installation

1. Add the filepath to SPM in Matlab;

 ```
 addpath(<full path to SPM>)
 ```
2. Clone this repository into the SPM toolboxes folder (into the below folder).
 ```
 <full path to SPM>/toolbox/
 ``` 

##### Testing

1. Add the filepath to the 'tests' folder;

 ```
addpath(fullfile(fileparts(which('nidm_results_display')), 'test'))
 ```
2. Run runTest;

 ```
 runTest();
 ```
