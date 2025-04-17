
## Code Repository - Staying Close to Home: Connectivity constraints in an isolated wolf subpopulation (`LandGen-South-Douro-Wolf`)

This is the code repository for the article ["Staying Close to Home: Connectivity constraints in an isolated wolf subpopulation"](). In this paper, we used landscape genetics to assess which factors – isolation by distance (IBD) and/or isolation by landscape resistance (IBR) – influenced gene flow in the Iberian wolf (*Canis lupus signatus*) subpopulation south of the Douro River (Portugal). To this end, we use the inverse of suitability surfaces (modeled through MaxEnt) together with an individual-based analysis (Multiple Regressions on Distance Matrices; MRDMs) to test our hypotheses. Since the Iberian wolf is an endangered species in Portugal (Pimenta et al., 2023), some of the information used to run the scripts was not made available, as it is considered sensitive.

Repository structure:

+ `output`:
  + `maxent`:
    + `results`: here, there are 3 types of files: PDFs, Excel files and PNG files. PDFs are the output files from MaxEnt. The Excel file contains the variables of the selected MaxEnt models sorted by their contribution to the models' gain. The PNG image shows the comparison of the confidence intervals of the AUC values ​​of the different versions of the models.
    + `suitability_surfaces`: here, there is only one type of file: compressed folders (```.Z```). Inside these folders, you will find the (average) suitability surfaces of each MaxEnt model tested (in ```.asc``` format).
+ `scripts`:
  + here, there is only one type of file: R scripts (```.R```). The scripts were used for (part of) the processing of the variables used in MaxEnt and for performing the MRDMs.
  + `data`:
    + Since the Iberian wolf (*Canis lupus signatus*) is an endangered species in Portugal, some of the input information used in the scripts is not available here.
    + `tif`: here, there is only one type of file: compressed folders (```.zip```). Inside these folders, you will find the raster layers used in the R scripts (in ```.tif``` format).

### References 

Pimenta, V., Barroso, I., Álvares, F., & Petrucci-Fonseca, F. (2023). *Canis lupus* lobo. *In* Mathias, M. L. (coord.), <br> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;Fonseca, C., Rodrigues, L., Grilo, C., Lopes-Fernandes, M., Palmeirim, J. M., Santos-Reis, M., Alves, P. C., <br> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;Cabral, J. A., Ferreira, M., Mira, A., Eira, C., Negrões, N., Paupério, J., Pita, R., Rainho, A., Rosalino, L. M., <br> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;Tapisso, J. T., & Vingada, J. (eds.): *Livro Vermelho dos Mamíferos de Portugal Continental* (pp. 210-211). <br> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;FCiências.ID, ICNF, Lisboa.
