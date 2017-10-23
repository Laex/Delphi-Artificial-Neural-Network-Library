unit tensorflow;

interface

Const
  tensorflow_dll = 'tensorflow.dll';

Type
  pTFChar = PAnsiChar;
  ppTFChar = ^pTFChar;
  size_t = NativeUInt;
  int64_t = Int64;
  pint64_t = ^int64_t;
  ppint64_t = ^pint64_t;
  psize_t = ^size_t;
  TEnumType = Cardinal;
  Float = Single;
  pFloat = ^Float;

  // --------------------------------------------------------------------------
  // TF_Version returns a string describing version information of the
  // TensorFlow library. TensorFlow using semantic versioning.
  // TF_CAPI_EXPORT extern const char* TF_Version();
function TF_Version(): pTFChar; cdecl;

// --------------------------------------------------------------------------
// TF_DataType holds the type for a scalar value.  E.g., one slot in a tensor.
// The enum values here are identical to corresponding values in types.proto.
// typedef enum TF_DataType {
Type
  pTF_DataType = ^TF_DataType;
  TF_DataType = TEnumType;

Const
  TF_FLOAT = 1;
  TF_DOUBLE = 2;
  TF_INT32 = 3; // Int32 tensors are always in 'host' memory.
  TF_UINT8 = 4;
  TF_INT16 = 5;
  TF_INT8 = 6;
  TF_STRING = 7;
  TF_COMPLEX64 = 8; // Single-precision complex
  TF_COMPLEX = 8; // Old identifier kept for API backwards compatibility
  TF_INT64 = 9;
  TF_BOOL = 10;
  TF_QINT8 = 11; // Quantized int8
  TF_QUINT8 = 12; // Quantized uint8
  TF_QINT32 = 13; // Quantized int32
  TF_BFLOAT16 = 14; // Float32 truncated to 16 bits.  Only for cast ops.
  TF_QINT16 = 15; // Quantized int16
  TF_QUINT16 = 16; // Quantized uint16
  TF_UINT16 = 17;
  TF_COMPLEX128 = 18; // Double-precision complex
  TF_HALF = 19;
  TF_RESOURCE = 20;
  TF_VARIANT = 21;
  // } TF_DataType;

  // TF_DataTypeSize returns the sizeof() for the underlying type corresponding
  // to the given TF_DataType enum value. Returns 0 for variable length types
  // (eg. TF_STRING) or on failure.
  // TF_CAPI_EXPORT extern size_t TF_DataTypeSize(TF_DataType dt);
function TF_DataTypeSize(dt: TF_DataType): size_t; cdecl;

// --------------------------------------------------------------------------
// TF_Code holds an error code.  The enum values here are identical to
// corresponding values in error_codes.proto.
// typedef enum TF_Code {
Type
  TF_Code = TEnumType;

const
  TF_OK = 0;
  TF_CANCELLED = 1;
  TF_UNKNOWN = 2;
  TF_INVALID_ARGUMENT = 3;
  TF_DEADLINE_EXCEEDED = 4;
  TF_NOT_FOUND = 5;
  TF_ALREADY_EXISTS = 6;
  TF_PERMISSION_DENIED = 7;
  TF_UNAUTHENTICATED = 16;
  TF_RESOURCE_EXHAUSTED = 8;
  TF_FAILED_PRECONDITION = 9;
  TF_ABORTED = 10;
  TF_OUT_OF_RANGE = 11;
  TF_UNIMPLEMENTED = 12;
  TF_INTERNAL = 13;
  TF_UNAVAILABLE = 14;
  TF_DATA_LOSS = 15;
  // } TF_Code;

  // --------------------------------------------------------------------------
  // TF_Status holds error information.  It either has an OK code, or
  // else an error code with an associated error message.
  // typedef struct TF_Status TF_Status;
Type
  TF_Status = record
  end;

  pTF_Status = ^TF_Status;

  // Return a new status object.
  // TF_CAPI_EXPORT extern TF_Status* TF_NewStatus();
function TF_NewStatus(): pTF_Status; cdecl;

// Delete a previously created status object.
// TF_CAPI_EXPORT extern void TF_DeleteStatus(TF_Status*);
procedure TF_DeleteStatus(p: pTF_Status); cdecl;

// Record <code, msg> in *s.  Any previous information is lost.
// A common use is to clear a status: TF_SetStatus(s, TF_OK, "");
// TF_CAPI_EXPORT extern void TF_SetStatus(TF_Status* s, TF_Code code,const char* msg);
procedure TF_SetStatus(s: pTF_Status; code: TF_Code; const msg: pTFChar); cdecl;

// Return the code record in *s.
// TF_CAPI_EXPORT extern TF_Code TF_GetCode(const TF_Status* s);
function TF_GetCode(const s: pTF_Status): TF_Code; cdecl;

// Return a pointer to the (null-terminated) error message in *s.  The
// return value points to memory that is only usable until the next
// mutation to *s.  Always returns an empty string if TF_GetCode(s) is
// TF_OK.
// TF_CAPI_EXPORT extern const char* TF_Message(const TF_Status* s);
function TF_Message(const s: pTF_Status): pTFChar; cdecl;

// --------------------------------------------------------------------------
// TF_Buffer holds a pointer to a block of data and its associated length.
// Typically, the data consists of a serialized protocol buffer, but other data
// may also be held in a buffer.
//
// By default, TF_Buffer itself does not do any memory management of the
// pointed-to block.  If need be, users of this struct should specify how to
// deallocate the block by setting the `data_deallocator` function pointer.
// typedef struct TF_Buffer {
Type
  Tdata_deallocator = procedure(data: Pointer; length: size_t); cdecl;

  TF_Buffer = record
    data: Pointer;
    length: size_t;
    // void (*data_deallocator)(void* data, size_t length);
    data_deallocator: Tdata_deallocator;
  end;

  pTF_Buffer = ^TF_Buffer;
  ppTF_Buffer = ^pTF_Buffer;

  // Makes a copy of the input and sets an appropriate deallocator.  Useful for
  // passing in read-only, input protobufs.
  // TF_CAPI_EXPORT extern TF_Buffer* TF_NewBufferFromString(const void* proto, size_t proto_len);
function TF_NewBufferFromString(const proto: Pointer; proto_len: size_t): pTF_Buffer; cdecl;

// Useful for passing *out* a protobuf.
// TF_CAPI_EXPORT extern TF_Buffer* TF_NewBuffer();
function TF_NewBuffer(): pTF_Buffer; cdecl;
// TF_CAPI_EXPORT extern void TF_DeleteBuffer(TF_Buffer*);
procedure TF_DeleteBuffer(p: pTF_Buffer); cdecl;
// TF_CAPI_EXPORT extern TF_Buffer TF_GetBuffer(TF_Buffer* buffer);
function TF_GetBuffer(buffer: pTF_Buffer): TF_Buffer; cdecl;

// --------------------------------------------------------------------------
// TF_Tensor holds a multi-dimensional array of elements of a single data type.
// For all types other than TF_STRING, the data buffer stores elements
// in row major order.  E.g. if data is treated as a vector of TF_DataType:
//
// element 0:   index (0, ..., 0)
// element 1:   index (0, ..., 1)
// ...
//
// The format for TF_STRING tensors is:
// start_offset: array[uint64]
// data:         byte[...]
//
// The string length (as a varint), followed by the contents of the string
// is encoded at data[start_offset[i]]]. TF_StringEncode and TF_StringDecode
// facilitate this encoding.
// typedef struct TF_Tensor TF_Tensor;
type
  TF_Tensor = record
  end;

  pTF_Tensor = ^TF_Tensor;
  ppTF_Tensor = ^pTF_Tensor;

  // Return a new tensor that holds the bytes data[0,len-1].
  //
  // The data will be deallocated by a subsequent call to TF_DeleteTensor via:
  // (*deallocator)(data, len, deallocator_arg)
  // Clients must provide a custom deallocator function so they can pass in
  // memory managed by something like numpy.
  //
  // TF_CAPI_EXPORT extern TF_Tensor* TF_NewTensor(
  // TF_DataType, const int64_t* dims, int num_dims, void* data, size_t len,
  // void (*deallocator)(void* data, size_t len, void* arg),
  // void* deallocator_arg);

  TDeallocator = procedure(data: Pointer; len: size_t; arg: Pointer); cdecl;

function TF_NewTensor(dt: TF_DataType; const dims: pint64_t; num_dims: Integer; data: Pointer; len: size_t; deallocator: TDeallocator;
  deallocator_arg: Pointer): pTF_Tensor; cdecl;

// Allocate and return a new Tensor.
//
// This function is an alternative to TF_NewTensor and should be used when
// memory is allocated to pass the Tensor to the C API. The allocated memory
// satisfies TensorFlow's memory alignment preferences and should be preferred
// over calling malloc and free.
//
// The caller must set the Tensor values by writing them to the pointer returned
// by TF_TensorData with length TF_TensorByteSize.
// TF_CAPI_EXPORT extern TF_Tensor* TF_AllocateTensor(TF_DataType,const int64_t* dims,int num_dims, size_t len);
function TF_AllocateTensor(dt: TF_DataType; const dims: pint64_t; num_dims: Integer; len: size_t): pTF_Tensor; cdecl;

// Deletes `tensor` and returns a new TF_Tensor with the same content if
// possible. Returns nullptr and leaves `tensor` untouched if not.
// TF_CAPI_EXPORT extern TF_Tensor* TF_TensorMaybeMove(TF_Tensor* tensor);
function TF_TensorMaybeMove(tensor: pTF_Tensor): pTF_Tensor; cdecl;

// Destroy a tensor.
// TF_CAPI_EXPORT extern void TF_DeleteTensor(TF_Tensor*);
procedure TF_DeleteTensor(tensor: pTF_Tensor); cdecl;

// Return the type of a tensor element.
// TF_CAPI_EXPORT extern TF_DataType TF_TensorType(const TF_Tensor*);
function TF_TensorType(const tensor: pTF_Tensor): TF_DataType; cdecl;

// Return the number of dimensions that the tensor has.
// TF_CAPI_EXPORT extern int TF_NumDims(const TF_Tensor*);
function TF_NumDims(const tensor: pTF_Tensor): Integer; cdecl;

// Return the length of the tensor in the "dim_index" dimension.
// REQUIRES: 0 <= dim_index < TF_NumDims(tensor)
// TF_CAPI_EXPORT extern int64_t TF_Dim(const TF_Tensor* tensor, int dim_index);
function TF_Dim(const tensor: pTF_Tensor; dim_index: Integer): int64_t; cdecl;

// Return the size of the underlying data in bytes.
// TF_CAPI_EXPORT extern size_t TF_TensorByteSize(const TF_Tensor*);
function TF_TensorByteSize(const tensor: pTF_Tensor): size_t; cdecl;

// Return a pointer to the underlying data buffer.
// TF_CAPI_EXPORT extern void* TF_TensorData(const TF_Tensor*);
function TF_TensorData(const tensor: pTF_Tensor): Pointer; cdecl;

// --------------------------------------------------------------------------
// Encode the string `src` (`src_len` bytes long) into `dst` in the format
// required by TF_STRING tensors. Does not write to memory more than `dst_len`
// bytes beyond `*dst`. `dst_len` should be at least
// TF_StringEncodedSize(src_len).
//
// On success returns the size in bytes of the encoded string.
// Returns an error into `status` otherwise.
// TF_CAPI_EXPORT extern size_t TF_StringEncode(const char* src, size_t src_len,
// char* dst, size_t dst_len,
// TF_Status* status);
function TF_StringEncode(const src: pTFChar; src_len: size_t; dst: pTFChar; dst_len: size_t; status: pTF_Status): size_t; cdecl;

// Decode a string encoded using TF_StringEncode.
//
// On success, sets `*dst` to the start of the decoded string and `*dst_len` to
// its length. Returns the number of bytes starting at `src` consumed while
// decoding. `*dst` points to memory within the encoded buffer.  On failure,
// `*dst` and `*dst_len` are undefined and an error is set in `status`.
//
// Does not read memory more than `src_len` bytes beyond `src`.
// TF_CAPI_EXPORT extern size_t TF_StringDecode(const char* src, size_t src_len,
// const char** dst, size_t* dst_len,
// TF_Status* status);
function TF_StringDecode(const src: pTFChar; src_len: size_t; const dst: ppTFChar; dst_len: psize_t; status: pTF_Status): size_t; cdecl;

// Return the size in bytes required to encode a string `len` bytes long into a
// TF_STRING tensor.
// TF_CAPI_EXPORT extern size_t TF_StringEncodedSize(size_t len);
function TF_StringEncodedSize(len: size_t): size_t; cdecl;

// --------------------------------------------------------------------------
// TF_SessionOptions holds options that can be passed during session creation.
// typedef struct TF_SessionOptions TF_SessionOptions;
Type
  pTF_SessionOptions = ^TF_SessionOptions;

  TF_SessionOptions = record
  end;

  // Return a new options object.
  // TF_CAPI_EXPORT extern TF_SessionOptions* TF_NewSessionOptions();
function TF_NewSessionOptions(): pTF_SessionOptions; cdecl;

// Set the target in TF_SessionOptions.options.
// target can be empty, a single entry, or a comma separated list of entries.
// Each entry is in one of the following formats :
// "local"
// ip:port
// host:port
// TF_CAPI_EXPORT extern void TF_SetTarget(TF_SessionOptions* options,
// const char* target);
procedure TF_SetTarget(options: pTF_SessionOptions; const target: pTFChar); cdecl;

// Set the config in TF_SessionOptions.options.
// config should be a serialized tensorflow.ConfigProto proto.
// If config was not parsed successfully as a ConfigProto, record the
// error information in *status.
// TF_CAPI_EXPORT extern void TF_SetConfig(TF_SessionOptions* options,
// const void* proto, size_t proto_len,
// TF_Status* status);
procedure TF_SetConfig(options: pTF_SessionOptions; const proto: Pointer; proto_len: size_t; status: pTF_Status); cdecl;

// Destroy an options object.
// TF_CAPI_EXPORT extern void TF_DeleteSessionOptions(TF_SessionOptions*);
procedure TF_DeleteSessionOptions(options: pTF_SessionOptions); cdecl;

// TODO(jeff,sanjay):
// - export functions to set Config fields

// --------------------------------------------------------------------------
// The new graph construction API, still under development.

// Represents a computation graph.  Graphs may be shared between sessions.
// Graphs are thread-safe when used as directed below.
// typedef struct TF_Graph TF_Graph;
Type
  pTF_Graph = ^TF_Graph;

  TF_Graph = record
  end;

  // Return a new graph object.
  // TF_CAPI_EXPORT extern TF_Graph* TF_NewGraph();
function TF_NewGraph(): pTF_Graph; cdecl;

// Destroy an options object.  Graph will be deleted once no more
// TFSession's are referencing it.
// TF_CAPI_EXPORT extern void TF_DeleteGraph(TF_Graph*);
procedure TF_DeleteGraph(Graph: pTF_Graph); cdecl;

Type
  // Operation being built. The underlying graph must outlive this.
  // typedef struct TF_OperationDescription TF_OperationDescription;
  pTF_OperationDescription = ^TF_OperationDescription;

  TF_OperationDescription = record
  end;

  // Operation that has been added to the graph. Valid until the graph is
  // deleted -- in particular adding a new operation to the graph does not
  // invalidate old TF_Operation* pointers.
  // typedef struct TF_Operation TF_Operation;
  pTF_Operation = ^TF_Operation;
  ppTF_Operation = ^pTF_Operation;

  TF_Operation = record
  end;

  // Represents a specific input of an operation.
  pTF_Input = ^TF_Input;

  TF_Input = record // typedef struct TF_Input {
    oper: pTF_Operation; // TF_Operation* oper;
    index: Integer; // int index;  // The index of the input within oper.
  end; // } TF_Input;

  // Represents a specific output of an operation.
  pTF_Output = ^TF_Output;

  TF_Output = record // typedef struct TF_Output {
    oper: pTF_Operation; // TF_Operation* oper;
    index: Integer; // int index;  // The index of the output within oper.
  end; // } TF_Output;

  // TF_Function is a grouping of operations with defined inputs and outputs.
  // Once created and added to graphs, functions can be invoked by creating an
  // operation whose operation type matches the function name.
  // typedef struct TF_Function TF_Function;
  pTF_Function = ^TF_Function;

  TF_Function = record
  end;

  // Function definition options. TODO(iga): Define and implement
  // typedef struct TF_FunctionOptions TF_FunctionOptions;
  pTF_FunctionOptions = ^TF_FunctionOptions;

  TF_FunctionOptions = record
  end;

  // Sets the shape of the Tensor referenced by `output` in `graph` to
  // the shape described by `dims` and `num_dims`.
  //
  // If the number of dimensions is unknown, `num_dims` must be set to
  // -1 and `dims` can be null. If a dimension is unknown, the
  // corresponding entry in the `dims` array must be -1.
  //
  // This does not overwrite the existing shape associated with `output`,
  // but merges the input shape with the existing shape.  For example,
  // setting a shape of [-1, 2] with an existing shape [2, -1] would set
  // a final shape of [2, 2] based on shape merging semantics.
  //
  // Returns an error into `status` if:
  // * `output` is not in `graph`.
  // * An invalid shape is being set (e.g., the shape being set
  // is incompatible with the existing shape).
  // TF_CAPI_EXPORT extern void TF_GraphSetTensorShape(TF_Graph* graph,
  // TF_Output output,
  // const int64_t* dims,
  // const int num_dims,
  // TF_Status* status);
procedure TF_GraphSetTensorShape(Graph: pTF_Graph; output: TF_Output; const dims: int64_t; const num_dims: Integer;
  status: pTF_Status); cdecl;

// Returns the number of dimensions of the Tensor referenced by `output`
// in `graph`.
//
// If the number of dimensions in the shape is unknown, returns -1.
//
// Returns an error into `status` if:
// * `output` is not in `graph`.
// TF_CAPI_EXPORT extern int TF_GraphGetTensorNumDims(TF_Graph* graph,
// TF_Output output,
// TF_Status* status);
function TF_GraphGetTensorNumDims(Graph: pTF_Graph; output: TF_Output; status: pTF_Status): Integer; cdecl;

// Returns the shape of the Tensor referenced by `output` in `graph`
// into `dims`. `dims` must be an array large enough to hold `num_dims`
// entries (e.g., the return value of TF_GraphGetTensorNumDims).
//
// If the number of dimensions in the shape is unknown or the shape is
// a scalar, `dims` will remain untouched. Otherwise, each element of
// `dims` will be set corresponding to the size of the dimension. An
// unknown dimension is represented by `-1`.
//
// Returns an error into `status` if:
// * `output` is not in `graph`.
// * `num_dims` does not match the actual number of dimensions.
// TF_CAPI_EXPORT extern void TF_GraphGetTensorShape(TF_Graph* graph,
// TF_Output output,
// int64_t* dims, int num_dims,
// TF_Status* status);
procedure TF_GraphGetTensorShape(Graph: pTF_Graph; output: TF_Output; dims: pint64_t; num_dims: Integer; status: pTF_Status); cdecl;

// Operation will only be added to *graph when TF_FinishOperation() is
// called (assuming TF_FinishOperation() does not return an error).
// *graph must not be deleted until after TF_FinishOperation() is
// called.
// TF_CAPI_EXPORT extern TF_OperationDescription* TF_NewOperation(
// TF_Graph* graph, const char* op_type, const char* oper_name);
function TF_NewOperation(Graph: pTF_Graph; const op_type: pTFChar; const oper_name: pTFChar): pTF_OperationDescription;
cdecl

// Specify the device for `desc`.  Defaults to empty, meaning unconstrained.
// TF_CAPI_EXPORT extern void TF_SetDevice(TF_OperationDescription* desc,
// const char* device);
procedure TF_SetDevice(desc: pTF_OperationDescription; const device: pTFChar);
cdecl;

// The calls to TF_AddInput and TF_AddInputList must match (in number,
// order, and type) the op declaration.  For example, the "Concat" op
// has registration:
// REGISTER_OP("Concat")
// .Input("concat_dim: int32")
// .Input("values: N * T")
// .Output("output: T")
// .Attr("N: int >= 2")
// .Attr("T: type");
// that defines two inputs, "concat_dim" and "values" (in that order).
// You must use TF_AddInput() for the first input (since it takes a
// single tensor), and TF_AddInputList() for the second input (since
// it takes a list, even if you were to pass a list with a single
// tensor), as in:
// TF_OperationDescription* desc = TF_NewOperation(graph, "Concat", "c");
// TF_Output concat_dim_input = {...};
// TF_AddInput(desc, concat_dim_input);
// TF_Output values_inputs[5] = {{...}, ..., {...}};
// TF_AddInputList(desc, values_inputs, 5);

// For inputs that take a single tensor.
// TF_CAPI_EXPORT extern void TF_AddInput(TF_OperationDescription* desc,
// TF_Output input);
procedure TF_AddInput(desc: pTF_OperationDescription; input: TF_Output); cdecl;

// For inputs that take a list of tensors.
// inputs must point to TF_Output[num_inputs].
// TF_CAPI_EXPORT extern void TF_AddInputList(TF_OperationDescription* desc,
// const TF_Output* inputs,
// int num_inputs);
procedure TF_AddInputList(desc: pTF_OperationDescription; const inputs: pTF_Output; num_inputs: Integer); cdecl;

// Call once per control input to `desc`.
// TF_CAPI_EXPORT extern void TF_AddControlInput(TF_OperationDescription* desc,
// TF_Operation* input);
procedure TF_AddControlInput(desc: pTF_OperationDescription; input: pTF_Operation); cdecl;

// Request that `desc` be co-located on the device where `op`
// is placed.
//
// Use of this is discouraged since the implementation of device placement is
// subject to change. Primarily intended for internal libraries
// TF_CAPI_EXPORT extern void TF_ColocateWith(TF_OperationDescription* desc,
// TF_Operation* op);
procedure TF_ColocateWith(desc: pTF_OperationDescription; op: pTF_Operation); cdecl;

// Call some TF_SetAttr*() function for every attr that is not
// inferred from an input and doesn't have a default value you wish to
// keep.

// `value` must point to a string of length `length` bytes.
// TF_CAPI_EXPORT extern void TF_SetAttrString(TF_OperationDescription* desc,
// const char* attr_name,
// const void* value, size_t length);
procedure TF_SetAttrString(desc: pTF_OperationDescription; const attr_name: pTFChar; const value: Pointer; length: size_t); cdecl;

// `values` and `lengths` each must have lengths `num_values`.
// `values[i]` must point to a string of length `lengths[i]` bytes.
// TF_CAPI_EXPORT extern void TF_SetAttrStringList(TF_OperationDescription* desc,
// const char* attr_name,
// const void* const* values,
// const size_t* lengths,
// int num_values);
procedure TF_SetAttrStringList(desc: pTF_OperationDescription; const attr_name: pTFChar; const values: ppTFChar; const lengths: psize_t;
  num_values: Integer); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrInt(TF_OperationDescription* desc,
// const char* attr_name, int64_t value);
procedure TF_SetAttrInt(desc: pTF_OperationDescription; const attr_name: pTFChar; value: int64_t); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrIntList(TF_OperationDescription* desc,
// const char* attr_name,
// const int64_t* values,
// int num_values);
procedure TF_SetAttrIntList(desc: pTF_OperationDescription; const attr_name: pTFChar; const values: pint64_t; num_values: Integer); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrFloat(TF_OperationDescription* desc,
// const char* attr_name, float value);
procedure TF_SetAttrFloat(desc: pTF_OperationDescription; const attr_name: pTFChar; value: Float); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrFloatList(TF_OperationDescription* desc,
// const char* attr_name,
// const float* values,
// int num_values);
procedure TF_SetAttrFloatList(desc: pTF_OperationDescription; const attr_name: pTFChar; const values: pFloat; num_values: Integer); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrBool(TF_OperationDescription* desc,
// const char* attr_name,
// unsigned char value);
procedure TF_SetAttrBool(desc: pTF_OperationDescription; const attr_name: pTFChar; value: Byte); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrBoolList(TF_OperationDescription* desc,
// const char* attr_name,
// const unsigned char* values,
// int num_values);
procedure TF_SetAttrBoolList(desc: pTF_OperationDescription; const attr_name: pTFChar; const values: PByte; num_values: Integer); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrType(TF_OperationDescription* desc,
// const char* attr_name,
// TF_DataType value);
procedure TF_SetAttrType(desc: pTF_OperationDescription; const attr_name: pTFChar; value: TF_DataType); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrTypeList(TF_OperationDescription* desc,
// const char* attr_name,
// const TF_DataType* values,
// int num_values);
procedure TF_SetAttrTypeList(desc: pTF_OperationDescription; const attr_name: pTFChar; const values: pTF_DataType;
  num_values: Integer); cdecl;

// Set `num_dims` to -1 to represent "unknown rank".  Otherwise,
// `dims` points to an array of length `num_dims`.  `dims[i]` must be
// >= -1, with -1 meaning "unknown dimension".
// TF_CAPI_EXPORT extern void TF_SetAttrShape(TF_OperationDescription* desc,
// const char* attr_name,
// const int64_t* dims, int num_dims);
procedure TF_SetAttrShape(desc: pTF_OperationDescription; const attr_name: pTFChar; const dims: pint64_t; num_dims: Integer); cdecl;

// `dims` and `num_dims` must point to arrays of length `num_shapes`.
// Set `num_dims[i]` to -1 to represent "unknown rank".  Otherwise,
// `dims[i]` points to an array of length `num_dims[i]`.  `dims[i][j]`
// must be >= -1, with -1 meaning "unknown dimension".
// TF_CAPI_EXPORT extern void TF_SetAttrShapeList(TF_OperationDescription* desc,
// const char* attr_name,
// const int64_t* const* dims,
// const int* num_dims,
// int num_shapes);
procedure TF_SetAttrShapeList(desc: pTF_OperationDescription; const attr_name: pTFChar; const dims: PPChar; const num_dims: PInteger;
  num_shapes: Integer); cdecl;

// `proto` must point to an array of `proto_len` bytes representing a
// binary-serialized TensorShapeProto.
// TF_CAPI_EXPORT extern void TF_SetAttrTensorShapeProto(
// TF_OperationDescription* desc, const char* attr_name, const void* proto,
// size_t proto_len, TF_Status* status);
procedure TF_SetAttrTensorShapeProto(desc: TF_OperationDescription; const attr_name: pTFChar; const proto: Pointer; proto_len: size_t;
  status: pTF_Status); cdecl;

// `protos` and `proto_lens` must point to arrays of length `num_shapes`.
// `protos[i]` must point to an array of `proto_lens[i]` bytes
// representing a binary-serialized TensorShapeProto.
// TF_CAPI_EXPORT extern void TF_SetAttrTensorShapeProtoList(
// TF_OperationDescription* desc, const char* attr_name,
// const void* const* protos, const size_t* proto_lens, int num_shapes,
// TF_Status* status);
procedure TF_SetAttrTensorShapeProtoList(desc: pTF_OperationDescription; const attr_name: pTFChar; const protos: pPointer;
  const proto_lens: psize_t; num_shapes: Integer; status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrTensor(TF_OperationDescription* desc,
// const char* attr_name,
// TF_Tensor* value,
// TF_Status* status);
procedure TF_SetAttrTensor(desc: pTF_OperationDescription; const attr_name: pTFChar; value: pTF_Tensor; status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_SetAttrTensorList(TF_OperationDescription* desc,
// const char* attr_name,
// TF_Tensor* const* values,
// int num_values,
// TF_Status* status);

procedure TF_SetAttrTensorList(desc: pTF_OperationDescription; const attr_name: pTFChar; values: ppTF_Tensor; num_values: Integer;
  status: pTF_Status); cdecl;

// `proto` should point to a sequence of bytes of length `proto_len`
// representing a binary serialization of an AttrValue protocol
// buffer.
// TF_CAPI_EXPORT extern void TF_SetAttrValueProto(TF_OperationDescription* desc,
// const char* attr_name,
// const void* proto,
// size_t proto_len,
// TF_Status* status);
procedure TF_SetAttrValueProto(desc: pTF_OperationDescription; const attr_name: pTFChar; const proto: Pointer; proto_len: size_t;
  status: pTF_Status); cdecl;

// If this function succeeds:
// * *status is set to an OK value,
// * a TF_Operation is added to the graph,
// * a non-null value pointing to the added operation is returned --
// this value is valid until the underlying graph is deleted.
// Otherwise:
// * *status is set to a non-OK value,
// * the graph is not modified,
// * a null value is returned.
// In either case, it deletes `desc`.
// TF_CAPI_EXPORT extern TF_Operation* TF_FinishOperation(
// TF_OperationDescription* desc, TF_Status* status);
function TF_FinishOperation(desc: pTF_OperationDescription; status: pTF_Status): pTF_Operation; cdecl;

// TF_Operation functions.  Operations are immutable once created, so
// these are all query functions.

// TF_CAPI_EXPORT extern const char* TF_OperationName(TF_Operation* oper);
function TF_OperationName(oper: pTF_Operation): pTFChar; cdecl;

// TF_CAPI_EXPORT extern const char* TF_OperationOpType(TF_Operation* oper);
function TF_OperationOpType(oper: pTF_Operation): pTFChar; cdecl;

// TF_CAPI_EXPORT extern const char* TF_OperationDevice(TF_Operation* oper);
function TF_OperationDevice(oper: pTF_Operation): pTFChar; cdecl;

// TF_CAPI_EXPORT extern int TF_OperationNumOutputs(TF_Operation* oper);
function TF_OperationNumOutputs(oper: pTF_Operation): Integer; cdecl;

// TF_CAPI_EXPORT extern TF_DataType TF_OperationOutputType(TF_Output oper_out);
function TF_OperationOutputType(oper_out: TF_Output): TF_DataType; cdecl;

// TF_CAPI_EXPORT extern int TF_OperationOutputListLength(TF_Operation* oper,
// const char* arg_name,
// TF_Status* status);
function TF_OperationOutputListLength(oper: pTF_Operation; const arg_name: pTFChar; status: pTF_Status): Integer; cdecl;

// TF_CAPI_EXPORT extern int TF_OperationNumInputs(TF_Operation* oper);
function TF_OperationNumInputs(oper: pTF_Operation): Integer; cdecl;

// TF_CAPI_EXPORT extern TF_DataType TF_OperationInputType(TF_Input oper_in);
function TF_OperationInputType(oper_in: TF_Input): TF_DataType; cdecl;

// TF_CAPI_EXPORT extern int TF_OperationInputListLength(TF_Operation* oper,
// const char* arg_name,
// TF_Status* status);
function TF_OperationInputListLength(oper: pTF_Operation; const arg_name: pTFChar; status: pTF_Status): Integer; cdecl;

// In this code:
// TF_Output producer = TF_OperationInput(consumer);
// There is an edge from producer.oper's output (given by
// producer.index) to consumer.oper's input (given by consumer.index).
// TF_CAPI_EXPORT extern TF_Output TF_OperationInput(TF_Input oper_in);
function TF_OperationInput(oper_in: TF_Input): TF_Output; cdecl;

// Get the number of current consumers of a specific output of an
// operation.  Note that this number can change when new operations
// are added to the graph.
// TF_CAPI_EXPORT extern int TF_OperationOutputNumConsumers(TF_Output oper_out);
function TF_OperationOutputNumConsumers(oper_out: TF_Output): Integer; cdecl;

// Get list of all current consumers of a specific output of an
// operation.  `consumers` must point to an array of length at least
// `max_consumers` (ideally set to
// TF_OperationOutputNumConsumers(oper_out)).  Beware that a concurrent
// modification of the graph can increase the number of consumers of
// an operation.  Returns the number of output consumers (should match
// TF_OperationOutputNumConsumers(oper_out)).
// TF_CAPI_EXPORT extern int TF_OperationOutputConsumers(TF_Output oper_out,
// TF_Input* consumers,
// int max_consumers);
function TF_OperationOutputConsumers(oper_out: TF_Output; consumers: pTF_Input; max_consumers: Integer): Integer; cdecl;

// Get the number of control inputs to an operation.
// TF_CAPI_EXPORT extern int TF_OperationNumControlInputs(TF_Operation* oper);
function TF_OperationNumControlInputs(oper: pTF_Operation): Integer; cdecl;

// Get list of all control inputs to an operation.  `control_inputs` must
// point to an array of length `max_control_inputs` (ideally set to
// TF_OperationNumControlInputs(oper)).  Returns the number of control
// inputs (should match TF_OperationNumControlInputs(oper)).
// TF_CAPI_EXPORT extern int TF_OperationGetControlInputs(
// TF_Operation* oper, TF_Operation** control_inputs, int max_control_inputs);
function TF_OperationGetControlInputs(oper: pTF_Operation; control_inputs: ppTF_Operation; max_control_inputs: Integer): Integer; cdecl;

// Get the number of operations that have `*oper` as a control input.
// Note that this number can change when new operations are added to
// the graph.
// TF_CAPI_EXPORT extern int TF_OperationNumControlOutputs(TF_Operation* oper);
function TF_OperationNumControlOutputs(oper: pTF_Operation): Integer; cdecl;

// Get the list of operations that have `*oper` as a control input.
// `control_outputs` must point to an array of length at least
// `max_control_outputs` (ideally set to
// TF_OperationNumControlOutputs(oper)). Beware that a concurrent
// modification of the graph can increase the number of control
// outputs.  Returns the number of control outputs (should match
// TF_OperationNumControlOutputs(oper)).
// TF_CAPI_EXPORT extern int TF_OperationGetControlOutputs(
// TF_Operation* oper, TF_Operation** control_outputs,
// int max_control_outputs);
function TF_OperationGetControlOutputs(oper: pTF_Operation; control_outputs: ppTF_Operation; max_control_outputs: Integer): Integer; cdecl;

Type
  // TF_AttrType describes the type of the value of an attribute on an operation.
  TF_AttrType = TEnumType; // typedef enum TF_AttrType {

const
  TF_ATTR_STRING = 0;
  TF_ATTR_INT = 1;
  TF_ATTR_FLOAT = 2;
  TF_ATTR_BOOL = 3;
  TF_ATTR_TYPE = 4;
  TF_ATTR_SHAPE = 5;
  TF_ATTR_TENSOR = 6;
  TF_ATTR_PLACEHOLDER = 7;
  TF_ATTR_FUNC = 8;
  // } TF_AttrType;

Type
  // TF_AttrMetadata describes the value of an attribute on an operation.
  pTF_AttrMetadata = ^TF_AttrMetadata;

  TF_AttrMetadata = record // typedef struct TF_AttrMetadata {
    // A boolean: 1 if the attribute value is a list, 0 otherwise.
    is_list: Byte; // unsigned char is_list;

    // Length of the list if is_list is true. Undefined otherwise.
    list_size: int64_t; // int64_t list_size;

    // Type of elements of the list if is_list != 0.
    // Type of the single value stored in the attribute if is_list == 0.
    _type: TF_AttrType; // TF_AttrType type;

    // Total size the attribute value.
    // The units of total_size depend on is_list and type.
    // (1) If type == TF_ATTR_STRING and is_list == 0
    // then total_size is the byte size of the string
    // valued attribute.
    // (2) If type == TF_ATTR_STRING and is_list == 1
    // then total_size is the cumulative byte size
    // of all the strings in the list.
    // (3) If type == TF_ATTR_SHAPE and is_list == 0
    // then total_size is the number of dimensions
    // of the shape valued attribute, or -1
    // if its rank is unknown.
    // (4) If type == TF_ATTR_SHAPE and is_list == 1
    // then total_size is the cumulative number
    // of dimensions of all shapes in the list.
    // (5) Otherwise, total_size is undefined.
    total_size: int64_t; // int64_t total_size;
  end; // } TF_AttrMetadata;

  // Returns metadata about the value of the attribute `attr_name` of `oper`.
  // TF_CAPI_EXPORT extern TF_AttrMetadata TF_OperationGetAttrMetadata(
  // TF_Operation* oper, const char* attr_name, TF_Status* status);
function TF_OperationGetAttrMetadata(oper: pTF_Operation; const attr_name: pTFChar; status: pTF_Status): TF_AttrMetadata; cdecl;

// Fills in `value` with the value of the attribute `attr_name`.  `value` must
// point to an array of length at least `max_length` (ideally set to
// TF_AttrMetadata.total_size from TF_OperationGetAttrMetadata(oper,
// attr_name)).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrString(TF_Operation* oper,
// const char* attr_name,
// void* value,
// size_t max_length,
// TF_Status* status);
procedure TF_OperationGetAttrString(oper: pTF_Operation; const attr_name: pTFChar; value: Pointer; max_length: size_t;
  status: pTF_Status); cdecl;

// Get the list of strings in the value of the attribute `attr_name`.  Fills in
// `values` and `lengths`, each of which must point to an array of length at
// least `max_values`.
//
// The elements of values will point to addresses in `storage` which must be at
// least `storage_size` bytes in length.  Ideally, max_values would be set to
// TF_AttrMetadata.list_size and `storage` would be at least
// TF_AttrMetadata.total_size, obtained from TF_OperationGetAttrMetadata(oper,
// attr_name).
//
// Fails if storage_size is too small to hold the requested number of strings.
// TF_CAPI_EXPORT extern void TF_OperationGetAttrStringList(
// TF_Operation* oper, const char* attr_name, void** values, size_t* lengths,
// int max_values, void* storage, size_t storage_size, TF_Status* status);
procedure TF_OperationGetAttrStringList(oper: pTF_Operation; const attr_name: pTFChar; values: pPointer; lengths: psize_t;
  max_values: Integer; storage: pPointer; storage_size: size_t; status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_OperationGetAttrInt(TF_Operation* oper,
// const char* attr_name,
// int64_t* value,
// TF_Status* status);
procedure TF_OperationGetAttrInt(oper: pTF_Operation; const attr_name: pTFChar; value: pint64_t; status: pTF_Status); cdecl;

// Fills in `values` with the value of the attribute `attr_name` of `oper`.
// `values` must point to an array of length at least `max_values` (ideally set
// TF_AttrMetadata.list_size from TF_OperationGetAttrMetadata(oper,
// attr_name)).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrIntList(TF_Operation* oper,
// const char* attr_name,
// int64_t* values,
// int max_values,
// TF_Status* status);
procedure TF_OperationGetAttrIntList(oper: pTF_Operation; const attr_name: pTFChar; values: pint64_t; max_values: Integer;
  status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_OperationGetAttrFloat(TF_Operation* oper,
// const char* attr_name,
// float* value,
// TF_Status* status);
procedure TF_OperationGetAttrFloat(oper: pTF_Operation; const attr_name: pTFChar; value: pFloat; status: pTF_Status); cdecl;

// Fills in `values` with the value of the attribute `attr_name` of `oper`.
// `values` must point to an array of length at least `max_values` (ideally set
// to TF_AttrMetadata.list_size from TF_OperationGetAttrMetadata(oper,
// attr_name)).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrFloatList(TF_Operation* oper,
// const char* attr_name,
// float* values,
// int max_values,
// TF_Status* status);
procedure TF_OperationGetAttrFloatList(oper: pTF_Operation; const attr_name: pTFChar; values: pFloat; max_values: Integer;
  status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_OperationGetAttrBool(TF_Operation* oper,
// const char* attr_name,
// unsigned char* value,
// TF_Status* status);
procedure TF_OperationGetAttrBool(oper: pTF_Operation; const attr_name: pTFChar; value: PByte; status: pTF_Status); cdecl;

// Fills in `values` with the value of the attribute `attr_name` of `oper`.
// `values` must point to an array of length at least `max_values` (ideally set
// to TF_AttrMetadata.list_size from TF_OperationGetAttrMetadata(oper,
// attr_name)).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrBoolList(TF_Operation* oper,
// const char* attr_name,
// unsigned char* values,
// int max_values,
// TF_Status* status);
procedure TF_OperationGetAttrBoolList(oper: pTF_Operation; const attr_name: pTFChar; values: PByte; max_values: Integer;
  status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_OperationGetAttrType(TF_Operation* oper,
// const char* attr_name,
// TF_DataType* value,
// TF_Status* status);
procedure TF_OperationGetAttrType(oper: pTF_Operation; const attr_name: pTFChar; value: pTF_DataType; status: pTF_Status); cdecl;

// Fills in `values` with the value of the attribute `attr_name` of `oper`.
// `values` must point to an array of length at least `max_values` (ideally set
// to TF_AttrMetadata.list_size from TF_OperationGetAttrMetadata(oper,
// attr_name)).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrTypeList(TF_Operation* oper,
// const char* attr_name,
// TF_DataType* values,
// int max_values,
// TF_Status* status);
procedure TF_OperationGetAttrTypeList(oper: pTF_Operation; const attr_name: pTFChar; values: pTF_DataType; max_values: Integer;
  status: pTF_Status); cdecl;

// Fills in `value` with the value of the attribute `attr_name` of `oper`.
// `values` must point to an array of length at least `num_dims` (ideally set to
// TF_Attr_Meta.size from TF_OperationGetAttrMetadata(oper, attr_name)).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrShape(TF_Operation* oper,
// const char* attr_name,
// int64_t* value,
// int num_dims,
// TF_Status* status);
procedure TF_OperationGetAttrShape(oper: pTF_Operation; const attr_name: pTFChar; value: pint64_t; num_dims: Integer;
  status: pTF_Status); cdecl;

// Fills in `dims` with the list of shapes in the attribute `attr_name` of
// `oper` and `num_dims` with the corresponding number of dimensions. On return,
// for every i where `num_dims[i]` > 0, `dims[i]` will be an array of
// `num_dims[i]` elements. A value of -1 for `num_dims[i]` indicates that the
// i-th shape in the list is unknown.
//
// The elements of `dims` will point to addresses in `storage` which must be
// large enough to hold at least `storage_size` int64_ts.  Ideally, `num_shapes`
// would be set to TF_AttrMetadata.list_size and `storage_size` would be set to
// TF_AttrMetadata.total_size from TF_OperationGetAttrMetadata(oper,
// attr_name).
//
// Fails if storage_size is insufficient to hold the requested shapes.
// TF_CAPI_EXPORT extern void TF_OperationGetAttrShapeList(
// TF_Operation* oper, const char* attr_name, int64_t** dims, int* num_dims,
// int num_shapes, int64_t* storage, int storage_size, TF_Status* status);
procedure TF_OperationGetAttrShapeList(oper: pTF_Operation; const attr_name: pTFChar; dims: ppint64_t; num_dims: PInteger;
  num_shapes: Integer; storage: pint64_t; storage_size: Integer; status: pTF_Status); cdecl;

// Sets `value` to the binary-serialized TensorShapeProto of the value of
// `attr_name` attribute of `oper`'.
// TF_CAPI_EXPORT extern void TF_OperationGetAttrTensorShapeProto(
// TF_Operation* oper, const char* attr_name, TF_Buffer* value,
// TF_Status* status);
procedure TF_OperationGetAttrTensorShapeProto(oper: pTF_Operation; const attr_name: pTFChar; value: pTF_Buffer; status: pTF_Status); cdecl;

// Fills in `values` with binary-serialized TensorShapeProto values of the
// attribute `attr_name` of `oper`. `values` must point to an array of length at
// least `num_values` (ideally set to TF_AttrMetadata.list_size from
// TF_OperationGetAttrMetadata(oper, attr_name)).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrTensorShapeProtoList(
// TF_Operation* oper, const char* attr_name, TF_Buffer** values,
// int max_values, TF_Status* status);
procedure TF_OperationGetAttrTensorShapeProtoList(oper: pTF_Operation; const attr_name: pTFChar; values: ppTF_Buffer; max_values: Integer;
  status: pTF_Status); cdecl;

// Gets the TF_Tensor valued attribute of `attr_name` of `oper`.
//
// Allocates a new TF_Tensor which the caller is expected to take
// ownership of (and can deallocate using TF_DeleteTensor).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrTensor(TF_Operation* oper,
// const char* attr_name,
// TF_Tensor** value,
// TF_Status* status);
procedure TF_OperationGetAttrTensor(oper: pTF_Operation; const attr_name: pTFChar; value: ppTF_Tensor; status: pTF_Status); cdecl;

// Fills in `values` with the TF_Tensor values of the attribute `attr_name` of
// `oper`. `values` must point to an array of TF_Tensor* of length at least
// `max_values` (ideally set to TF_AttrMetadata.list_size from
// TF_OperationGetAttrMetadata(oper, attr_name)).
//
// The caller takes ownership of all the non-null TF_Tensor* entries in `values`
// (which can be deleted using TF_DeleteTensor(values[i])).
// TF_CAPI_EXPORT extern void TF_OperationGetAttrTensorList(TF_Operation* oper,
// const char* attr_name,
// TF_Tensor** values,
// int max_values,
// TF_Status* status);
procedure TF_OperationGetAttrTensorList(oper: pTF_Operation; const attr_name: pTFChar; values: ppTF_Tensor; max_values: Integer;
  status: pTF_Status); cdecl;

// Sets `output_attr_value` to the binary-serialized AttrValue proto
// representation of the value of the `attr_name` attr of `oper`.
// TF_CAPI_EXPORT extern void TF_OperationGetAttrValueProto(
// TF_Operation* oper, const char* attr_name, TF_Buffer* output_attr_value,
// TF_Status* status);
procedure TF_OperationGetAttrValueProto(oper: pTF_Operation; const attr_name: pTFChar; output_attr_value: pTF_Buffer;
  status: pTF_Status); cdecl;

// Returns the operation in the graph with `oper_name`. Returns nullptr if
// no operation found.
// TF_CAPI_EXPORT extern TF_Operation* TF_GraphOperationByName(
// TF_Graph* graph, const char* oper_name);
function TF_GraphOperationByName(Graph: pTF_Graph; const oper_name: pTFChar): pTF_Operation; cdecl;

// Iterate through the operations of a graph.  To use:
// size_t pos = 0;
// TF_Operation* oper;
// while ((oper = TF_GraphNextOperation(graph, &pos)) != nullptr) {
// DoSomethingWithOperation(oper);
// }
// TF_CAPI_EXPORT extern TF_Operation* TF_GraphNextOperation(TF_Graph* graph,
// size_t* pos);
function TF_GraphNextOperation(Graph: pTF_Graph; pos: psize_t): pTF_Operation; cdecl;

// Write out a serialized representation of `graph` (as a GraphDef protocol
// message) to `output_graph_def` (allocated by TF_NewBuffer()).
// `output_graph_def`'s underlying buffer will be freed when TF_DeleteBuffer()
// is called.
//
// May fail on very large graphs in the future.
// TF_CAPI_EXPORT extern void TF_GraphToGraphDef(TF_Graph* graph,
// TF_Buffer* output_graph_def,
// TF_Status* status);
procedure TF_GraphToGraphDef(Graph: pTF_Graph; output_graph_def: pTF_Buffer; status: pTF_Status); cdecl;

type
  // TF_ImportGraphDefOptions holds options that can be passed to
  // TF_GraphImportGraphDef.
  // typedef struct TF_ImportGraphDefOptions TF_ImportGraphDefOptions;
  TF_ImportGraphDefOptions = record
  end;

  pTF_ImportGraphDefOptions = ^TF_ImportGraphDefOptions;

  // TF_CAPI_EXPORT extern TF_ImportGraphDefOptions* TF_NewImportGraphDefOptions();
function TF_NewImportGraphDefOptions(): pTF_ImportGraphDefOptions; cdecl;

// TF_CAPI_EXPORT extern void TF_DeleteImportGraphDefOptions(
// TF_ImportGraphDefOptions* opts);
procedure TF_DeleteImportGraphDefOptions(opts: pTF_ImportGraphDefOptions); cdecl;

// Set the prefix to be prepended to the names of nodes in `graph_def` that will
// be imported into `graph`.
// TF_CAPI_EXPORT extern void TF_ImportGraphDefOptionsSetPrefix(
// TF_ImportGraphDefOptions* opts, const char* prefix);
procedure TF_ImportGraphDefOptionsSetPrefix(opts: pTF_ImportGraphDefOptions; const prefix: pTFChar); cdecl;

// Set any imported nodes with input `src_name:src_index` to have that input
// replaced with `dst`. `src_name` refers to a node in the graph to be imported,
// `dst` references a node already existing in the graph being imported into.
// TF_CAPI_EXPORT extern void TF_ImportGraphDefOptionsAddInputMapping(
// TF_ImportGraphDefOptions* opts, const char* src_name, int src_index,
// TF_Output dst);
procedure TF_ImportGraphDefOptionsAddInputMapping(opts: pTF_ImportGraphDefOptions; const src_name: pTFChar; src_index: Integer;
  dst: TF_Output); cdecl;

// Set any imported nodes with control input `src_name` to have that input
// replaced with `dst`. `src_name` refers to a node in the graph to be imported,
// `dst` references an operation already existing in the graph being imported
// into.
// TF_CAPI_EXPORT extern void TF_ImportGraphDefOptionsRemapControlDependency(
// TF_ImportGraphDefOptions* opts, const char* src_name, TF_Operation* dst);
procedure TF_ImportGraphDefOptionsRemapControlDependency(opts: pTF_ImportGraphDefOptions; const src_name: pTFChar;
  dst: pTF_Operation); cdecl;

// Cause the imported graph to have a control dependency on `oper`. `oper`
// should exist in the graph being imported into.
// TF_CAPI_EXPORT extern void TF_ImportGraphDefOptionsAddControlDependency(
// TF_ImportGraphDefOptions* opts, TF_Operation* oper);
procedure TF_ImportGraphDefOptionsAddControlDependency(opts: pTF_ImportGraphDefOptions; oper: pTF_Operation); cdecl;

// Add an output in `graph_def` to be returned via the `return_outputs` output
// parameter of TF_GraphImportGraphDef(). If the output is remapped via an input
// mapping, the corresponding existing tensor in `graph` will be returned.
// TF_CAPI_EXPORT extern void TF_ImportGraphDefOptionsAddReturnOutput(
// TF_ImportGraphDefOptions* opts, const char* oper_name, int index);
procedure TF_ImportGraphDefOptionsAddReturnOutput(opts: pTF_ImportGraphDefOptions; const oper_name: pTFChar; index: Integer); cdecl;

// Returns the number of return outputs added via
// TF_ImportGraphDefOptionsAddReturnOutput().
// TF_CAPI_EXPORT extern int TF_ImportGraphDefOptionsNumReturnOutputs(
// const TF_ImportGraphDefOptions* opts);
function TF_ImportGraphDefOptionsNumReturnOutputs(const opts: pTF_ImportGraphDefOptions): Integer; cdecl;

// Import the graph serialized in `graph_def` into `graph`.
//
// `num_return_outputs` must be the number of return outputs added (i.e. the
// result of TF_ImportGraphDefOptionsNumReturnOutputs()).  If
// `num_return_outputs` is non-zero, `return_outputs` must be of length
// `num_return_outputs`. Otherwise it can be null.
// TF_CAPI_EXPORT extern void TF_GraphImportGraphDefWithReturnOutputs(
// TF_Graph* graph, const TF_Buffer* graph_def,
// const TF_ImportGraphDefOptions* options, TF_Output* return_outputs,
// int num_return_outputs, TF_Status* status);
procedure TF_GraphImportGraphDefWithReturnOutputs(Graph: pTF_Graph; const graph_def: pTF_Buffer; const options: pTF_ImportGraphDefOptions;
  return_outputs: pTF_Output; num_return_outputs: Integer; status: pTF_Status); cdecl;

// Import the graph serialized in `graph_def` into `graph`.
// Convenience function for when no return outputs have been added.
// TF_CAPI_EXPORT extern void TF_GraphImportGraphDef(
// TF_Graph* graph, const TF_Buffer* graph_def,
// const TF_ImportGraphDefOptions* options, TF_Status* status);
procedure TF_GraphImportGraphDef(Graph: pTF_Graph; const graph_def: pTF_Buffer; const options: pTF_ImportGraphDefOptions;
  status: pTF_Status); cdecl;

// Adds a copy of function `func` and optionally its gradient function `grad`
// to `g`. Once `func`/`grad` is added to `g`, it can be called by creating
// an operation using the function's name.
// Any changes to `func`/`grad` (including deleting it) done after this method
// returns, won't affect the copy of `func`/`grad` in `g`.
// If `func` or `grad` are already in `g`, TF_GraphCopyFunction has no
// effect on them, but can establish the function->gradient relationship
// between them if `func` does not already have a gradient. If `func` already
// has a gradient different from `grad`, an error is returned.
//
// `func` must not be null.
// If `grad` is null and `func` is not in `g`, `func` is added without a
// gradient.
// If `grad` is null and `func` is in `g`, TF_GraphCopyFunction is a noop.
// `grad` must have appropriate signature as described in the doc of
// GradientDef in tensorflow/core/framework/function.proto.
//
// If successful, status is set to OK and `func` and `grad` are added to `g`.
// Otherwise, status is set to the encountered error and `g` is unmodified.
// TF_CAPI_EXPORT extern void TF_GraphCopyFunction(TF_Graph* g,
// const TF_Function* func,
// const TF_Function* grad,
// TF_Status* status);
procedure TF_GraphCopyFunction(g: pTF_Graph; const func: pTF_Function; const grad: pTF_Function; status: pTF_Status); cdecl;

// Note: The following function may fail on very large protos in the future.

// TF_CAPI_EXPORT extern void TF_OperationToNodeDef(TF_Operation* oper,
// TF_Buffer* output_node_def,
// TF_Status* status);
procedure TF_OperationToNodeDef(oper: pTF_Operation; output_node_def: pTF_Buffer; status: pTF_Status); cdecl;

Type
  pTF_WhileParams = ^TF_WhileParams;

  TF_WhileParams = record // typedef struct TF_WhileParams {
    // The number of inputs to the while loop, i.e. the number of loop variables.
    // This is the size of cond_inputs, body_inputs, and body_outputs.
    ninputs: Integer; // const int ninputs;

    // The while condition graph. The inputs are the current values of the loop
    // variables. The output should be a scalar boolean.
    cond_graph: pTF_Graph; // TF_Graph* const cond_graph;
    cond_inputs: pTF_Output; // const TF_Output* const cond_inputs;
    cond_output: TF_Output; // TF_Output cond_output;

    // The loop body graph. The inputs are the current values of the loop
    // variables. The outputs are the updated values of the loop variables.
    body_graph: pTF_Graph; // TF_Graph* const body_graph;
    body_inputs: pTF_Output; // const TF_Output* const body_inputs;
    body_outputs: pTF_Output; // TF_Output* const body_outputs;

    // Unique null-terminated name for this while loop. This is used as a prefix
    // for created operations.
    name: pTFChar; // const char* name;
  end; // } TF_WhileParams;

  // Creates a TF_WhileParams for creating a while loop in `g`. `inputs` are
  // outputs that already exist in `g` used as initial values for the loop
  // variables.
  //
  // The returned TF_WhileParams will have all fields initialized except
  // `cond_output`, `body_outputs`, and `name`. The `body_outputs` buffer will be
  // allocated to size `ninputs`. The caller should build `cond_graph` and
  // `body_graph` starting from the inputs, and store the final outputs in
  // `cond_output` and `body_outputs`.
  //
  // If `status` is OK, the caller must call either TF_FinishWhile or
  // TF_AbortWhile on the returned TF_WhileParams. If `status` isn't OK, the
  // returned TF_WhileParams is not valid, and the caller should not call
  // TF_FinishWhile() or TF_AbortWhile().
  //
  // Missing functionality (TODO):
  // - Gradients
  // - Reference-type inputs
  // - Directly referencing external tensors from the cond/body graphs (this is
  // possible in the Python API)
  // TF_CAPI_EXPORT extern TF_WhileParams TF_NewWhile(TF_Graph* g, TF_Output* inputs,
  // int ninputs,
  // TF_Status* status);
function TF_NewWhile(g: pTF_Graph; inputs: pTF_Output; ninputs: Integer; status: pTF_Status): TF_WhileParams; cdecl;

// Builds the while loop specified by `params` and returns the output tensors of
// the while loop in `outputs`. `outputs` should be allocated to size
// `params.ninputs`.
//
// `params` is no longer valid once this returns.
//
// Either this or TF_AbortWhile() must be called after a successful
// TF_NewWhile() call.
// TF_CAPI_EXPORT extern void TF_FinishWhile(const TF_WhileParams* params,
// TF_Status* status,
// TF_Output* outputs);
procedure TF_FinishWhile(const params: pTF_WhileParams; status: pTF_Status; outputs: pTF_Output); cdecl;

// Frees `params`s resources without building a while loop. `params` is no
// longer valid after this returns. Either this or TF_FinishWhile() must be
// called after a successful TF_NewWhile() call.
// TF_CAPI_EXPORT extern void TF_AbortWhile(const TF_WhileParams* params);
procedure TF_AbortWhile(const params: pTF_WhileParams); cdecl;

// Adds operations to compute the partial derivatives of sum of `y`s w.r.t `x`s,
// i.e., d(y_1 + y_2 + ...)/dx_1, d(y_1 + y_2 + ...)/dx_2...
// `dx` are used as initial gradients (which represent the symbolic partial
// derivatives of some loss function `L` w.r.t. `y`).
// `dx` must be nullptr or have size `ny`.
// If `dx` is nullptr, the implementation will use dx of `OnesLike` for all
// shapes in `y`.
// The partial derivatives are returned in `dy`. `dy` should be allocated to
// size `nx`.
//
// WARNING: This function does not yet support all the gradients that python
// supports. See
// https://www.tensorflow.org/code/tensorflow/cc/gradients/README.md
// for instructions on how to add C++ more gradients.
// TF_CAPI_EXPORT void TF_AddGradients(TF_Graph* g, TF_Output* y, int ny,
// TF_Output* x, int nx, TF_Output* dx,
// TF_Status* status, TF_Output* dy);
procedure TF_AddGradients(g: pTF_Graph; y: pTF_Output; ny: Integer; x: pTF_Output; nx: Integer; dx: pTF_Output; status: pTF_Status;
  dy: pTF_Output); cdecl;

// Create a TF_Function from a TF_Graph
//
// Params:
// fn_body - the graph whose operations (or subset of whose operations) will be
// converted to TF_Function.
// fn_name - the name of the new TF_Function. Should match the operation
// name (OpDef.name) regexp [A-Z][A-Za-z0-9_.\\-/]* and be distinct
// from other operation names (at least those registered in graphs
// where this function will be used).
// TODO(iga): Allow null in here and have C API come up with
// a unique name with high probability (similarly to
// _create_hash_str in function.py)
// num_opers - `num_opers` contains the number of elements in the `opers` array
// or a special value of -1 meaning that no array is given.
// The distinction between an empty array of operations and no
// array of operations is necessary to distinguish the case of
// creating a function with no body (e.g. identity or permutation)
// and the case of creating a function whose body contains all
// the nodes in the graph (except for the automatic skipping, see
// below).
// opers - Array of operations to become the body of the function or null.
// - If no array is given (`num_opers`  = -1), all the
// operations in `fn_body` will become part of the function
// except operations referenced in `inputs`. These operations
// must have a single output (these operations are typically
// placeholders created for the sole purpose of representing
// an input. We can relax this constraint if there are
// compelling use cases).
// - If an array is given (`num_opers` >= 0), all operations
// in it will become part of the function. In particular, no
// automatic skipping of dummy input operations is performed.
// ninputs - number of elements in `inputs` array
// inputs - array of TF_Outputs that specify the inputs to the function.
// If `ninputs` is zero (the function takes no inputs), `inputs`
// can be null. The names used for function inputs are normalized
// names of the operations (usually placeholders) pointed to by
// `inputs`. These operation names should start with a letter.
// Normalization will convert all letters to lowercase and
// non-alphanumeric characters to '_' to make resulting names match
// the "[a-z][a-z0-9_]*" pattern for operation argument names.
// `inputs` cannot contain the same tensor twice.
// noutputs - number of elements in `outputs` array
// outputs - array of TF_Outputs that specify the outputs of the function.
// If `noutputs` is zero (the function returns no outputs), `outputs`
// can be null. `outputs` can contain the same tensor more than once.
// output_names - The names of the function's outputs. `output_names` array
// must either have the same length as `outputs`
// (i.e. `noutputs`) or be null. In the former case,
// the names should match the regular expression for ArgDef
// names - "[a-z][a-z0-9_]*". In the latter case,
// names for outputs will be generated automatically.
// opts - various options for the function, e.g. XLA's inlining control.
// description - optional human-readable description of this function.
// status - Set to OK on success and an appropriate error on failure.
//
// Note that when the same TF_Output is listed as both an input and an output,
// the corresponding function's output will equal to this input,
// instead of the original node's output.
//
// Callers must also satisfy the following constraints:
// - `inputs` cannot refer to TF_Outputs within a control flow context. For
// example, one cannot use the output of "switch" node as input.
// - `inputs` and `outputs` cannot have reference types. Reference types are
// not exposed through C API and are being replaced with Resources. We support
// reference types inside function's body to support legacy code. Do not
// use them in new code.
// - Every node in the function's body must have all of its inputs (including
// control inputs). In other words, for every node in the body, each input
// must be either listed in `inputs` or must come from another node in
// the body. In particular, it is an error to have a control edge going from
// a node outside of the body into a node in the body. This applies to control
// edges going from nodes referenced in `inputs` to nodes in the body when
// the former nodes are not in the body (automatically skipped or not
// included in explicitly specified body).
//
// Returns:
// On success, a newly created TF_Function instance. It must be deleted by
// calling TF_DeleteFunction.
//
// On failure, null.
// TF_CAPI_EXPORT extern TF_Function* TF_GraphToFunction(
// const TF_Graph* fn_body, const char* fn_name, int num_opers,
// const TF_Operation* const* opers, int ninputs, const TF_Output* inputs,
// int noutputs, const TF_Output* outputs, const char* const* output_names,
// const TF_FunctionOptions* opts, const char* description, TF_Status* status);
function TF_GraphToFunction(const fn_body: pTF_Graph; const fn_name: pTFChar; num_opers: Integer; const opers: ppTF_Operation;
  ninputs: Integer; const inputs: pTF_Output; noutputs: Integer; const outputs: pTF_Output; const output_names: ppTFChar;
  const opts: pTF_FunctionOptions; const description: pTFChar; status: pTF_Status): pTF_Function; cdecl;

// Write out a serialized representation of `func` (as a FunctionDef protocol
// message) to `output_func_def` (allocated by TF_NewBuffer()).
// `output_func_def`'s underlying buffer will be freed when TF_DeleteBuffer()
// is called.
//
// May fail on very large graphs in the future.
// TF_CAPI_EXPORT extern void TF_FunctionToFunctionDef(TF_Function* func,
// TF_Buffer* output_func_def,
// TF_Status* status);
procedure TF_FunctionToFunctionDef(func: pTF_Function; output_func_def: pTF_Buffer; status: pTF_Status); cdecl;

// Construct and return the function serialized in `func_def`.
// Returns:
// On success, a newly created TF_Function instance. It must be deleted by
// calling TF_DeleteFunction.
//
// On failure, null.
// TF_CAPI_EXPORT extern TF_Function* TF_FunctionImportFunctionDef(
// const TF_Buffer* func_def, TF_Status* status);
function TF_FunctionImportFunctionDef(const func_def: pTF_Buffer; status: pTF_Status): TF_Function; cdecl;

// Sets function attribute named `attr_name` to value stored in `proto`.
// If this attribute is already set to another value, it is overriden.
// `proto` should point to a sequence of bytes of length `proto_len`
// representing a binary serialization of an AttrValue protocol
// buffer.
// TF_CAPI_EXPORT extern void TF_FunctionSetAttrValueProto(TF_Function* func,
// const char* attr_name,
// const void* proto,
// size_t proto_len,
// TF_Status* status);
procedure TF_FunctionSetAttrValueProto(func: pTF_Function; const attr_name: pTFChar; const proto: Pointer; proto_len: size_t;
  status: pTF_Status); cdecl;

// Sets `output_attr_value` to the binary-serialized AttrValue proto
// representation of the value of the `attr_name` attr of `func`.
// If `attr_name` attribute is not present, status is set to an error.
// TF_CAPI_EXPORT extern void TF_FunctionGetAttrValueProto(
// TF_Function* func, const char* attr_name, TF_Buffer* output_attr_value,
// TF_Status* status);
procedure TF_FunctionGetAttrValueProto(func: pTF_Function; const attr_name: pTFChar; output_attr_value: pTF_Buffer;
  status: pTF_Status); cdecl;

// Frees the memory used by the `func` struct.
// TF_DeleteFunction is a noop if `func` is null.
// Deleting a function does not remove it from any graphs it was copied to.
// TF_CAPI_EXPORT extern void TF_DeleteFunction(TF_Function* func);
procedure TF_DeleteFunction(func: pTF_Function); cdecl;

// TODO(josh11b): Register OpDef, available to all operations added
// to this graph.

// The following two may both benefit from a subgraph-definition API
// that re-uses most of the graph-definition API.
// TODO(andydavis): Add functions to a graph.

// --------------------------------------------------------------------------
// API for driving Graph execution.
Type

  // typedef struct TF_Session TF_Session;
  pTF_Session = ^TF_Session;

  TF_Session = record
  end;

  // Return a new execution session with the associated graph, or NULL on error.
  //
  // *graph must be a valid graph (not deleted or nullptr).  This function will
  // prevent the graph from being deleted until TF_DeleteSession() is called.
  // Does not take ownership of opts.
  // TF_CAPI_EXPORT extern TF_Session* TF_NewSession(TF_Graph* graph,
  // const TF_SessionOptions* opts,
  // TF_Status* status);
function TF_NewSession(Graph: pTF_Graph; const opts: pTF_SessionOptions; status: pTF_Status): pTF_Session; cdecl;

// This function creates a new TF_Session (which is created on success) using
// `session_options`, and then initializes state (restoring tensors and other
// assets) using `run_options`.
//
// Any NULL and non-NULL value combinations for (`run_options, `meta_graph_def`)
// are valid.
//
// - `export_dir` must be set to the path of the exported SavedModel.
// - `tags` must include the set of tags used to identify one MetaGraphDef in
// the SavedModel.
// - `graph` must be a graph newly allocated with TF_NewGraph().
//
// If successful, populates `graph` with the contents of the Graph and
// `meta_graph_def` with the MetaGraphDef of the loaded model.
// TF_CAPI_EXPORT extern TF_Session* TF_LoadSessionFromSavedModel(
// const TF_SessionOptions* session_options, const TF_Buffer* run_options,
// const char* export_dir, const char* const* tags, int tags_len,
// TF_Graph* graph, TF_Buffer* meta_graph_def, TF_Status* status);
function TF_LoadSessionFromSavedModel(const session_options: pTF_SessionOptions; const run_options: pTF_Buffer; const export_dir: pTFChar;
  const tags: ppTFChar; tags_len: Integer; Graph: pTF_Graph; meta_graph_def: pTF_Buffer; status: pTF_Status): pTF_Session; cdecl;

// Close a session.
//
// Contacts any other processes associated with the session, if applicable.
// May not be called after TF_DeleteSession().
// TF_CAPI_EXPORT extern void TF_CloseSession(TF_Session*, TF_Status* status);
procedure TF_CloseSession(Session: pTF_Session; status: pTF_Status); cdecl;

// Destroy a session object.
//
// Even if error information is recorded in *status, this call discards all
// local resources associated with the session.  The session may not be used
// during or after this call (and the session drops its reference to the
// corresponding graph).
// TF_CAPI_EXPORT extern void TF_DeleteSession(TF_Session*, TF_Status* status);
procedure TF_DeleteSession(Session: pTF_Session; status: pTF_Status); cdecl;

// Run the graph associated with the session starting with the supplied inputs
// (inputs[0,ninputs-1] with corresponding values in input_values[0,ninputs-1]).
//
// Any NULL and non-NULL value combinations for (`run_options`,
// `run_metadata`) are valid.
//
// - `run_options` may be NULL, in which case it will be ignored; or
// non-NULL, in which case it must point to a `TF_Buffer` containing the
// serialized representation of a `RunOptions` protocol buffer.
// - `run_metadata` may be NULL, in which case it will be ignored; or
// non-NULL, in which case it must point to an empty, freshly allocated
// `TF_Buffer` that may be updated to contain the serialized representation
// of a `RunMetadata` protocol buffer.
//
// The caller retains ownership of `input_values` (which can be deleted using
// TF_DeleteTensor). The caller also retains ownership of `run_options` and/or
// `run_metadata` (when not NULL) and should manually call TF_DeleteBuffer on
// them.
//
// On success, the tensors corresponding to outputs[0,noutputs-1] are placed in
// output_values[]. Ownership of the elements of output_values[] is transferred
// to the caller, which must eventually call TF_DeleteTensor on them.
//
// On failure, output_values[] contains NULLs.
// TF_CAPI_EXPORT extern void TF_SessionRun(
// TF_Session* session,
// // RunOptions
// const TF_Buffer* run_options,
// // Input tensors
// const TF_Output* inputs, TF_Tensor* const* input_values, int ninputs,
// // Output tensors
// const TF_Output* outputs, TF_Tensor** output_values, int noutputs,
// // Target operations
// const TF_Operation* const* target_opers, int ntargets,
// // RunMetadata
// TF_Buffer* run_metadata,
// // Output status
// TF_Status*);

procedure TF_SessionRun(Session: pTF_Session;
  // RunOptions
  const run_options: pTF_Buffer;
  // Input tensors
  const inputs: pTF_Output; input_values: ppTF_Tensor; ninputs: Integer;
  // Output tensors
  const outputs: pTF_Output; output_values: ppTF_Tensor; noutputs: Integer;
  // Target operations
  const target_opers: ppTF_Operation; ntargets: Integer;
  // RunMetadata
  run_metadata: pTF_Buffer;
  // Output status
  status: pTF_Status); cdecl;

// Set up the graph with the intended feeds (inputs) and fetches (outputs) for a
// sequence of partial run calls.
//
// On success, returns a handle that is used for subsequent PRun calls. The
// handle should be deleted with TF_DeletePRunHandle when it is no longer
// needed.
//
// On failure, out_status contains a tensorflow::Status with an error
// message. *handle is set to nullptr.
// TF_CAPI_EXPORT extern void TF_SessionPRunSetup(
// TF_Session*,
// // Input names
// const TF_Output* inputs, int ninputs,
// // Output names
// const TF_Output* outputs, int noutputs,
// // Target operations
// const TF_Operation* const* target_opers, int ntargets,
// // Output handle
// const char** handle,
// // Output status
// TF_Status*);
procedure TF_SessionPRunSetup(Session: pTF_Session;
  // Input names
  const inputs: pTF_Output; ninputs: Integer;
  // Output names
  const outputs: pTF_Output; noutputs: Integer;
  // Target operations
  const target_opers: ppTF_Operation; ntargets: Integer;
  // Output handle
  const handle: ppTFChar;
  // Output status
  status: pTF_Status); cdecl;

// Continue to run the graph with additional feeds and fetches. The
// execution state is uniquely identified by the handle.
// TF_CAPI_EXPORT extern void TF_SessionPRun(
// TF_Session*, const char* handle,
// // Input tensors
// const TF_Output* inputs, TF_Tensor* const* input_values, int ninputs,
// // Output tensors
// const TF_Output* outputs, TF_Tensor** output_values, int noutputs,
// // Target operations
// const TF_Operation* const* target_opers, int ntargets,
// // Output status
// TF_Status*);
procedure TF_SessionPRun(Session: pTF_Session; const handle: pTFChar;
  // Input tensors
  const inputs: pTF_Output; input_values: ppTF_Tensor; ninputs: Integer;
  // Output tensors
  const outputs: pTF_Output; output_values: ppTF_Tensor; noutputs: Integer;
  // Target operations
  const target_opers: ppTF_Operation; ntargets: Integer;
  // Output status
  status: pTF_Status); cdecl;

// Deletes a handle allocated by TF_SessionPRunSetup.
// Once called, no more calls to TF_SessionPRun should be made.
// TF_CAPI_EXPORT extern void TF_DeletePRunHandle(const char* handle);
procedure TF_DeletePRunHandle(const handle: pTFChar); cdecl;

// --------------------------------------------------------------------------
// The deprecated session API.  Please switch to the above instead of
// TF_ExtendGraph(). This deprecated API can be removed at any time without
// notice.
Type
  // typedef struct TF_DeprecatedSession TF_DeprecatedSession;
  pTF_DeprecatedSession = ^TF_DeprecatedSession;

  TF_DeprecatedSession = record
  end;

  // TF_CAPI_EXPORT extern TF_DeprecatedSession* TF_NewDeprecatedSession(
  // const TF_SessionOptions*, TF_Status* status);
function TF_NewDeprecatedSession(const SessionOptions: pTF_SessionOptions; status: pTF_Status): pTF_DeprecatedSession; cdecl;

// TF_CAPI_EXPORT extern void TF_CloseDeprecatedSession(TF_DeprecatedSession*,
// TF_Status* status);
procedure TF_CloseDeprecatedSession(DeprecatedSession: pTF_DeprecatedSession; status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_DeleteDeprecatedSession(TF_DeprecatedSession*,
// TF_Status* status);
procedure TF_DeleteDeprecatedSession(DeprecatedSession: pTF_DeprecatedSession; status: pTF_Status); cdecl;

// TF_CAPI_EXPORT extern void TF_Reset(const TF_SessionOptions* opt,
// const char** containers, int ncontainers,
// TF_Status* status);
procedure TF_Reset(const opt: pTF_SessionOptions; const containers: ppTFChar; ncontainers: Integer; status: pTF_Status); cdecl;

// Treat the bytes proto[0,proto_len-1] as a serialized GraphDef and
// add the nodes in that GraphDef to the graph for the session.
//
// Prefer use of TF_Session and TF_GraphImportGraphDef over this.
// TF_CAPI_EXPORT extern void TF_ExtendGraph(TF_DeprecatedSession*,
// const void* proto, size_t proto_len,
// TF_Status*);
procedure TF_ExtendGraph(DeprecatedSession: pTF_DeprecatedSession; const proto: Pointer; proto_len: size_t; status: pTF_Status); cdecl;

// See TF_SessionRun() above.
// TF_CAPI_EXPORT extern void TF_Run(TF_DeprecatedSession*,
// const TF_Buffer* run_options,
// const char** input_names, TF_Tensor** inputs,
// int ninputs, const char** output_names,
// TF_Tensor** outputs, int noutputs,
// const char** target_oper_names, int ntargets,
// TF_Buffer* run_metadata, TF_Status*);
procedure TF_Run(DeprecatedSession: pTF_DeprecatedSession; const run_options: pTF_Buffer; const input_names: ppTFChar; inputs: ppTF_Tensor;
  ninputs: Integer; const output_names: ppTFChar; outputs: ppTF_Tensor; noutputs: Integer; const target_oper_names: ppTFChar;
  ntargets: Integer; run_metadata: pTF_Buffer; status: pTF_Status); cdecl;

// See TF_SessionPRunSetup() above.
// TF_CAPI_EXPORT extern void TF_PRunSetup(TF_DeprecatedSession*,
// const char** input_names, int ninputs,
// const char** output_names, int noutputs,
// const char** target_oper_names,
// int ntargets, const char** handle,
// TF_Status*);
procedure TF_PRunSetup(DeprecatedSession: pTF_DeprecatedSession; const input_names: ppTFChar; ninputs: Integer;
  const output_names: ppTFChar; noutputs: Integer; const target_oper_names: ppTFChar; ntargets: Integer; const handle: ppTFChar;
  status: pTF_Status); cdecl;

// See TF_SessionPRun above.
// TF_CAPI_EXPORT extern void TF_PRun(TF_DeprecatedSession*, const char* handle,
// const char** input_names, TF_Tensor** inputs,
// int ninputs, const char** output_names,
// TF_Tensor** outputs, int noutputs,
// const char** target_oper_names, int ntargets,
// TF_Status*);
procedure TF_PRun(DeprecatedSession: pTF_DeprecatedSession; const handle: pTFChar; const input_names: ppTFChar; inputs: ppTF_Tensor;
  ninputs: Integer; const output_names: ppTFChar; outputs: ppTF_Tensor; noutputs: Integer; const target_oper_names: ppTFChar;
  ntargets: Integer; status: pTF_Status); cdecl;

Type
  // typedef struct TF_DeviceList TF_DeviceList;
  pTF_DeviceList = ^TF_DeviceList;

  TF_DeviceList = record
  end;

  // Lists all devices in a TF_Session.
  //
  // Caller takes ownership of the returned TF_DeviceList* which must eventually
  // be freed with a call to TF_DeleteDeviceList.
  // TF_CAPI_EXPORT extern TF_DeviceList* TF_SessionListDevices(TF_Session* session,
  // TF_Status* status);
function TF_SessionListDevices(Session: pTF_Session; status: pTF_Status): pTF_DeviceList; cdecl;

// Lists all devices in a TF_Session.
//
// Caller takes ownership of the returned TF_DeviceList* which must eventually
// be freed with a call to TF_DeleteDeviceList.
// TF_CAPI_EXPORT extern TF_DeviceList* TF_DeprecatedSessionListDevices(
// TF_DeprecatedSession* session, TF_Status* status);
function TF_DeprecatedSessionListDevices(Session: pTF_DeprecatedSession; status: pTF_Status): pTF_DeviceList; cdecl;

// Deallocates the device list.
// TF_CAPI_EXPORT extern void TF_DeleteDeviceList(TF_DeviceList* list);
procedure TF_DeleteDeviceList(list: pTF_DeviceList); cdecl;

// Counts the number of elements in the device list.
// TF_CAPI_EXPORT extern int TF_DeviceListCount(const TF_DeviceList* list);
function TF_DeviceListCount(const list: pTF_DeviceList): Integer; cdecl;

// Retrieves the full name of the device (e.g. /job:worker/replica:0/...)
// The return value will be a pointer to a null terminated string. The caller
// must not modify or delete the string. It will be deallocated upon a call to
// TF_DeleteDeviceList.
//
// If index is out of bounds, an error code will be set in the status object,
// and a null pointer will be returned.
// TF_CAPI_EXPORT extern const char* TF_DeviceListName(const TF_DeviceList* list,
// int index, TF_Status*);
function TF_DeviceListName(const list: pTF_DeviceList; index: Integer; status: pTF_Status): pTFChar; cdecl;

// Retrieves the type of the device at the given index.
//
// The caller must not modify or delete the string. It will be deallocated upon
// a call to TF_DeleteDeviceList.
//
// If index is out of bounds, an error code will be set in the status object,
// and a null pointer will be returned.
// TF_CAPI_EXPORT extern const char* TF_DeviceListType(const TF_DeviceList* list,
// int index, TF_Status*);
function TF_DeviceListType(const list: pTF_DeviceList; index: Integer; status: pTF_Status): pTFChar; cdecl;

// Retrieve the amount of memory associated with a given device.
//
// If index is out of bounds, an error code will be set in the status object,
// and -1 will be returned.
// TF_CAPI_EXPORT extern int64_t TF_DeviceListMemoryBytes(
// const TF_DeviceList* list, int index, TF_Status*);
function TF_DeviceListMemoryBytes(const list: pTF_DeviceList; index: Integer; status: pTF_Status): int64_t; cdecl;

// --------------------------------------------------------------------------
// Load plugins containing custom ops and kernels

Type
  // TF_Library holds information about dynamically loaded TensorFlow plugins.
  // typedef struct TF_Library TF_Library;
  pTF_Library = ^TF_Library;

  TF_Library = record
  end;

  // Load the library specified by library_filename and register the ops and
  // kernels present in that library.
  //
  // Pass "library_filename" to a platform-specific mechanism for dynamically
  // loading a library. The rules for determining the exact location of the
  // library are platform-specific and are not documented here.
  //
  // On success, place OK in status and return the newly created library handle.
  // The caller owns the library handle.
  //
  // On failure, place an error status in status and return NULL.
  // TF_CAPI_EXPORT extern TF_Library* TF_LoadLibrary(const char* library_filename,
  // TF_Status* status);
function TF_LoadLibrary(const library_filename: pTFChar; status: pTF_Status): pTF_Library; cdecl;

// Get the OpList of OpDefs defined in the library pointed by lib_handle.
//
// Returns a TF_Buffer. The memory pointed to by the result is owned by
// lib_handle. The data in the buffer will be the serialized OpList proto for
// ops defined in the library.
// TF_CAPI_EXPORT extern TF_Buffer TF_GetOpList(TF_Library* lib_handle);
function TF_GetOpList(lib_handle: pTF_Library): TF_Buffer; cdecl;

// Frees the memory associated with the library handle.
// Does NOT unload the library.
// TF_CAPI_EXPORT extern void TF_DeleteLibraryHandle(TF_Library* lib_handle);
procedure TF_DeleteLibraryHandle(lib_handle: pTF_Library); cdecl;

// Get the OpList of all OpDefs defined in this address space.
// Returns a TF_Buffer, ownership of which is transferred to the caller
// (and can be freed using TF_DeleteBuffer).
//
// The data in the buffer will be the serialized OpList proto for ops registered
// in this address space.
// TF_CAPI_EXPORT extern TF_Buffer* TF_GetAllOpList();
function TF_GetAllOpList(): pTF_Buffer; cdecl;

implementation

function TF_Version; external tensorflow_dll;
function TF_DataTypeSize; external tensorflow_dll;
function TF_NewStatus; external tensorflow_dll;
procedure TF_DeleteStatus; external tensorflow_dll;
procedure TF_SetStatus; external tensorflow_dll;
function TF_GetCode; external tensorflow_dll;
function TF_Message; external tensorflow_dll;
function TF_NewBufferFromString; external tensorflow_dll;
function TF_NewBuffer; external tensorflow_dll;
procedure TF_DeleteBuffer; external tensorflow_dll;
function TF_GetBuffer; external tensorflow_dll;
function TF_NewTensor; external tensorflow_dll;
function TF_AllocateTensor; external tensorflow_dll;
function TF_TensorMaybeMove; external tensorflow_dll;
procedure TF_DeleteTensor; external tensorflow_dll;
function TF_TensorType; external tensorflow_dll;
function TF_NumDims; external tensorflow_dll;
function TF_Dim; external tensorflow_dll;
function TF_TensorByteSize; external tensorflow_dll;
function TF_TensorData; external tensorflow_dll;
function TF_StringEncode; external tensorflow_dll;
function TF_StringDecode; external tensorflow_dll;
function TF_StringEncodedSize; external tensorflow_dll;
function TF_NewSessionOptions; external tensorflow_dll;
procedure TF_SetTarget; external tensorflow_dll;
procedure TF_SetConfig; external tensorflow_dll;
procedure TF_DeleteSessionOptions; external tensorflow_dll;
function TF_NewGraph; external tensorflow_dll;
procedure TF_DeleteGraph; external tensorflow_dll;
procedure TF_GraphSetTensorShape; external tensorflow_dll;
function TF_GraphGetTensorNumDims; external tensorflow_dll;
procedure TF_GraphGetTensorShape; external tensorflow_dll;
function TF_NewOperation; external tensorflow_dll;
procedure TF_SetDevice; external tensorflow_dll;
procedure TF_AddInput; external tensorflow_dll;
procedure TF_AddInputList; external tensorflow_dll;
procedure TF_AddControlInput; external tensorflow_dll;
procedure TF_ColocateWith; external tensorflow_dll;
procedure TF_SetAttrString; external tensorflow_dll;
procedure TF_SetAttrStringList; external tensorflow_dll;
procedure TF_SetAttrInt; external tensorflow_dll;
procedure TF_SetAttrIntList; external tensorflow_dll;
procedure TF_SetAttrFloat; external tensorflow_dll;
procedure TF_SetAttrFloatList; external tensorflow_dll;
procedure TF_SetAttrBool; external tensorflow_dll;
procedure TF_SetAttrBoolList; external tensorflow_dll;
procedure TF_SetAttrType; external tensorflow_dll;
procedure TF_SetAttrTypeList; external tensorflow_dll;
procedure TF_SetAttrShape; external tensorflow_dll;
procedure TF_SetAttrShapeList; external tensorflow_dll;
procedure TF_SetAttrTensorShapeProto; external tensorflow_dll;
procedure TF_SetAttrTensorShapeProtoList; external tensorflow_dll;
procedure TF_SetAttrTensor; external tensorflow_dll;
procedure TF_SetAttrTensorList; external tensorflow_dll;
procedure TF_SetAttrValueProto; external tensorflow_dll;
function TF_FinishOperation; external tensorflow_dll;
function TF_OperationName; external tensorflow_dll;
function TF_OperationOpType; external tensorflow_dll;
function TF_OperationDevice; external tensorflow_dll;
function TF_OperationNumOutputs; external tensorflow_dll;
function TF_OperationOutputType; external tensorflow_dll;
function TF_OperationOutputListLength; external tensorflow_dll;
function TF_OperationNumInputs; external tensorflow_dll;
function TF_OperationInputType; external tensorflow_dll;
function TF_OperationInputListLength; external tensorflow_dll;
function TF_OperationInput; external tensorflow_dll;
function TF_OperationOutputNumConsumers; external tensorflow_dll;
function TF_OperationOutputConsumers; external tensorflow_dll;
function TF_OperationNumControlInputs; external tensorflow_dll;
function TF_OperationGetControlInputs; external tensorflow_dll;
function TF_OperationNumControlOutputs; external tensorflow_dll;
function TF_OperationGetControlOutputs; external tensorflow_dll;
function TF_OperationGetAttrMetadata; external tensorflow_dll;
procedure TF_OperationGetAttrString; external tensorflow_dll;
procedure TF_OperationGetAttrStringList; external tensorflow_dll;
procedure TF_OperationGetAttrInt; external tensorflow_dll;
procedure TF_OperationGetAttrIntList; external tensorflow_dll;
procedure TF_OperationGetAttrFloat; external tensorflow_dll;
procedure TF_OperationGetAttrFloatList; external tensorflow_dll;
procedure TF_OperationGetAttrBool; external tensorflow_dll;
procedure TF_OperationGetAttrBoolList; external tensorflow_dll;
procedure TF_OperationGetAttrType; external tensorflow_dll;
procedure TF_OperationGetAttrTypeList; external tensorflow_dll;
procedure TF_OperationGetAttrShape; external tensorflow_dll;
procedure TF_OperationGetAttrShapeList; external tensorflow_dll;

procedure TF_OperationGetAttrTensorShapeProto; external tensorflow_dll;
procedure TF_OperationGetAttrTensorShapeProtoList; external tensorflow_dll;
procedure TF_OperationGetAttrTensor; external tensorflow_dll;
procedure TF_OperationGetAttrTensorList; external tensorflow_dll;
procedure TF_OperationGetAttrValueProto; external tensorflow_dll;
function TF_GraphOperationByName; external tensorflow_dll;
function TF_GraphNextOperation; external tensorflow_dll;
procedure TF_GraphToGraphDef; external tensorflow_dll;
function TF_NewImportGraphDefOptions; external tensorflow_dll;
procedure TF_DeleteImportGraphDefOptions; external tensorflow_dll;
procedure TF_ImportGraphDefOptionsSetPrefix; external tensorflow_dll;
procedure TF_ImportGraphDefOptionsAddInputMapping; external tensorflow_dll;
procedure TF_ImportGraphDefOptionsRemapControlDependency; external tensorflow_dll;
procedure TF_ImportGraphDefOptionsAddControlDependency; external tensorflow_dll;
procedure TF_ImportGraphDefOptionsAddReturnOutput; external tensorflow_dll;
function TF_ImportGraphDefOptionsNumReturnOutputs; external tensorflow_dll;
procedure TF_GraphImportGraphDefWithReturnOutputs; external tensorflow_dll;
procedure TF_GraphImportGraphDef; external tensorflow_dll;
procedure TF_GraphCopyFunction; external tensorflow_dll;
procedure TF_OperationToNodeDef; external tensorflow_dll;
function TF_NewWhile; external tensorflow_dll;
procedure TF_FinishWhile; external tensorflow_dll;
procedure TF_AbortWhile; external tensorflow_dll;
procedure TF_AddGradients; external tensorflow_dll;
function TF_GraphToFunction; external tensorflow_dll;
procedure TF_FunctionToFunctionDef; external tensorflow_dll;
function TF_FunctionImportFunctionDef; external tensorflow_dll;
procedure TF_FunctionSetAttrValueProto; external tensorflow_dll;
procedure TF_FunctionGetAttrValueProto; external tensorflow_dll;
procedure TF_DeleteFunction; external tensorflow_dll;
function TF_NewSession; external tensorflow_dll;
function TF_LoadSessionFromSavedModel; external tensorflow_dll;
procedure TF_CloseSession; external tensorflow_dll;
procedure TF_DeleteSession; external tensorflow_dll;
procedure TF_SessionRun; external tensorflow_dll;
procedure TF_SessionPRunSetup; external tensorflow_dll;
procedure TF_SessionPRun; external tensorflow_dll;
procedure TF_DeletePRunHandle; external tensorflow_dll;
function TF_NewDeprecatedSession; external tensorflow_dll;
procedure TF_CloseDeprecatedSession; external tensorflow_dll;
procedure TF_DeleteDeprecatedSession; external tensorflow_dll;
procedure TF_Reset; external tensorflow_dll;
procedure TF_ExtendGraph; external tensorflow_dll;
procedure TF_Run; external tensorflow_dll;
procedure TF_PRunSetup; external tensorflow_dll;
procedure TF_PRun; external tensorflow_dll;
function TF_SessionListDevices; external tensorflow_dll;
function TF_DeprecatedSessionListDevices; external tensorflow_dll;
procedure TF_DeleteDeviceList; external tensorflow_dll;
function TF_DeviceListCount; external tensorflow_dll;
function TF_DeviceListName; external tensorflow_dll;
function TF_DeviceListType; external tensorflow_dll;
function TF_DeviceListMemoryBytes; external tensorflow_dll;
function TF_LoadLibrary; external tensorflow_dll;
function TF_GetOpList; external tensorflow_dll;
procedure TF_DeleteLibraryHandle; external tensorflow_dll;
function TF_GetAllOpList; external tensorflow_dll;

end.
