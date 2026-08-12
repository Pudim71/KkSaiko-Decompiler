# Project Organization

## Structure

### lib/
Shared library modules:
- `api.py` - API fetching and caching
- `dump.py` - Dump utilities and normalization
- `__init__.py` - Package marker

### Analyzers/
Individual analysis scripts:
- `DataType_Dumper.py` - Data type analysis
- `Property_Behavior.py` - Property behavior analysis
- `Default_Props.py` - Default property values
- `Tags_Analyzer.py` - Tag analysis
- `Inheritance_Check.py` - Class inheritance verification
- `NotCreatable_Classes.py` - NotCreatable class listing
- `Content_Properties.py` - Content type properties
- `Class_Properties.py` - Class-type properties

### Root
- `Run_Dumpers.py` - Main script runner

## Usage

```bash
python Run_Dumpers.py [version_hash]
```

All scripts in Analyzers/ folder will be executed automatically.
