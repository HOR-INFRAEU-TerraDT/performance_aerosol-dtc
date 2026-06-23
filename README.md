
# TerraDT Software performance history template

Please replace the template notes below with general description relevant for your project.

The repositories created from this template are used to hold documentation on profiling and optimization cycles for TerraDT 
software components, including DTCs, impact models, coupled system bundles or any other relevant software component or integration that is being analyzed.

## Most important
When creating the repo, please add "performance" into the Github Topics! This enables listing and linking to the group of relevant
repositories for example in deliverables and milestone narratives, creating a "living documentation" for the performance work.
The template gives further suggestions for the structure and contents, but these are not strict -- feel free to accommodate to each use case. 

## Suggested structure
The documents and other material describing a specific analysis and/or optimization cycle can be organized in a subdirectory under 'cycles',
named according to the type of analysis and a running number (`cycles/<short-name>-<cycle-id>/`), for example `prof-baseline-001` (or whatever 
makes sense for each case). A new cycle should be triggered for results based on new model version (or a version change of a significant 
subcomponent), version change in a significant component of the HPC software stack etc.

The suggested contents of a cycle folder included in the template is as follows. Feel free to accommodate:
- `report.md`
- `scripts/`         
- `figures/`           
- `data/`            

Just have the results description/main document easily found and in some simple format (md,pdf,txt etc.)
