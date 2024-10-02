# Some general helpers to support writing CDF callbacks in Python.

# TODO: Ideally this should somehow hook up with the host application's GUI
#       to pop up an error dialog with the formatted error message.
#
#       For example, in the competition, we could return an error property and
#       the glue code could pop up a dialog with the error message.
def cdfError(msgs, *args):
    print "*Error*", msgs % args

def cdfSnapToGrid(val, resolution):
    return round(val / resolution) * resolution

def cdfGetMaskGrid(lib):
    return lib.tech.getGridResolution() # this needs current DloGen!!

# cdfNumeric is like float, but the constructor takes a string with optional
# scaling-factor suffix (like in SKILL). Unlike SKILL, the suffix MUST be a
# single character only.

class cdfNumeric(float):

    scaling_factors = {
        'Y': 1e24,                      # Yotta
        'Z': 1e21,                      # Zetta
        'E': 1e18,                      # Exa
        'P': 1e15,                      # Peta
        'T': 1e12,                      # Tera
        'G': 1e09,                      # Giga
        'M': 1e06,                      # Mega
        'K': 1e03,                      # kilo
        'k': 1e03,                      # kilo
        '%': 1e-2,                      # percent
        'm': 1e-3,                      # milli
        'u': 1e-6,                      # micro
        'n': 1e-9,                      # nano
        'p': 1e-12,                     # pico
        'f': 1e-15,                     # femto
        'a': 1e-18,                     # atto
        'z': 1e-21,                     # zepto
        'y': 1e-24,                     # yocto
    }

    # We shall try to keep the original string form even without scaling factor.
    def __new__(cls, val):
        if isinstance(val, str):
            if val[-1] in cls.scaling_factors:
                n = float.__new__(cls, float(val[:-1]) *
                                  cls.scaling_factors[val[-1]])
            else:
                n = float.__new__(cls, val)
            n._strval = val             # preserve the original string form
            return n
        elif isinstance(val, cdfNumeric):
            return val                  # no need to create another object
        else:
            return float.__new__(cls, val)

    def normalize(self):
        # TODO: normalize the string repr to use proper scaling factor, e.g.
        #       0.12u => 120n
        return self

    def __repr__(self):
        try:
            return "cdfNumeric(%r)" % self._strval
        except:
            return float.__repr__(self)

    def __str__(self):
        try:
            return self._strval
        except AttributeError:
            return float.__str__(self)

# can't inherit from the built-in 'bool' type
class cdfBoolean(object):

    def __init__(self, val):
        if isinstance(val, str):
            v = val.lower()
            if v == 't' or v == 'true' or val == 'yes':
                self._nonzero = True
            elif v == 'nil' or v == 'false' or val == 'no':
                self._nonzero = False
            else:
                raise ValueError("unrecognized boolean literal: %s" % val)
            self._strval = val
        elif isinstance(val, cdfBoolean): # can't return val, this is not "new"
            self._nonzero = val._nonzero
            try:
                self._strval = val._strval
            except:
                pass
        else:
            self._nonzero = bool(val)

    # to make this entity usable in a bool context
    def __nonzero__(self):
        return self._nonzero

    def __str__(self):
        try:
            return self._strval
        except AttributeError:
            return str(self._nonzero)

# For emulating some SKILL functions.
"""
def cdfParseFloatString(s):
    try:
        return cdfNumeric(s)
    except:
        return None
"""

# Should be used by cdfParamArray only (could be made as its local class).
#
# Available attributes:
# - param.name: the (original) param name
# - param.input: the original input (in string form)
# - param.valid: True if the conversion or constraint checking is successful
# - param.value: converted param value (if it's valid)
# - param.result: convert param value back to proper result type (Numeric
#                 becomes string, all other types keep the value unchanged).
# - param.updated: true if the param value got updated

class cdfParam(object):

    _type_mapping = {
        'Numeric': cdfNumeric,
        'Boolean': cdfBoolean,
        'Float': float,
        'Integer': int,
        'String': str,
        'Cyclic': str,
        'Radio': str,
    }

    def __init__(self, name, input):
        self.name = name
        self.input = input
        self.updated = False
        self.type = "String"            # the default
        self.valid = True
        self._value = input

    # this is for validating numeric values only
    def validate(self):
        self.type = "Numeric"
        if self.input.startswith('*INVALID'):
            self.valid = False          # user didn't correct the error
            return
        input = self.input.replace(' ', '')
        try:
            self._value = cdfNumeric(input)
            if input != self.input:
                self.input = input      # show the updated result
                self.updated = True
            self.valid = True
        except ValueError, exn:
            cdfError("invalid input for '%s': %s", self.name, self.input)
            self.input = "*INVALID: %s" % exn # input new has the err msgs
            self.updated = True        # so it will show up in the GUI
            self.valid = False

    # this is mainly for converting Boolean/Float/Integer types for now
    def convert(self, type):
        self.type = type
        try:
            self._value = self._type_mapping[type](self.input)
            self.valid = True
        except ValueError, exn:
            cdfError("invalid input for '%s': %s", self.name, self.input)
            self.valid = False

    def _get_value(self):
        return self._value

    def _set_value(self, value):
        self._value = value
        self.updated = True

    value = property(_get_value, _set_value)

    # TODO: For cdfNumeric type, we should try to convert a float value to a
    #       string with suitable scaling factor!
    @property
    def result(self):                   # value in proper form
        if not self.valid:
            return self.input           # should contain the error message
        elif self.type == 'Numeric':
            if self.input[-1] in cdfNumeric.scaling_factors:
                c = self.input[-1]      # hack to return the result in same sf
                return str(self.value / cdfNumeric.scaling_factors[c]) + c
            else:
                return str(self.value)
        else:
            return self.value

# Simply a dictionary of individual parameters that can be accessed via
# attribute access syntax.
class cdfParams(object):

    # args is a list of (name, input) tuples
    def __init__(self, args):
        params = {}
        for name, input in args:
            params[name] = cdfParam(name, input)
        self._params = params

    def __getitem__(self, name):
        return self._params[name]

    # TODO: In order to support attr syntax, we cannot allow Python reserved
    #       words as param names, so some renaming must be done (e.g. if the
    #       name 'if' is used as a param name, we will add another name '_if'
    #       for it, so it can be accessed via "params._if").
    def __getattr__(self, name):
        return self._params[name]

    # iter over the wrapped params
    def __iter__(self):
        return self._params.itervalues()

    # "call" syntax is used as a filter to select params satisfying the
    # predicate (return the results as a list of params).
    def __call__(self, pred):
        return [param for param in self._params.itervalues() if pred(param)]
