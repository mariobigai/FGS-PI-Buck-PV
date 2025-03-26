/*
 * fuzzy_init.c
 *
 *  Created on: 19 de dez de 2024
 *      Author: mario
 */

/*
 * fuzzy_init.c
 *
 *  Created on: 19 de dez de 2024
 *      Author: mario
 */

#include "fuzzy_init.h"

//Fuzzy
float kp_fuzzy[21][21] = {{-0.999998, -0.999998, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000},
                          {-0.999986, -0.999989, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000},
                          {-0.999917, -0.999938, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000},
                          {-0.999555, -0.999667, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000},
                          {-0.997843, -0.998381, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000},
                          {-0.990541, -0.992890, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000},
                          {-0.954819, -0.954819, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000, -1.000000},
                          {-0.481254, -0.135492, -0.135492, -0.135492, -0.135492, -0.818903, -0.999871, -0.999946, -0.999946, -0.999946, -0.999946, -0.999946, -0.999946, -0.999946, -0.999885, -0.999666, -0.999666, -0.999666, -0.999666, -0.293680, -0.120502},
                          {0.134782, 0.008054, 0.141068, 0.129760, -0.003020, -0.622912, -0.789276, -0.789373, -0.789373, -0.789373, -0.789373, -0.789373, -0.789373, -0.789373, -0.789295, -0.649419, -0.296174, -0.296174, -0.296174, -0.164975, -0.146455},
                          {0.021517, -0.003354, 0.000000, 0.000000, -0.010254, -0.018350, -0.018798, -0.018798, -0.018798, -0.018798, -0.018798, -0.018798, -0.018798, -0.018798, -0.018798, -0.018435, 0.000000, 0.029755, 0.029755, 0.002068, -0.014624},
                          {0.135042, 0.000000, -0.014972, -0.003172, -0.001023, -0.002736, -0.002466, -0.002287, -0.002164, -0.002092, -0.002069, -0.002092, -0.002164, -0.002287, -0.002466, -0.002681, 0.000000, 0.119287, 0.134063, 0.001988, -0.005987},
                          {0.021517, 0.000000, 0.000000, 0.000000, 0.000000, -0.002777, -0.002810, -0.002810, -0.002810, -0.002810, -0.002810, -0.002810, -0.002810, -0.002810, -0.002810, -0.002623, 0.000000, 0.029755, 0.029755, 0.002068, -0.014624},
                          {-0.031331, -0.564523, -0.933960, -0.946669, -0.955781, -0.979088, -0.984409, -0.985956, -0.986967, -0.987539, -0.987559, -0.987539, -0.986967, -0.985956, -0.984403, -0.964697, -0.842536, -0.814565, -0.777683, -0.564523, 0.007753},
                          {0.009320, -0.018441, -0.998628, -0.998628, -0.998628, -0.998628, -0.999045, -0.999202, -0.999202, -0.999202, -0.999202, -0.999202, -0.999202, -0.999202, -0.998302, -0.995070, -0.995070, -0.995070, -0.995070, -0.018441, -0.120502},
                          {0.009995, 0.009621, -0.999969, -0.999997, -0.999997, -0.999997, -0.999997, -0.999997, -0.999998, -0.999998, -0.999998, -0.999998, -0.999998, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999969, -0.999973, -1.000000},
                          {0.009999, 0.009905, -0.999875, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -0.999994, -1.000000, -1.000000},
                          {0.010000, 0.009979, -0.999451, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -0.999973, -1.000000, -1.000000},
                          {0.010000, 0.009996, -0.997348, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -0.999872, -1.000000, -1.000000},
                          {0.010000, 0.009999, -0.986343, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -0.999331, -1.000000, -1.000000},
                          {0.010000, 0.010000, -0.934289, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -0.996615, -1.000000, -1.000000},
                          {0.010000, 0.010000, -0.784967, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -0.990000, -1.000000, -1.000000}};

float ki_fuzzy[21][21] = {{0.843887, 0.973114, 0.972465, 0.972116, 0.971975, 0.972250, 0.972738, 0.973119, 0.973150, 0.973150, 0.973150, 0.973150, 0.973150, 0.973119, 0.972732, 0.960131, 0.272334, -0.000000, -0.000000, 0.055604, 0.891932},
                          {0.849229, 0.973114, 0.972465, 0.972116, 0.971975, 0.972250, 0.972738, 0.973119, 0.973150, 0.973150, 0.973150, 0.973150, 0.973150, 0.973119, 0.972732, 0.960131, 0.272334, -0.000000, -0.000000, 0.055604, 0.889089},
                          {0.864140, 0.973114, 0.972473, 0.972116, 0.971975, 0.972250, 0.972738, 0.972920, 0.972920, 0.972920, 0.972920, 0.972920, 0.972920, 0.972920, 0.972731, 0.960131, 0.272334, -0.000000, 0.000000, 0.055604, 0.880167},
                          {0.885538, 0.973114, 0.972536, 0.972116, 0.971975, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972055, 0.959656, 0.272334, -0.000000, 0.000000, 0.055604, 0.864068},
                          {0.909196, 0.973114, 0.972602, 0.972206, 0.972383, 0.972404, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972394, 0.956281, 0.233255, 0.005695, 0.000646, 0.055604, 0.850133},
                          {0.931024, 0.973114, 0.973181, 0.973181, 0.973365, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973381, 0.950731, 0.169929, 0.005526, 0.005526, 0.055604, 0.850113},
                          {0.945046, 0.974433, 0.974705, 0.974705, 0.974899, 0.974945, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974923, 0.942115, 0.114025, 0.005381, 0.005381, 0.029653, 0.834108},
                          {0.746682, 0.343411, 0.343411, 0.343411, 0.343411, 0.916385, 0.973023, 0.973023, 0.973023, 0.973023, 0.973023, 0.973023, 0.973023, 0.973023, 0.973023, 0.909247, 0.060389, 0.007955, 0.007955, 0.007955, 0.765878},
                          {0.854055, 0.056189, -0.011329, -0.003298, 0.272954, 0.956205, 0.960467, 0.962188, 0.963344, 0.964045, 0.964070, 0.964045, 0.963344, 0.962188, 0.960467, 0.955984, 0.303808, 0.304800, 0.321707, 0.173995, 0.854185},
                          {0.020177, 0.018952, 0.018952, 0.018952, 0.018952, 0.021432, 0.021684, 0.021684, 0.021684, 0.021684, 0.021684, 0.021684, 0.021684, 0.021684, 0.021684, 0.021389, -0.007361, -0.087358, -0.087358, -0.045956, 0.000000},
                          {0.007832, 0.006147, 0.004961, 0.004117, 0.003512, 0.003079, 0.002771, 0.002557, 0.002414, 0.002335, 0.002309, 0.002335, 0.002414, 0.002557, 0.002771, 0.002986, -0.008832, -0.133718, -0.188710, -0.045261, 0.003119},
                          {0.019991, 0.018630, 0.018630, 0.018630, 0.018630, 0.021412, 0.021708, 0.021708, 0.021708, 0.021708, 0.021708, 0.021708, 0.021708, 0.021708, 0.021708, 0.021412, -0.007126, -0.084784, -0.084784, -0.044540, 0.000000},
                          {0.091822, 0.050177, 0.013748, 0.011600, 0.253523, 0.957142, 0.961301, 0.962906, 0.964071, 0.964776, 0.964802, 0.964776, 0.964071, 0.962906, 0.961301, 0.957142, 0.253523, -0.038367, -0.111788, 0.097606, 0.844930},
                          {0.723775, 0.313582, 0.313582, 0.313582, 0.313582, 0.909256, 0.972977, 0.972977, 0.972977, 0.972977, 0.972977, 0.972977, 0.972977, 0.972977, 0.972977, 0.909256, 0.039638, -0.000000, -0.000000, -0.000000, 0.723775},
                          {0.974931, 0.974931, 0.974945, 0.974945, 0.974945, 0.974945, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974946, 0.974923, 0.933687, 0.083109, 0.003191, 0.003191, 0.016568, 0.802322},
                          {0.974282, 0.973469, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973396, 0.973381, 0.944745, 0.129645, 0.005888, 0.005888, 0.036652, 0.821344},
                          {0.974285, 0.973471, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972405, 0.972394, 0.951971, 0.183929, 0.008971, 0.008971, 0.036652, 0.821344},
                          {0.974285, 0.973472, 0.972063, 0.971892, 0.971993, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972063, 0.972055, 0.956321, 0.218293, 0.011600, 0.011975, 0.036652, 0.821344},
                          {0.974285, 0.973472, 0.972920, 0.971892, 0.971993, 0.972251, 0.972738, 0.972920, 0.972920, 0.972920, 0.972920, 0.972920, 0.972920, 0.972920, 0.972731, 0.956871, 0.218293, 0.011600, 0.013589, 0.036652, 0.821344},
                          {0.974285, 0.973472, 0.973017, 0.971892, 0.971993, 0.972251, 0.972738, 0.973119, 0.973150, 0.973150, 0.973150, 0.973150, 0.973150, 0.973119, 0.972731, 0.956871, 0.218293, 0.011600, 0.013748, 0.036652, 0.821344},
                          {0.974285, 0.973472, 0.973017, 0.971892, 0.971993, 0.972251, 0.972738, 0.973119, 0.973150, 0.973150, 0.973150, 0.973150, 0.973150, 0.973119, 0.972731, 0.956871, 0.218293, 0.011600, 0.013748, 0.036652, 0.821344}};


float get_dkp(int x, int y){
    return kp_fuzzy[x][y];
}

float get_dki(int x, int y){
    return ki_fuzzy[x][y];
}


