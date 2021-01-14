# Run in Colab
Open file 'Week02/target_mean_cython.ipynb' in colab and run. 

# Run locally
## Step 1
Compile .pyx file, CLI:

    cd Week02
    python3 setup.py build_ext --inplace

If it returns(usually in MacOS):

    fatal error: 'numpy/arrayobject.h' file not found

Add your numpy core path to the CFLAGS, more info:
https://github.com/hmmlearn/hmmlearn/issues/43

## Step 2
Open 'demo.ipynb' and run.

