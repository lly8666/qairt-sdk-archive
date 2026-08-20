#pragma once
#include <vector>

namespace meanvc2lab {
constexpr int kVocosNfft = 640;
constexpr int kVocosBins = 321;
constexpr int kVocosHop = 160;
constexpr int kVocosCenterPad = 320;

std::vector<float> VocosIstft(const float* real, const float* imag, int frames);
}

extern "C" int meanvc2_vocos_istft_c(const float* real, const float* imag, int frames,
                                      float* output, int output_capacity);
