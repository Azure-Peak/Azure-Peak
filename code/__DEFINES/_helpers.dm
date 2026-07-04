/// Takes a datum as input, returns its ref string
#define text_ref(datum) ref(datum)

#define ICON_SIZE_ALL 32
/// The X/Width dimension of ICON_SIZE. This will more than likely be the bigger axis.
#define ICON_SIZE_X 32
/// The Y/Height dimension of ICON_SIZE. This will more than likely be the smaller axis.
#define ICON_SIZE_Y 32
/// Type is abstract and should be skipped in type iterations, etc.
#define IS_ABSTRACT(datum_type) (initial(datum_type.abstract_type) == datum_type)
