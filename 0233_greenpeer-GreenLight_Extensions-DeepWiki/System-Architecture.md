# System Architecture

> **Relevant source files**
> * [README.md](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md)

## Purpose and Scope

This document describes the overall architecture of the GreenLight Extensions system, detailing how the core functions `glObjToJson` and `setParamVal` work together to provide JSON serialization and parameter modification capabilities for GreenLight model objects. It covers the internal dependencies, data flow patterns, and integration points within the system.

For detailed usage examples and API documentation, see [Usage Examples and API Reference](/greenpeer/GreenLight_Extensions/2.1-usage-examples-and-api-reference) and [Usage Examples and API Reference](/greenpeer/GreenLight_Extensions/3.1-usage-examples-and-api-reference). For information about the underlying data structures, see [Data Structures and Object Model](/greenpeer/GreenLight_Extensions/4-data-structures-and-object-model).

## High-Level System Overview

The GreenLight Extensions system implements a dual-purpose architecture that provides two primary capabilities: JSON serialization of complex MATLAB objects and programmatic parameter modification of DynamicModel instances.

### Core System Components

```mermaid
flowchart TD

runGreenLight["runGreenLight.m"]
GreenLight_Repo["GreenLight Repository"]
MATLAB_jsonencode["MATLAB jsonencode()"]
glObjToJson["glObjToJson()"]
setParamVal["setParamVal()"]
encodeNestedObj["encodeNestedObj()"]
encodeFieldValue["encodeFieldValue()"]
gl_object["gl object instance"]
DynamicModel_instances["DynamicModel instances"]
DynamicElement_instances["DynamicElement instances"]
function_handles["MATLAB function handles"]
JSON_string["JSON string output"]
modified_parameters["Modified parameter values"]

runGreenLight --> gl_object
gl_object --> glObjToJson
gl_object --> setParamVal
DynamicModel_instances --> setParamVal
DynamicElement_instances --> encodeFieldValue
function_handles --> encodeFieldValue
encodeFieldValue --> MATLAB_jsonencode
MATLAB_jsonencode --> JSON_string
setParamVal --> modified_parameters

subgraph Output_Interfaces ["Output_Interfaces"]
    JSON_string
    modified_parameters
end

subgraph Data_Structures ["Data_Structures"]
    gl_object
    DynamicModel_instances
    DynamicElement_instances
    function_handles
end

subgraph GreenLight_Extensions_Core ["GreenLight_Extensions_Core"]
    glObjToJson
    setParamVal
    encodeNestedObj
    encodeFieldValue
    glObjToJson --> encodeNestedObj
    encodeNestedObj --> encodeFieldValue
end

subgraph External_Dependencies ["External_Dependencies"]
    runGreenLight
    GreenLight_Repo
    MATLAB_jsonencode
    GreenLight_Repo --> runGreenLight
end
```

Sources: [README.md L1-L230](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L1-L230)

## Function Dependency Architecture

The system's internal architecture is built around a clear separation of concerns, with each function having specific responsibilities in the processing pipeline.

### Internal Function Relationships

```mermaid
flowchart TD

glObjToJson_func["glObjToJson(gl)"]
setParamVal_func["setParamVal(dm, attrib, name, val)"]
encodeNestedObj_func["encodeNestedObj(obj)"]
encodeFieldValue_func["encodeFieldValue(fieldName, fieldValue)"]
jsonencode_call["jsonencode() call"]
input_validation["Input validation logic"]
type_coercion["Logical-to-numeric conversion"]
dynamicElement_access["DynamicElement property access"]
function_handle_detection["Function handle detection"]
DynamicElement_processing["DynamicElement processing"]
nested_structure_handling["Nested structure handling"]

glObjToJson_func --> encodeNestedObj_func
encodeFieldValue_func --> function_handle_detection
encodeFieldValue_func --> DynamicElement_processing
encodeFieldValue_func --> nested_structure_handling
setParamVal_func --> input_validation

subgraph Type_Handling_Logic ["Type_Handling_Logic"]
    function_handle_detection
    DynamicElement_processing
    nested_structure_handling
end

subgraph Parameter_Processing_Pipeline ["Parameter_Processing_Pipeline"]
    input_validation
    type_coercion
    dynamicElement_access
    input_validation --> type_coercion
    type_coercion --> dynamicElement_access
end

subgraph JSON_Processing_Pipeline ["JSON_Processing_Pipeline"]
    encodeNestedObj_func
    encodeFieldValue_func
    jsonencode_call
    encodeNestedObj_func --> encodeFieldValue_func
    encodeFieldValue_func --> jsonencode_call
end

subgraph Public_API_Layer ["Public_API_Layer"]
    glObjToJson_func
    setParamVal_func
end
```

Sources: [README.md L140-L218](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L140-L218)

## Data Flow Architecture

The system processes data through two distinct pipelines, each optimized for its specific use case while sharing common type-handling logic.

### Processing Pipeline Data Flow

```mermaid
flowchart TD

gl_input["gl object from runGreenLight"]
param_change_request["Parameter modification request"]
obj_analysis["Object structure analysis"]
recursive_field_processing["Recursive field processing"]
type_specific_encoding["Type-specific encoding"]
json_assembly["JSON structure assembly"]
param_validation["Parameter validation"]
attribute_namespace_check["Attribute namespace check (x/p)"]
dynamicElement_existence_check["DynamicElement existence check"]
value_assignment["Parameter value assignment"]
json_string_output["JSON string"]
updated_model_state["Updated gl object state"]

gl_input --> obj_analysis
gl_input --> param_validation
json_assembly --> json_string_output
param_change_request --> param_validation
value_assignment --> updated_model_state

subgraph Output_Domain ["Output_Domain"]
    json_string_output
    updated_model_state
end

subgraph Parameter_Modification_Flow ["Parameter_Modification_Flow"]
    param_validation
    attribute_namespace_check
    dynamicElement_existence_check
    value_assignment
    param_validation --> attribute_namespace_check
    attribute_namespace_check --> dynamicElement_existence_check
    dynamicElement_existence_check --> value_assignment
end

subgraph JSON_Serialization_Flow ["JSON_Serialization_Flow"]
    obj_analysis
    recursive_field_processing
    type_specific_encoding
    json_assembly
    obj_analysis --> recursive_field_processing
    recursive_field_processing --> type_specific_encoding
    type_specific_encoding --> json_assembly
end

subgraph Input_Domain ["Input_Domain"]
    gl_input
    param_change_request
end
```

Sources: [README.md L23-L33](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L23-L33)

 [README.md L140-L218](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L140-L218)

## Object Model Integration

The system is designed to handle the complex object hierarchies that characterize GreenLight model instances, including nested structures and custom class instances.

### gl Object Structure Processing

```mermaid
flowchart TD

x_namespace["x (State variables)"]
a_namespace["a (Auxiliary variables)"]
u_namespace["u (Control inputs)"]
d_namespace["d (Driving variables)"]
p_namespace["p (Parameters)"]
other_namespaces["c, g, t, e (Other categories)"]
DynamicModel_handling["DynamicModel instance handling"]
DynamicElement_handling["DynamicElement instance handling"]
function_handle_conversion["Function handle to string conversion"]
nested_obj_recursion["Nested object recursion"]
label_field["label field"]
def_field["def field (function definitions)"]
val_field["val field (values/time series)"]

x_namespace --> DynamicModel_handling
a_namespace --> DynamicElement_handling
u_namespace --> function_handle_conversion
d_namespace --> nested_obj_recursion
p_namespace --> DynamicElement_handling
DynamicModel_handling --> label_field
DynamicElement_handling --> label_field
function_handle_conversion --> def_field
nested_obj_recursion --> val_field

subgraph JSON_Representation_Structure ["JSON_Representation_Structure"]
    label_field
    def_field
    val_field
    label_field --> def_field
    def_field --> val_field
end

subgraph Object_Type_Handling ["Object_Type_Handling"]
    DynamicModel_handling
    DynamicElement_handling
    function_handle_conversion
    nested_obj_recursion
end

subgraph gl_Object_Namespaces ["gl_Object_Namespaces"]
    x_namespace
    a_namespace
    u_namespace
    d_namespace
    p_namespace
    other_namespaces
end
```

Sources: [README.md L54-L133](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L54-L133)

## Processing Pipeline Details

### JSON Serialization Pipeline Architecture

The `glObjToJson` function implements a recursive processing architecture that can handle arbitrarily nested object structures while maintaining type safety.

```mermaid
flowchart TD

entry_point["glObjToJson(gl) entry"]
encodeNestedObj_call["encodeNestedObj(gl) call"]
field_iteration["Field-by-field iteration"]
encodeFieldValue_calls["encodeFieldValue(fieldName, fieldValue) calls"]
function_handle_check["isa(fieldValue, 'function_handle')"]
empty_check["isempty(fieldValue)"]
struct_check["isstruct(fieldValue)"]
DynamicElement_check["isa(fieldValue, 'DynamicElement')"]
func2str_conversion["func2str() conversion"]
empty_array_handling["Empty array handling"]
recursive_struct_processing["Recursive struct processing"]
DynamicElement_serialization["DynamicElement serialization"]

encodeFieldValue_calls --> function_handle_check
encodeFieldValue_calls --> empty_check
encodeFieldValue_calls --> struct_check
encodeFieldValue_calls --> DynamicElement_check
function_handle_check --> func2str_conversion
empty_check --> empty_array_handling
struct_check --> recursive_struct_processing
DynamicElement_check --> DynamicElement_serialization

subgraph Encoding_Strategies ["Encoding_Strategies"]
    func2str_conversion
    empty_array_handling
    recursive_struct_processing
    DynamicElement_serialization
end

subgraph Type_Detection_Logic ["Type_Detection_Logic"]
    function_handle_check
    empty_check
    struct_check
    DynamicElement_check
end

subgraph glObjToJson_Processing ["glObjToJson_Processing"]
    entry_point
    encodeNestedObj_call
    field_iteration
    encodeFieldValue_calls
    entry_point --> encodeNestedObj_call
    encodeNestedObj_call --> field_iteration
    field_iteration --> encodeFieldValue_calls
end
```

Sources: [README.md L140-L144](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L140-L144)

 [README.md L165-L199](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L165-L199)

### Parameter Modification Pipeline Architecture

The `setParamVal` function implements comprehensive validation and type coercion to ensure parameter modifications maintain model integrity.

```mermaid
flowchart TD

entry_point_param["setParamVal(dm, attrib, name, val) entry"]
input_validation_param["Input parameter validation"]
logical_conversion["Logical to numeric conversion"]
shape_validation["Value shape validation"]
dynamicElement_access_param["dm.. access"]
attrib_check["attrib ∈ {'x', 'p'} check"]
name_string_check["name is string check"]
val_numeric_check["val is numeric check"]
dynamicElement_exists_check["DynamicElement existence check"]
property_assignment["DynamicElement.val = newVal"]
error_handling["Error throwing on failure"]

input_validation_param --> attrib_check
input_validation_param --> name_string_check
input_validation_param --> val_numeric_check
dynamicElement_access_param --> dynamicElement_exists_check
dynamicElement_exists_check --> property_assignment
dynamicElement_exists_check --> error_handling

subgraph Assignment_Logic ["Assignment_Logic"]
    property_assignment
    error_handling
end

subgraph Validation_Checks ["Validation_Checks"]
    attrib_check
    name_string_check
    val_numeric_check
    dynamicElement_exists_check
end

subgraph setParamVal_Processing ["setParamVal_Processing"]
    entry_point_param
    input_validation_param
    logical_conversion
    shape_validation
    dynamicElement_access_param
    entry_point_param --> input_validation_param
    input_validation_param --> logical_conversion
    logical_conversion --> shape_validation
    shape_validation --> dynamicElement_access_param
end
```

Sources: [README.md L202-L218](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L202-L218)

## Integration Points and External Dependencies

The system serves as a bridge between the MATLAB-based GreenLight modeling environment and external systems that require JSON data exchange or programmatic parameter control.

### External System Integration

| Integration Point | Function | Purpose |
| --- | --- | --- |
| `runGreenLight.m` | Input source | Generates gl object instances |
| `jsonencode()` | JSON output | MATLAB's native JSON serialization |
| DynamicModel classes | Parameter modification | Custom GreenLight model classes |
| DynamicElement classes | Data access | Individual model element access |

The architecture ensures that complex MATLAB objects with nested structures, custom classes, and function handles can be reliably serialized to JSON while maintaining the ability to programmatically modify model parameters without breaking object integrity.

Sources: [README.md L23-L24](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L23-L24)

 [README.md L37-L48](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L37-L48)

 [README.md L223-L226](https://github.com/greenpeer/GreenLight_Extensions/blob/fdc2b4c5/README.md#L223-L226)