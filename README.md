# tractem

## Preprocessing

Please see the ***preprocessing*** folder for source code related to transforming 
DW-MRI data into Talairach space. 

## Postprocessing

Please see the ***postprocessing*** folder for source code related to computing tracts and tract density images from the manually created seed and exclusion regions described in the protocol.

## Visualization 

Please see ***visualization*** for miscellaneous utilities for rendering the data from this study. Notably: 
This code assumes that a tractography sample is stored in a ***tracts*** directory and a directory ***movie*** exists. 

* ***headerImages.m*** was used to create the banner image for the TractEM website. 
* ***spinFun.m*** was used to animate each of the tracts in the ***tracts*** directory and save a .mat file with each tract separately to ***movie***. 
* ***animateMovie.m*** was used to stitch together the individual tract images into the movie with the spinning brain that is shown on the TractEM main page. 

The GPLv3 Licensed program along-tract-stats-master is included as a separate unmodified entity for convenience. 
The toolkit can be found here: (https://github.com/johncolby/along-tract-stats)

Additional contributions are welcome. Please contact us via the TractEM website: (https://my.vanderbilt.edu/tractem/)


