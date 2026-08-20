#include "meanvc2_vocos_dsp.h"

#include <algorithm>
#include <cmath>
#include <stdexcept>
#include <vector>

namespace meanvc2lab {
namespace {
constexpr double kPi = 3.141592653589793238462643383279502884;

const std::vector<float>& HannWindow() {
    static const std::vector<float> w = [] {
        std::vector<float> x(kVocosNfft);
        for (int n = 0; n < kVocosNfft; ++n) {
            x[n] = static_cast<float>(0.5 - 0.5 * std::cos(2.0 * kPi * n / kVocosNfft));
        }
        return x;
    }();
    return w;
}

struct TrigTable {
    std::vector<float> cosv;
    std::vector<float> sinv;
    TrigTable() : cosv((kVocosBins - 2) * kVocosNfft), sinv((kVocosBins - 2) * kVocosNfft) {
        for (int k = 1; k < kVocosBins - 1; ++k) {
            for (int n = 0; n < kVocosNfft; ++n) {
                const double a = 2.0 * kPi * k * n / kVocosNfft;
                const size_t i = static_cast<size_t>(k - 1) * kVocosNfft + n;
                cosv[i] = static_cast<float>(std::cos(a));
                sinv[i] = static_cast<float>(std::sin(a));
            }
        }
    }
};

const TrigTable& Trig() {
    static const TrigTable t;
    return t;
}
}  // namespace

std::vector<float> VocosIstft(const float* real, const float* imag, int frames) {
    if (real == nullptr || imag == nullptr) throw std::invalid_argument("null spectrum");
    if (frames < 2 || frames > 64) throw std::invalid_argument("unexpected Vocos frame count");
    const int ola_len = kVocosNfft + (frames - 1) * kVocosHop;
    const int out_len = (frames - 1) * kVocosHop;
    std::vector<double> ola(ola_len, 0.0), envelope(ola_len, 0.0);
    const auto& win = HannWindow();
    const auto& trig = Trig();

    for (int t = 0; t < frames; ++t) {
        const int off = t * kVocosHop;
        for (int n = 0; n < kVocosNfft; ++n) {
            double acc = static_cast<double>(real[t]);
            acc += static_cast<double>(real[(kVocosBins - 1) * frames + t]) * ((n & 1) ? -1.0 : 1.0);
            for (int k = 1; k < kVocosBins - 1; ++k) {
                const size_t ti = static_cast<size_t>(k - 1) * kVocosNfft + n;
                const size_t si = static_cast<size_t>(k) * frames + t;
                acc += 2.0 * (static_cast<double>(real[si]) * trig.cosv[ti] -
                              static_cast<double>(imag[si]) * trig.sinv[ti]);
            }
            const double w = win[n];
            ola[off + n] += (acc / kVocosNfft) * w;
            envelope[off + n] += w * w;
        }
    }

    std::vector<float> out(out_len);
    for (int i = 0; i < out_len; ++i) {
        const int src = kVocosCenterPad + i;
        if (envelope[src] <= 1.0e-11) throw std::runtime_error("ISTFT window envelope underflow");
        out[i] = static_cast<float>(ola[src] / envelope[src]);
    }
    return out;
}
}  // namespace meanvc2lab

extern "C" int meanvc2_vocos_istft_c(const float* real, const float* imag, int frames,
                                      float* output, int output_capacity) {
    try {
        auto y = meanvc2lab::VocosIstft(real, imag, frames);
        if (output == nullptr || output_capacity < static_cast<int>(y.size())) return -2;
        std::copy(y.begin(), y.end(), output);
        return static_cast<int>(y.size());
    } catch (...) {
        return -1;
    }
}
