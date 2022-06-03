# ajbecerr/ismip6aisgit

This repository contains code and data from **[Seroussi et al. (2020)](https://doi.org/10.5194/tc-14-3033-2020)** as well as additional code written for **[Ghub](https://vhub.org/groups/ghub)**.

However, the code here has additional features which are not currently live on the GHub version (https://vhub.org/groups/ghub/resources?alias=ismip6aissvn). 

Specifically: 
- Given computed scalars, the Jupyter Notebook driver runs Serrousi's MATLAB plotting routine as a subprocess
- Each plot is saved to a temporary directory (```FiguresPaperFinal/```)
- Given a directory of captions (```CaptionsPaperFinal/```), the plots and their captions will populate the notebook

### To run on CCR:

1. Log into **[CCR OnDemand](https://ondemand.ccr.buffalo.edu/pun/sys/dashboard)** and access the Academic Cluster Shell

2. From the command line, clone this repository into your Home Directory
  ```bash
	git clone https://github.com/ajbecerr/ismip6aisgit.git
  ```

3. Request an Interative Jupyter Notebook Session (see **[Instructions](https://ubccr.freshdesk.com/support/solutions/articles/13000080145-jupyter-notebook-apps-academic-cluster)**)

4. Navigate to the repository and launch Ghub.ipynb

5. Run all cells

### To adapt this version of the code for Ghub:
- The Jupyter Notebook driver will have to make use of Hubzero's submit command
- Navigate to **[Ghub's Jupyter Notebook documentation](https://vhub.org/tools/jupyterexamples/)**
- Locate ```Section 5: Creating Hub Tools```
- Click on the link for ```HUBzero Submit``` to access the documentation for Hubzero's submit command
- Implenting this command is a step in the right direction for continuing to develop additional features for this tool

### Ideas for additional features:
- Allow users to upload their own computed scalars through the Jupyter Notebook driver
- Allow users to add their own computed scalars to the existing plots (to compare their new models with the existing models)
- Allow users to compute their own scalars (or develop a 2nd tool that computes scalars for them)
- Add examples with 2D-fields (some of this data is also somewhere on CCR, but perhaps not organized or up-to-date)
- Allow users to upload their own 2D-fields through the Jupyter Notebook driver
- Allow users to add their own 2D-fields to the existing plots (to compare their new models with the existing models)
- Allow users to compute their own 2D-fields (or develop a 2nd tool that computes 2D-fields for them)