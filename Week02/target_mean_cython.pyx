import numpy as np
import pandas as pd
cimport numpy as cnp


def target_mean_v1(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    for i in range(data.shape[0]):
        a = data[data.index != i].groupby([x_name], as_index=False)
        groupby_result = data[data.index != i].groupby([x_name], as_index=False).agg(['mean', 'count'])
        result[i] = groupby_result.loc[groupby_result.index == data.loc[i, x_name], (y_name, 'mean')]
    return result


def target_mean_v2(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    value_dict = dict()
    count_dict = dict()
    for i in range(data.shape[0]):
        if data.loc[i, x_name] not in value_dict.keys():
            value_dict[data.loc[i, x_name]] = data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] = 1
        else:
            value_dict[data.loc[i, x_name]] += data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] += 1
    for i in range(data.shape[0]):
        result[i] = (value_dict[data.loc[i, x_name]] - data.loc[i, y_name]) / (count_dict[data.loc[i, x_name]] - 1)
    return result





cpdef target_mean_cython(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    cdef:
        dict value_dict = {}
        dict count_dict = {}
        int i
        int l = data.shape[0]
        int x
        int y
        a_x = cnp.ndarray(shape = (l), buffer = np.array(data.loc[:, x_name]),\
                          dtype=np.int)
        a_y = cnp.ndarray(shape = (l), buffer = np.array(data.loc[:, y_name]),\
                          dtype=np.int)

    for i in range(l):
        x = a_x[i]
        y = a_y[i]
        if x not in value_dict.keys():
            value_dict[x] = y
            count_dict[x] = 1
        else:
            value_dict[x] += y
            count_dict[x] += 1
    for i in range(l):
        x = a_x[i]
        y = a_y[i]
        result[i] = (value_dict[x] - y) / (count_dict[x] - 1)
    return result


if __name__ == "__main__":
    y = np.random.randint(2, size=(5000, 1))
    x = np.random.randint(10, size=(5000, 1))
    data = pd.DataFrame(np.concatenate([y, x], axis=1), columns=['y', 'x'])
    
    
    result_2 = target_mean_v2(data, 'y', 'x')
    result_c = target_mean_cython(data, 'y', 'x')
    diff = np.linalg.norm(result_c - result_2)
    print(diff)