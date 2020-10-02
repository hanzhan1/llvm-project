#include "clang/Basic/Cuda.h"

#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/VersionTuple.h"

namespace clang {

const char *CudaVersionToString(CudaVersion V) {
  switch (V) {
  case CudaVersion::UNKNOWN:
    return "unknown";
  case CudaVersion::CUDA_70:
    return "7.0";
  case CudaVersion::CUDA_75:
    return "7.5";
  case CudaVersion::CUDA_80:
    return "8.0";
  case CudaVersion::CUDA_90:
    return "9.0";
  case CudaVersion::CUDA_91:
    return "9.1";
  case CudaVersion::CUDA_92:
    return "9.2";
  case CudaVersion::CUDA_100:
    return "10.0";
  case CudaVersion::CUDA_101:
    return "10.1";
  case CudaVersion::CUDA_102:
    return "10.2";
  case CudaVersion::CUDA_110:
    return "11.0";
  }
  llvm_unreachable("invalid enum");
}

CudaVersion CudaStringToVersion(const llvm::Twine &S) {
  return llvm::StringSwitch<CudaVersion>(S.str())
      .Case("7.0", CudaVersion::CUDA_70)
      .Case("7.5", CudaVersion::CUDA_75)
      .Case("8.0", CudaVersion::CUDA_80)
      .Case("9.0", CudaVersion::CUDA_90)
      .Case("9.1", CudaVersion::CUDA_91)
      .Case("9.2", CudaVersion::CUDA_92)
      .Case("10.0", CudaVersion::CUDA_100)
      .Case("10.1", CudaVersion::CUDA_101)
      .Case("10.2", CudaVersion::CUDA_102)
      .Case("11.0", CudaVersion::CUDA_110)
      .Default(CudaVersion::UNKNOWN);
}

struct CudaArchToStringMap {
  CudaArch arch;
  const char *arch_name;
  const char *virtual_arch_name;
};

#define SM2(sm, ca)                                                            \
  { CudaArch::SM_##sm, "sm_" #sm, ca }
#define SM(sm) SM2(sm, "compute_" #sm)
#define GFX(gpu)                                                               \
  { CudaArch::GFX##gpu, "gfx" #gpu, "compute_amdgcn" }
CudaArchToStringMap arch_names[] = {
    // clang-format off
    {CudaArch::UNUSED, "", ""},
    SM2(20, "compute_20"), SM2(21, "compute_20"), // Fermi
    SM(30), SM(32), SM(35), SM(37),  // Kepler
    SM(50), SM(52), SM(53),          // Maxwell
    SM(60), SM(61), SM(62),          // Pascal
    SM(70), SM(72),                  // Volta
    SM(75),                          // Turing
    SM(80),                          // Ampere
    GFX(600), // tahiti
    GFX(601), // pitcairn, verde, oland,hainan
    GFX(700), // kaveri
    GFX(701), // hawaii
    GFX(702), // 290,290x,R390,R390x
    GFX(703), // kabini mullins
    GFX(704), // bonaire
    GFX(801), // carrizo
    GFX(802), // tonga,iceland
    GFX(803), // fiji,polaris10
    GFX(810), // stoney
    GFX(900), // vega, instinct
    GFX(902), GFX(904), GFX(906), GFX(908), GFX(909),
    GFX(1010), GFX(1011), GFX(1012), GFX(1030), GFX(1031)
    // clang-format on
};
#undef SM
#undef SM2
#undef GFX

const char *CudaArchToString(CudaArch A) {
  auto result = std::find_if(
      std::begin(arch_names), std::end(arch_names),
      [A](const CudaArchToStringMap &map) { return A == map.arch; });
  if (result == std::end(arch_names))
    return "unknown";
  return result->arch_name;
}

const char *CudaArchToVirtualArchString(CudaArch A) {
  auto result = std::find_if(
      std::begin(arch_names), std::end(arch_names),
      [A](const CudaArchToStringMap &map) { return A == map.arch; });
  if (result == std::end(arch_names))
    return "unknown";
  return result->virtual_arch_name;
}

CudaArch StringToCudaArch(llvm::StringRef S) {
  auto result = std::find_if(
      std::begin(arch_names), std::end(arch_names),
      [S](const CudaArchToStringMap &map) { return S == map.arch_name; });
  if (result == std::end(arch_names))
    return CudaArch::UNKNOWN;
  return result->arch;
}

CudaVersion MinVersionForCudaArch(CudaArch A) {
  if (A == CudaArch::UNKNOWN)
    return CudaVersion::UNKNOWN;

  // AMD GPUs do not depend on CUDA versions.
  if (IsAMDGpuArch(A))
    return CudaVersion::CUDA_70;

  switch (A) {
  case CudaArch::SM_20:
  case CudaArch::SM_21:
  case CudaArch::SM_30:
  case CudaArch::SM_32:
  case CudaArch::SM_35:
  case CudaArch::SM_37:
  case CudaArch::SM_50:
  case CudaArch::SM_52:
  case CudaArch::SM_53:
    return CudaVersion::CUDA_70;
  case CudaArch::SM_60:
  case CudaArch::SM_61:
  case CudaArch::SM_62:
    return CudaVersion::CUDA_80;
  case CudaArch::SM_70:
    return CudaVersion::CUDA_90;
  case CudaArch::SM_72:
    return CudaVersion::CUDA_91;
  case CudaArch::SM_75:
    return CudaVersion::CUDA_100;
  case CudaArch::SM_80:
    return CudaVersion::CUDA_110;
  default:
    llvm_unreachable("invalid enum");
  }
}

CudaVersion MaxVersionForCudaArch(CudaArch A) {
  // AMD GPUs do not depend on CUDA versions.
  if (IsAMDGpuArch(A))
    return CudaVersion::LATEST;

  switch (A) {
  case CudaArch::UNKNOWN:
    return CudaVersion::UNKNOWN;
  case CudaArch::SM_20:
  case CudaArch::SM_21:
    return CudaVersion::CUDA_80;
  default:
    return CudaVersion::LATEST;
  }
}

CudaVersion ToCudaVersion(llvm::VersionTuple Version) {
  int IVer =
      Version.getMajor() * 10 + Version.getMinor().getValueOr(0);
  switch(IVer) {
  case 70:
    return CudaVersion::CUDA_70;
  case 75:
    return CudaVersion::CUDA_75;
  case 80:
    return CudaVersion::CUDA_80;
  case 90:
    return CudaVersion::CUDA_90;
  case 91:
    return CudaVersion::CUDA_91;
  case 92:
    return CudaVersion::CUDA_92;
  case 100:
    return CudaVersion::CUDA_100;
  case 101:
    return CudaVersion::CUDA_101;
  case 102:
    return CudaVersion::CUDA_102;
  case 110:
    return CudaVersion::CUDA_110;
  default:
    return CudaVersion::UNKNOWN;
  }
}

bool CudaFeatureEnabled(llvm::VersionTuple  Version, CudaFeature Feature) {
  return CudaFeatureEnabled(ToCudaVersion(Version), Feature);
}

bool CudaFeatureEnabled(CudaVersion Version, CudaFeature Feature) {
  switch (Feature) {
  case CudaFeature::CUDA_USES_NEW_LAUNCH:
    return Version >= CudaVersion::CUDA_92;
  case CudaFeature::CUDA_USES_FATBIN_REGISTER_END:
    return Version >= CudaVersion::CUDA_101;
  }
  llvm_unreachable("Unknown CUDA feature.");
}
} // namespace clang
