Compile .pyx file, CLI:

    python3 ./Week02/setup.py build_ext --inplace

If it returns

    fatal error: 'numpy/arrayobject.h' file not found

Add your numpy core path to the CFLAGS, more info:
https://github.com/hmmlearn/hmmlearn/issues/43
