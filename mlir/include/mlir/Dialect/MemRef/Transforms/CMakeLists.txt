set(LLVM_TARGET_DEFINITIONS Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls -name MemRef)
add_public_tablegen_target(MLIRMemRefPassIncGen)
add_dependencies(mlir-headers MLIRMemRefPassIncGen)

add_mlir_doc(Passes MemRefPasses ./ -gen-pass-doc)
