.PHONY: test test1 test1_unopt test1_opt test2 test2_unopt test2_opt

all: libcicc.so libnvcc.so

libcicc.so: cicc.cpp
	g++ -g -O3 -std=c++11 -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -I/home/danwong/apps/llvm38/include -I/home/danwong/apps/cuda80/nvvm/include/ -fPIC $< -shared -o $@ -ldl -L/home/danwong/apps/llvm38/lib -Wl,--start-group -lLLVMCore -lLLVMSupport -lLLVMipo -lLLVMAnalysis -lLLVMTarget -lLLVMScalarOpts -lLLVMTransformUtils -lLLVMInstCombine -Wl,--end-group -lpthread

libnvcc.so: nvcc.cpp
	g++ -g -O3 -std=c++11  -I/opt/cuda/nvvm/include/ -fPIC $< -shared -o $@ -ldl

clean:
	rm -rf libcicc.so libnvcc.so

test: test1 test2

test1: test1_unopt test1_opt

test1_unopt: libcicc.so libnvcc.so
	CICC_MODIFY_UNOPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test1.cu -rdc=true -c -keep

test1_opt: libcicc.so libnvcc.so
	CICC_MODIFY_OPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test1.cu -rdc=true -c -keep

test2: test2_unopt test2_opt

test2_unopt: libcicc.so libnvcc.so
	CICC_MODIFY_UNOPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test2.cu -rdc=true -c -keep

test2_opt: libcicc.so libnvcc.so
	CICC_MODIFY_OPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test2.cu -rdc=true -c -keep

