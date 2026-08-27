This folder contains multiple files which lay out template UI components for
downstreams of Azure Peak to use.

Use extreme caution when modifying any of these files, as they _will_ cause
merge conflicts for all downstreams! The only time you should be changing
these is to update core functionality of the character creator, such as changing
the entire layout of a tab.

Note that the documentation/example comments shouldn't be touched either! Even
if a component changes names, downstream can figure that out better through tsc
than causing a merge conflict.
