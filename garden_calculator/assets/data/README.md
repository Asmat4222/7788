# Asset data

The calculator's data (crops, mutations, pets) lives in Dart under
`lib/data/datasources/` for type-safety and zero-latency access.

`crops.sample.json` is a human-readable export of the crop catalogue, provided
as a placeholder/reference for anyone who wants to load the data from JSON or a
remote API instead. Swap `GardenRepository` to read this file (via
`rootBundle.loadString`) to move to a data-driven pipeline.
