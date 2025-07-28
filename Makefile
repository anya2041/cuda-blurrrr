TARGET = blur_detect
SRC = blur_detect.cu

# Compiler and flags
NVCC = nvcc
NVCC_FLAGS = -O2 -std=c++17 `pkg-config opencv4 --cflags --libs`

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) $(SRC) -o $(TARGET) $(NVCC_FLAGS)

# Run with default input and output
run: $(TARGET)
	./$(TARGET) input_images/ output.csv

# Clean compiled files
clean:
	rm -f $(TARGET)


#PLS READ THIS :
#Imp Notes:
#blur_detect.cu: Replace with your actual .cu file name

#input_images/: Replace with your actual input folder

#output.csv: Replace with your desired CSV filename